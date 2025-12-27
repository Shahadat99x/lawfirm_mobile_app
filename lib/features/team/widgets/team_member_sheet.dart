import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lexnova/shared/widgets/glass_icon_button.dart';
import '../domain/lawyer.dart';

class TeamMemberSheet extends StatelessWidget {
  final Lawyer lawyer;

  const TeamMemberSheet({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    // 90% screen height, or draggable max
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Stack(
            children: [
              // Content
              CustomScrollView(
                controller: scrollController,
                slivers: [
                   // Spacing for header
                   const SliverToBoxAdapter(child: SizedBox(height: 80)),
                   
                   SliverPadding(
                     padding: const EdgeInsets.symmetric(horizontal: 24),
                     sliver: SliverList(
                       delegate: SliverChildListDelegate([
                          // Header Info (Name, Role, Photo)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               CircleAvatar(
                                radius: 40,
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                backgroundImage: lawyer.photoUrl != null
                                    ? NetworkImage(lawyer.photoUrl!)
                                    : null,
                                child: lawyer.photoUrl == null
                                    ? Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant)
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lawyer.name,
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      lawyer.title,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),

                          // Languages
                          if (lawyer.languages != null && lawyer.languages!.isNotEmpty) ...[
                            Text(
                              'Languages',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: lawyer.languages!.map((lang) {
                                return Chip(
                                  label: Text(lang),
                                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  side: BorderSide.none,
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 12,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Biography
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (lawyer.bio != null && lawyer.bio!.isNotEmpty)
                            MarkdownBody(
                              data: lawyer.bio!,
                               styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            )
                          else
                             Text(
                              'Biography coming soon.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          
                           // Extra padding for bottom CTA
                           const SizedBox(height: 100),
                       ]),
                     ),
                   ),
                ],
              ),

              // Close Button (Fixed Top Right)
              Positioned(
                top: 16,
                right: 16,
                child: GlassIconButton(
                  icon: Icons.close,
                  onTap: () => context.pop(),
                  size: 20,
                ),
              ),

              // Drag Handle (Fixed Top Center)
               Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Sticky Bottom CTA
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           context.pop(); // Close sheet first
                           context.go('/appointment'); // Navigate to booking
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Book Consultation'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
