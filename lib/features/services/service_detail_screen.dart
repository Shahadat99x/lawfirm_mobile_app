import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../shared/theme/app_colors.dart';
import 'domain/practice_area.dart';

class ServiceDetailScreen extends StatelessWidget {
  final PracticeArea service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (service.icon != null) const SizedBox.shrink(),

            Text(
              service.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            if (service.content != null)
              MarkdownBody(
                data: service.content!,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                      h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                      h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                      p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      code: const TextStyle(
                        backgroundColor: Color(0xFFEFF3F6),
                        fontFamily: 'monospace',
                      ),
                    ),
              )
            else
              const Text('No details available.'),
          ],
        ),
      ),
    );
  }
}
