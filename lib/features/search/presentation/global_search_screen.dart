import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexnova/features/insights/data/blog_repo.dart';
import 'package:lexnova/features/insights/domain/blog_post.dart';
import 'package:lexnova/features/services/data/practice_area_repo.dart';
import 'package:lexnova/features/services/domain/practice_area.dart';
import 'package:lexnova/features/team/data/lawyer_repo.dart';
import 'package:lexnova/features/team/domain/lawyer.dart';
import 'package:lexnova/shared/widgets/search_field.dart';

enum SearchTab { all, services, insights, team }

enum ResultType { service, insight, team }

class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final ResultType type;
  final Object originalObject;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.originalObject,
  });
}

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  String _query = '';
  SearchTab _selectedTab = SearchTab.all;
  Timer? _debounce;

  void _onQueryChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _query = val;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  List<SearchResult> _getResults({
    required List<PracticeArea> services,
    required List<BlogPost> posts,
    required List<Lawyer> lawyers,
  }) {
    if (_query.isEmpty) return [];

    final q = _query.toLowerCase();
    final results = <SearchResult>[];

    // 1. Services
    if (_selectedTab == SearchTab.all || _selectedTab == SearchTab.services) {
      for (final s in services) {
        if (s.title.toLowerCase().contains(q) ||
            (s.excerpt?.toLowerCase().contains(q) ?? false)) {
          results.add(SearchResult(
            id: s.id,
            title: s.title,
            subtitle: 'Service',
            type: ResultType.service,
            originalObject: s,
          ));
        }
      }
    }

    // 2. Insights
    if (_selectedTab == SearchTab.all || _selectedTab == SearchTab.insights) {
      for (final p in posts) {
        if (p.title.toLowerCase().contains(q) ||
            (p.category?.toLowerCase().contains(q) ?? false) ||
            (p.excerpt?.toLowerCase().contains(q) ?? false)) {
          results.add(SearchResult(
            id: p.id,
            title: p.title,
            subtitle: p.category ?? 'Insight',
            type: ResultType.insight,
            originalObject: p,
          ));
        }
      }
    }

    // 3. Team
    if (_selectedTab == SearchTab.all || _selectedTab == SearchTab.team) {
      for (final l in lawyers) {
        if (l.name.toLowerCase().contains(q) ||
            l.title.toLowerCase().contains(q)) {
          results.add(SearchResult(
            id: l.id,
            title: l.name,
            subtitle: l.title,
            type: ResultType.team,
            originalObject: l,
          ));
        }
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(practiceAreasProvider);
    final blogsAsync = ref.watch(blogPostsProvider);
    final lawyersAsync = ref.watch(lawyersProvider);

    final isLoading = servicesAsync.isLoading ||
        blogsAsync.isLoading ||
        lawyersAsync.isLoading;

    // Combine data nicely
    // Note: In a real app we might handle partial errors, here we just check if data is available
    final services = servicesAsync.valueOrNull ?? [];
    final posts = blogsAsync.valueOrNull ?? [];
    final lawyers = lawyersAsync.valueOrNull ?? [];

    final results = _getResults(
      services: services,
      posts: posts,
      lawyers: lawyers,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                   SearchField(
                    hintText: 'Search services, insights, team...',
                    initialValue: _query, // This doesn't auto-update text field if debounced
                    onChanged: _onQueryChanged,
                    onClear: () {
                       setState(() {
                        _query = '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', SearchTab.all),
                        const SizedBox(width: 8),
                        _buildFilterChip('Services', SearchTab.services),
                        const SizedBox(width: 8),
                        _buildFilterChip('Insights', SearchTab.insights),
                        const SizedBox(width: 8),
                        _buildFilterChip('Team', SearchTab.team),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildBody(isLoading, results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(bool isLoading, List<SearchResult> results) {
    if (_query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Theme.of(context).colorScheme.surfaceContainerHighest),
            const SizedBox(height: 16),
            Text(
              'Search for legal services,\ninsights, and experts.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (isLoading && results.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No results found for "$_query"', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildResultTile(result);
      },
    );
  }

  Widget _buildResultTile(SearchResult result) {
    IconData icon;
    Color iconColor;

    switch (result.type) {
      case ResultType.service:
        icon = Icons.shield_outlined;
        iconColor = Theme.of(context).colorScheme.primary;
        break;
      case ResultType.insight:
        icon = Icons.article_outlined;
        iconColor = Colors.orange;
        break;
      case ResultType.team:
        icon = Icons.person_outline;
        iconColor = Colors.teal;
        break;
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          result.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          result.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () => _handleNavigation(result),
      ),
    );
  }

  void _handleNavigation(SearchResult result) {
    switch (result.type) {
      case ResultType.service:
        context.go('/services/detail', extra: result.originalObject);
        break;
      case ResultType.insight:
        context.go('/insights/detail', extra: result.originalObject);
        break;
      case ResultType.team:
        context.go('/team');
        break;
    }
  }

  Widget _buildFilterChip(String label, SearchTab tab) {
    final isSelected = _selectedTab == tab;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedTab = tab;
          });
        }
      },
      backgroundColor: Theme.of(context).cardColor,
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? Colors.transparent : Theme.of(context).dividerColor.withOpacity(0.1),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
