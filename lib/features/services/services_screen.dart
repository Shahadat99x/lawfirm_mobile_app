import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/practice_area_repo.dart';
import 'domain/practice_area.dart';

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
      appBar: AppBar(title: const Text('Our Services')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(practiceAreasProvider);
          await Future.delayed(const Duration(seconds: 1));
        },
        child: servicesAsync.when(
          data: (originalServices) {
            // Filter Logic
            final filteredServices = originalServices.where((service) {
              final matchesSearch = service.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  (service.excerpt?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
              
              final matchesFilter = selectedFilter == 'All'; 

              return matchesSearch && matchesFilter;
            }).toList();

            return Column(
              children: [
                // Search & Filter Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    children: [
                      SearchField(
                        hintText: 'Search services...',
                        onChanged: (val) => ref.read(serviceSearchProvider.notifier).state = val,
                        onClear: () {
                           ref.read(serviceSearchProvider.notifier).state = '';
                           ref.read(serviceFilterProvider.notifier).state = 'All';
                        },
                      ),
                      const SizedBox(height: 12),
                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All'].map((filter) {
                            final isSelected = selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (selected) {
                                  ref.read(serviceFilterProvider.notifier).state = filter;
                                },
                                backgroundColor: Theme.of(context).cardColor,
                                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: isSelected 
                                    ? Theme.of(context).colorScheme.onPrimaryContainer 
                                    : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                side: BorderSide(
                                  color: isSelected 
                                    ? Colors.transparent 
                                    : Theme.of(context).dividerColor.withOpacity(0.1),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Results Grid
                 Expanded(
                  child: filteredServices.isEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) => SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: constraints.maxHeight,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off, size: 48, color: Theme.of(context).colorScheme.outline),
                                    const SizedBox(height: 16),
                                    Text('No services found', style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 8),
                                    Text('Try a different keyword', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredServices.length,
                          itemBuilder: (context, index) {
                            final service = filteredServices[index];
                            return _AnimatedServiceCard(
                              key: ValueKey(service.id),
                              service: service
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load services'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.refresh(practiceAreasProvider),
                  child: const Text('Retry'),
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
  // Normalize slug just in case
  final s = slug.toLowerCase().trim();
  if (s.contains('corporate') || s.contains('business')) {
     return const _ServiceStyle(Icons.business_center_outlined, Color(0xFF1E88E5)); // Blue
  } else if (s.contains('real-estate') || s.contains('property')) {
     return const _ServiceStyle(Icons.house_outlined, Color(0xFF43A047)); // Green
  } else if (s.contains('litigation') || s.contains('dispute')) {
     return const _ServiceStyle(Icons.gavel_outlined, Color(0xFFE53935)); // Red
  } else if (s.contains('intellectual') || s.contains('ip')) {
     return const _ServiceStyle(Icons.lightbulb_outline, Color(0xFF8E24AA)); // Purple
  } else if (s.contains('family') || s.contains('divorce')) {
     return const _ServiceStyle(Icons.family_restroom, Color(0xFFD81B60)); // Pink
  } else if (s.contains('tax') || s.contains('financial')) {
     return const _ServiceStyle(Icons.calculate_outlined, Color(0xFF00897B)); // Teal
  } else if (s.contains('criminal')) {
     return const _ServiceStyle(Icons.policy_outlined, Color(0xFF546E7A)); // BlueGrey
  } else if (s.contains('employ')) {
     return const _ServiceStyle(Icons.badge_outlined, Color(0xFFF57C00)); // Orange
  }
  return const _ServiceStyle(Icons.balance_outlined, Color(0xFF0A2540)); // Default Navy
}

class _AnimatedServiceCard extends StatefulWidget {
  final PracticeArea service;
  const _AnimatedServiceCard({super.key, required this.service});

  @override
  State<_AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<_AnimatedServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(_controller);
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
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04), // Subtle shadow
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Accent Strip
                Container(height: 4, color: style.color),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Badge
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: style.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(style.icon, color: style.color, size: 24),
                        ),
                        const SizedBox(height: 16),
                        
                        // Title
                        Text(
                          widget.service.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        
                        // Excerpt
                        if (widget.service.excerpt != null)
                          Text(
                            widget.service.excerpt!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                        const Spacer(),
                        
                        // Footer
                         Row(
                          children: [
                            Text(
                              'Learn more',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
