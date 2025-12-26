import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../insights/data/blog_repo.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentHighlight = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch blogs for Featured Insight
    final blogsAsync = ref.watch(blogPostsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false, // Let content flow behind bottom nav
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Spacing for glass nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildPremiumHeader(context),
              ),
              const SizedBox(height: 24),
              // Hero Section - Highlights Carousel
              SizedBox(
                height: 200,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentHighlight = index;
                    });
                  },
                  padEnds: false, // Start from left padding
                  children: [
                    _buildHeroCard(
                      context,
                      'Expert Legal Advice',
                      'Protecting your future with proven expertise.',
                      AppColors.primary,
                      Icons.shield_outlined,
                      '/appointment',
                      'Book Now',
                    ),
                     _buildHeroCard(
                      context,
                      'Corporate Solutions',
                      'Strategic counsel for growing businesses.',
                      AppColors.accentDark,
                      Icons.business,
                      '/services',
                      'Learn More',
                    ),
                     _buildHeroCard(
                      context,
                      'Family Law',
                      'Compassionate support for personal matters.',
                      Colors.teal.shade700,
                      Icons.family_restroom,
                      '/services',
                      'See Services',
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 16),
               Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentHighlight == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentHighlight == index
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 32),
              
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickAction(context, Icons.calendar_today, 'Book', () => context.go('/appointment')),
                        _buildQuickAction(context, Icons.grid_view, 'Services', () => context.go('/services')),
                        _buildQuickAction(context, Icons.people, 'Team', () => context.go('/team')),
                         _buildQuickAction(context, Icons.article, 'Insights', () => context.go('/insights')),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Featured Insight
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Insight',
                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                         TextButton(
                          onPressed: () => context.go('/insights'),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    blogsAsync.when(
                      data: (posts) {
                         if (posts.isEmpty) {
                          return _buildEmptyStateBox('No insights yet.');
                        }
                        final featured = posts.first;
                        return _buildFeaturedInsightCard(context, featured);
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => _buildEmptyStateBox('Could not load insights.'),
                    ),
                  ],
                ),
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
                fontFamily: 'serif', // Or your specific premium font
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Excellence in Law'.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.0,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
            color: Colors.black87,
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
      String ctaText,
    ) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 8), // Padding handling for pageview
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
             color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
           Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
             style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
           InkWell(
             onTap: () => context.go(route),
             child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(20),
               ),
               child: Text(
                 ctaText,
                 style: TextStyle(
                   color: color,
                   fontWeight: FontWeight.bold,
                   fontSize: 12,
                 ),
               ),
             ),
           )
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
       borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
               color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
               boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 8),
           Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildFeaturedInsightCard(BuildContext context, dynamic post) { // Using dynamic to avoid import loop issues if domain not exported, but we imported repo so it should be fine. Actually post is BlogPost.
    return InkWell(
      onTap: () => context.go('/insights/detail', extra: post),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
           color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Image
             ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade100,
                child: post.coverImageUrl != null
                  ? Image.network(post.coverImageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.article, color: Colors.grey))
                  : const Icon(Icons.article, color: Colors.grey),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      post.category?.toUpperCase() ?? 'INSIGHTS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentDark,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Colors.grey),
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
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(message, style: TextStyle(color: Colors.grey.shade600)),
    );
  }
}
