import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'data/blog_repo.dart';
import 'domain/blog_post.dart';
import '../../shared/theme/app_colors.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogsAsync = ref.watch(blogPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: blogsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No insights available.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _BlogCard(post: post);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const Text('Failed to load insights'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(blogPostsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogPost post;

  const _BlogCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.go('/insights/detail', extra: post),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.coverImageUrl != null)
              Image.network(
                post.coverImageUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
                     color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.category != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        post.category!.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.accentDark,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (post.excerpt != null)
                    Text(
                      post.excerpt!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                   const SizedBox(height: 12),
                  Row(
                    children: [
                       Text(
                        post.publishedAt != null
                            ? DateFormat.yMMMd().format(post.publishedAt!)
                            : '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        'Read More',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
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
