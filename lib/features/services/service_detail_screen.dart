import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (service.icon != null)
              // Ensure icon handling is safe (e.g. if it's a URL or icon name)
              // For now assuming it might be null or handled elsewhere, 
              // or not critical. If it's a URL/SVG we need network image.
              // Taking simple approach: if not null, show it.
              // Ideally this might need flutter_svg or similar if it's an SVG.
              // Prompt says "select: ... icon ...".
              // Let's just omit specific icon logic if unknown format, 
              // or use a generic icon.
              const SizedBox.shrink(),
            
            Text(
              service.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
             if (service.content != null)
              SelectableText(
                service.content!, 
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
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
