import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  final String assetPath;

  const LegalScreen({super.key, required this.title, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Failed to load $title'),
                ],
              ),
            );
          }

          return Markdown(
            data: snapshot.data!,
            selectable: true,
            padding: const EdgeInsets.all(16),
            onTapLink: (text, href, title) async {
              if (href != null) {
                final uri = Uri.tryParse(href);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              }
            },
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  h2: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  h2Padding: const EdgeInsets.only(top: 24, bottom: 8),
                  p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  blockquote: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border(
                      left: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 4,
                      ),
                    ),
                  ),
                ),
          );
        },
      ),
    );
  }
}
