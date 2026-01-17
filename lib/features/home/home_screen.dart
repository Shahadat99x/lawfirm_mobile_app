import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lexnova/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../insights/data/blog_repo.dart';
import '../../shared/widgets/glass_search_pill.dart';
import '../../shared/widgets/glass_icon_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _heroPageController = PageController(
    viewportFraction: 0.9,
  );
  final PageController _insightsPageController = PageController(
    viewportFraction: 0.85,
  );

  int _currentHeroHighlight = 0;
  int _currentInsightIndex = 0;
  Timer? _insightsTimer;

  @override
  void initState() {
    super.initState();
    // Start auto-slide after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInsightsAutoSlide();
    });
  }

  void _startInsightsAutoSlide() {
    _insightsTimer?.cancel();
    _insightsTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_insightsPageController.hasClients) {
        final nextPage = _currentInsightIndex + 1;
        // We rely on the implicit loop logic in builder if we want infinite,
        // but for now let's just loop back to 0 if we hit the end, strictly based on item count.
        // However, since we don't know the exact count easily in the Timer usage without ref fetching...
        // ...Actually, we interact with the PageController.

        // A simple loop:
        _insightsPageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _heroPageController.dispose();
    _insightsPageController.dispose();
    _insightsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch blogs for Insights Carousel
    final blogsAsync = ref.watch(blogPostsProvider);

    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Slightly off-white for premium feel
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120), // Spacing for glass nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24), // More breathing room at top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildPremiumHeader(context),
              ),
              const SizedBox(height: 32),

              // Search Pill
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassSearchPill(onTap: () => context.push('/search')),
              ),
              const SizedBox(height: 32),

              // Hero Section - Highlights Carousel
              SizedBox(
                height: 220, // Slightly taller
                child: PageView(
                  controller: _heroPageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentHeroHighlight = index;
                    });
                  },
                  padEnds: false,
                  children: [
                    _buildHeroCard(
                      context,
                      'Expert Legal Advice',
                      'Protecting your future with proven expertise.',
                      AppColors.primary,
                      Icons.shield_outlined,
                      '/appointment',
                      'Book Consultation',
                      index: 0,
                    ),
                    _buildHeroCard(
                      context,
                      'Corporate Solutions',
                      'Strategic counsel for growing businesses.',
                      const Color(0xFF1E3A8A), // Deep Blue
                      Icons.business,
                      '/services',
                      'Explore Services',
                      index: 1,
                    ),
                    _buildHeroCard(
                      context,
                      'Family Law',
                      'Compassionate support for personal matters.',
                      const Color(0xFF0F766E), // Teal
                      Icons.family_restroom,
                      '/services',
                      'Learn More',
                      index: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Hero Indicators
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      width: _currentHeroHighlight == index ? 24 : 12,
                      decoration: BoxDecoration(
                        color: _currentHeroHighlight == index
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 40),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.homeQuickActions.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickAction(
                          context,
                          Icons
                              .calendar_today_outlined, // Outlined icons usually look more premium
                          AppLocalizations.of(context)!.navBook,
                          () => context.go('/appointment'),
                        ),
                        _buildQuickAction(
                          context,
                          Icons.grid_view,
                          AppLocalizations.of(context)!.navServices,
                          () => context.go('/services'),
                        ),
                        _buildQuickAction(
                          context,
                          Icons.groups_outlined,
                          'Team',
                          () => context.go('/team'),
                        ),
                        _buildQuickAction(
                          context,
                          Icons.article_outlined,
                          AppLocalizations.of(context)!.navInsights,
                          () => context.go('/insights'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Auto-Sliding Insights
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.homeLatestInsights,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight
                                    .bold, // Serif recommended if available, but Bold Sans is okay
                                color: AppColors.primary,
                              ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/insights'),
                          child: Text(
                            AppLocalizations.of(context)!.homeViewAll,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  blogsAsync.when(
                    data: (posts) {
                      if (posts.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildEmptyStateBox('No insights yet.'),
                        );
                      }

                      return SizedBox(
                        height: 280, // Taller card to show image nicely
                        child: PageView.builder(
                          controller: _insightsPageController,
                          padEnds:
                              false, // Start from left to match header alignment
                          itemBuilder: (context, index) {
                            // Modulo for infinite looping effect
                            final postIndex = index % posts.length;
                            final post = posts[postIndex];

                            // Update current index for other logic if needed (like dots)
                            // Note: Doing setState in builder during build is risky,
                            // usually we use onPageChanged.

                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 8,
                              ),
                              child: _buildPremiumInsightCard(context, post),
                            );
                          },
                          onPageChanged: (index) {
                            _currentInsightIndex = index;
                          },
                        ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildEmptyStateBox('Could not load insights.'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LEXNOVA',
              style: TextStyle(
                fontFamily:
                    'serif', // Requires a serif font setup, usually system serif works
                fontSize: 28,
                fontWeight: FontWeight.w900, // Extra bold
                letterSpacing: 1.5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Row(
              children: [
                Container(width: 30, height: 1, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(
                  'EXCELLENCE IN LAW',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
    String route,
    String ctaText, {
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.2)!],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => context.go(route),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                ctaText.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumInsightCard(BuildContext context, dynamic post) {
    return GestureDetector(
      onTap: () => context.go('/insights/detail', extra: post),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  post.coverImageUrl != null
                      ? Image.network(
                          post.coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey.shade200),
                        )
                      : Container(
                          color: AppColors.primary.withOpacity(0.05),
                          child: Icon(
                            Icons.article_outlined,
                            size: 40,
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                  // Gradient Overlay for text readability if text were on image
                  // But here we put text below.
                  // Let's add a "New" badge or Category chip overlay
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.category?.toUpperCase() ?? 'INSIGHTS',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text Area
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Read More',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateBox(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(message, style: const TextStyle(color: Colors.grey)),
    );
  }
}
