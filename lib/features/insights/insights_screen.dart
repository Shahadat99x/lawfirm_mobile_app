import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lexnova/l10n/app_localizations.dart';
import 'data/blog_repo.dart';
import 'domain/blog_post.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/search_field.dart';

enum SortOption { latest, oldest }

final insightSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final insightSortProvider = StateProvider.autoDispose<SortOption>(
  (ref) => SortOption.latest,
);

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogsAsync = ref.watch(blogPostsProvider);
    final searchQuery = ref.watch(insightSearchProvider);
    final sortOption = ref.watch(insightSortProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(blogPostsProvider);
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            slivers: [
              // 1. Header & Search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LEXNOVA INSIGHTS',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Legal updates & expert analysis',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          // Sort Button
                          PopupMenuButton<SortOption>(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
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
                              child: Icon(
                                Icons.sort,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            onSelected: (val) =>
                                ref.read(insightSortProvider.notifier).state =
                                    val,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: SortOption.latest,
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.insightsSortLatest,
                                ),
                              ),
                              PopupMenuItem(
                                value: SortOption.oldest,
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.insightsSortOldest,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SearchField(
                        hintText: AppLocalizations.of(
                          context,
                        )!.insightsSearchHint,
                        onChanged: (val) =>
                            ref.read(insightSearchProvider.notifier).state =
                                val,
                        onClear: () =>
                            ref.read(insightSearchProvider.notifier).state = '',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // 2. Content
              blogsAsync.when(
                data: (posts) {
                  // Filter & Sort
                  var filtered = posts.where((p) {
                    final q = searchQuery.toLowerCase();
                    return p.title.toLowerCase().contains(q) ||
                        (p.category?.toLowerCase().contains(q) ?? false) ||
                        (p.excerpt?.toLowerCase().contains(q) ?? false);
                  }).toList();

                  filtered.sort((a, b) {
                    final dateA = a.publishedAt ?? DateTime(0);
                    final dateB = b.publishedAt ?? DateTime(0);
                    return sortOption == SortOption.latest
                        ? dateB.compareTo(dateA)
                        : dateA.compareTo(dateB);
                  });

                  if (filtered.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.insightsEmpty,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    );
                  }

                  // Split into Hero (1st) and List (Rest)
                  // Use filtered list for display
                  final heroPost = filtered.first;
                  final otherPosts = filtered.length > 1
                      ? filtered.sublist(1)
                      : <BlogPost>[];

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Index 0: Section Title + Hero
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (searchQuery.isEmpty) ...[
                                  Text(
                                    'FEATURED STORY',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _HeroInsightCard(post: heroPost),
                                  const SizedBox(height: 32),
                                ],
                                if (otherPosts.isNotEmpty)
                                  Text(
                                    'LATEST UPDATES',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          );
                        }

                        // Remaining items
                        final listIndex = index - 1;
                        if (listIndex >= otherPosts.length) return null;

                        // Handle case where search means we might not show standard hero label layout
                        // Simpler logic: if search is active, show all as standard list?
                        // Actually, strict "filtered" logic above handles it.
                        // If search matches 1 item, otherPosts is empty.
                        // Ideally we rely on index logic.

                        final post = otherPosts[listIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _PremiumBlogCard(post: post),
                        );
                      },
                      // Count: 1 (Hero header block) + others count
                      // But if search query is active, maybe we don't want "FEATURED".
                      // For MVP, simpler is to just treat first as hero always.
                      childCount: 1 + otherPosts.length,
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverFillRemaining(
                  child: Center(child: Text('Failed to load insights')),
                ),
              ),

              // Bottom Padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroInsightCard extends StatelessWidget {
  final BlogPost post;
  const _HeroInsightCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/insights/detail', extra: post),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(
                0.15,
              ), // Stronger shadow for hero
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                post.coverImageUrl != null
                    ? Image.network(
                        post.coverImageUrl!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 220,
                        color: AppColors.primary.withOpacity(0.05),
                        child: const Center(
                          child: Icon(
                            Icons.article_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.category?.toUpperCase() ?? 'UPDATE',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (post.excerpt != null)
                    Text(
                      post.excerpt!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        post.publishedAt != null
                            ? DateFormat.yMMMd().format(post.publishedAt!)
                            : '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Read Article',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumBlogCard extends StatelessWidget {
  final BlogPost post;
  const _PremiumBlogCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/insights/detail', extra: post),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumb
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade100,
                    child: post.coverImageUrl != null
                        ? Image.network(post.coverImageUrl!, fit: BoxFit.cover)
                        : const Icon(
                            Icons.article_outlined,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.category?.toUpperCase() ?? 'INSIGHTS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentDark,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Meta
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.publishedAt != null
                                ? DateFormat.MMMd().format(post.publishedAt!)
                                : '',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
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
