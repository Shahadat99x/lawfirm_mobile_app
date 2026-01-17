import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexnova/l10n/app_localizations.dart';
import 'data/practice_area_repo.dart';
import 'domain/practice_area.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/search_field.dart';

// State Providers for local search/filter
final serviceSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final serviceFilterProvider = StateProvider.autoDispose<String>((ref) => 'All');

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(practiceAreasProvider);
    final searchQuery = ref.watch(serviceSearchProvider);
    final selectedFilter = ref.watch(serviceFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Premium off-white
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom Header & Search Fixed at Top (or scrollable? Let's keep fixed for easy access)
            // Ideally, we want the search to scroll away for more space, but fixed is safer for "app feel".
            // Let's make it fully scrollable for a cleaner look.
            // We'll put everything in a NestedScrollView or just a Column inside SingleChild if we didn't have GridView.
            // Since we have a GridView, we can use CustomScrollView with Slivers.
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(practiceAreasProvider);
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Premium Header
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.servicesTitle.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Expert Legal Solutions',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Search Field
                            SearchField(
                              hintText: AppLocalizations.of(
                                context,
                              )!.servicesSearchHint,
                              onChanged: (val) =>
                                  ref
                                          .read(serviceSearchProvider.notifier)
                                          .state =
                                      val,
                              onClear: () {
                                ref.read(serviceSearchProvider.notifier).state =
                                    '';
                                ref.read(serviceFilterProvider.notifier).state =
                                    'All';
                              },
                            ),
                            const SizedBox(height: 16),
                            // Filter Chips (Simplified for layout)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    [
                                      AppLocalizations.of(
                                        context,
                                      )!.servicesFilterAll,
                                    ].map((filter) {
                                      final isSelected =
                                          selectedFilter == 'All';
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: FilterChip(
                                          label: Text(filter),
                                          selected: isSelected,
                                          onSelected: (selected) {},
                                          backgroundColor: Colors.white,
                                          selectedColor: AppColors.primary
                                              .withOpacity(0.1),
                                          labelStyle: TextStyle(
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.grey.shade700,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            side: BorderSide(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : Colors.grey.shade200,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    servicesAsync.when(
                      data: (originalServices) {
                        final filteredServices = originalServices.where((
                          service,
                        ) {
                          final matchesSearch =
                              service.title.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ) ||
                              (service.excerpt?.toLowerCase().contains(
                                    searchQuery.toLowerCase(),
                                  ) ??
                                  false);
                          return matchesSearch;
                        }).toList();

                        if (filteredServices.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)!.servicesEmpty,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            120,
                          ), // Fix Padding Clipping
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.8, // Taller cards
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final service = filteredServices[index];
                              return _PremiumServiceCard(service: service);
                            }, childCount: filteredServices.length),
                          ),
                        );
                      },
                      loading: () => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (err, stack) => SliverFillRemaining(
                        child: Center(child: Text('Error: $err')),
                      ),
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
}

class _PremiumServiceCard extends StatefulWidget {
  final PracticeArea service;
  const _PremiumServiceCard({required this.service});

  @override
  State<_PremiumServiceCard> createState() => _PremiumServiceCardState();
}

class _PremiumServiceCardState extends State<_PremiumServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _getServiceStyle(widget.service.slug);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () => context.go('/services/detail', extra: widget.service),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: style.color.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: style.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(style.icon, color: style.color, size: 22),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  widget.service.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Excerpt
                if (widget.service.excerpt != null)
                  Expanded(
                    child: Text(
                      widget.service.excerpt!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  )
                else
                  const Spacer(),

                const SizedBox(height: 12),

                // Footer
                Row(
                  children: [
                    Text(
                      'Learn More',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: style.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: style.color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceStyle {
  final IconData icon;
  final Color color;
  const _ServiceStyle(this.icon, this.color);
}

_ServiceStyle _getServiceStyle(String slug) {
  final s = slug.toLowerCase().trim();
  if (s.contains('corporate') || s.contains('business')) {
    return const _ServiceStyle(
      Icons.business_center_outlined,
      Color(0xFF1E88E5),
    );
  } else if (s.contains('real-estate') || s.contains('property')) {
    return const _ServiceStyle(Icons.house_outlined, Color(0xFF43A047));
  } else if (s.contains('litigation') || s.contains('dispute')) {
    return const _ServiceStyle(Icons.gavel_outlined, Color(0xFFE53935));
  } else if (s.contains('intellectual') || s.contains('ip')) {
    return const _ServiceStyle(Icons.lightbulb_outline, Color(0xFF8E24AA));
  } else if (s.contains('family') || s.contains('divorce')) {
    return const _ServiceStyle(Icons.family_restroom, Color(0xFFD81B60));
  } else if (s.contains('tax') || s.contains('financial')) {
    return const _ServiceStyle(Icons.calculate_outlined, Color(0xFF00897B));
  } else if (s.contains('criminal')) {
    return const _ServiceStyle(Icons.policy_outlined, Color(0xFF546E7A));
  } else if (s.contains('employ')) {
    return const _ServiceStyle(Icons.badge_outlined, Color(0xFFF57C00));
  }
  return const _ServiceStyle(Icons.balance_outlined, Color(0xFF0A2540));
}
