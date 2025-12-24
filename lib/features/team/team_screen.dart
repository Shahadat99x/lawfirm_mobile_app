import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/lawyer_repo.dart';
import 'domain/lawyer.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawyersAsync = ref.watch(lawyersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Our Team')),
      body: lawyersAsync.when(
        data: (lawyers) {
          if (lawyers.isEmpty) {
            return const Center(child: Text('No team members found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lawyers.length,
            itemBuilder: (context, index) {
              final lawyer = lawyers[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    // Navigate to detail if needed, or expand
                    // For now simple list as requested
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: lawyer.photoUrl != null
                              ? NetworkImage(lawyer.photoUrl!)
                              : null,
                          child: lawyer.photoUrl == null
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lawyer.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                lawyer.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                              if (lawyer.languages != null && lawyer.languages!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: lawyer.languages!.map((lang) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          lang,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load team'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(lawyersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
