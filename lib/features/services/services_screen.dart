import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/practice_area_repo.dart';
import 'domain/practice_area.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(practiceAreasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Our Services')),
      body: servicesAsync.when(
        data: (services) {
           if (services.isEmpty) {
            return const Center(child: Text('No services found.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8, // Taller cards
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceCard(service: service);
            },
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
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final PracticeArea service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.go('/services/detail', extra: service);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon placeholder or from data
              Icon(
                Icons.gavel_rounded, // Generic fallback
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                service.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (service.excerpt != null) ...[
                const SizedBox(height: 8),
                 Text(
                  service.excerpt!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
