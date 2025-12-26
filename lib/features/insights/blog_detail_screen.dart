import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../shared/theme/app_colors.dart';
import 'domain/blog_post.dart';
import 'package:intl/intl.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.coverImageUrl != null)
              Image.network(
                post.coverImageUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   if (post.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.category!,
                        style: const TextStyle(
                          color: AppColors.primary, // This might need check for dark mode readability, but accent bg is usually light enough or opacity helps.
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                       Icon(Icons.calendar_today, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        post.publishedAt != null
                            ? DateFormat.yMMMd().format(post.publishedAt!)
                            : 'Unknown Date',
                         style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      if (post.authorName != null) ...[
                        const SizedBox(width: 16),
                         Icon(Icons.person_outline, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                         const SizedBox(width: 4),
                        Text(
                          post.authorName!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (post.content != null)
                    MarkdownBody(
                      data: post.content!,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary, 
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary, 
                          fontWeight: FontWeight.bold,
                           height: 1.5,
                        ),
                        p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        blockquote: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        code: TextStyle(
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest, // or surfaceVariant
                          borderRadius: BorderRadius.circular(8),
                        )
                      ),
                    )
                  else
                    const Text('No content available.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
