import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexnova/shared/storage/app_prefs.dart';
import 'widgets/onboarding_page.dart';
import '../../services/data/practice_area_repo.dart';
import '../../team/data/lawyer_repo.dart';
import '../../services/domain/practice_area.dart';
import '../../team/domain/lawyer.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinish();
    }
  }

  void _onFinish() {
    ref.read(appPrefsProvider).setOnboardingSeen();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              // Page 1: Services
              OnboardingPage(
                title: 'Find the right legal service',
                body: 'Explore practice areas and get clear next steps.',
                snippet: _ServicesSnippet(ref: ref),
              ),
              // Page 2: Experts
              OnboardingPage(
                title: 'Work with trusted experts',
                body: 'Confidential support from experienced lawyers.',
                snippet: _ExpertsSnippet(ref: ref),
              ),
              // Page 3: Booking
              const OnboardingPage(
                title: 'Book a consultation in minutes',
                body: 'Choose a date, pick a slot, and send your request.',
                snippet: _BookingSnippet(),
              ),
            ],
          ),

          // Skip Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: AnimatedOpacity(
              opacity: _currentPage == 2 ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: TextButton(
                onPressed: _currentPage == 2 ? null : _onFinish,
                child: const Text('Skip'),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dots
                Row(
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                // Next Button
                ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Icon(
                    _currentPage == 2 ? Icons.check : Icons.arrow_forward,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Snippets ---

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ServicesSnippet extends StatelessWidget {
  final WidgetRef ref;
  const _ServicesSnippet({required this.ref});

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(practiceAreasProvider);
    
    return _GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text('Popular Services', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          servicesAsync.when(
            data: (services) {
              final display = services.take(3).toList();
              if (display.isEmpty) return const Text('Loading services...');
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: display.map((s) => Chip(
                  label: Text(s.title),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                )).toList(),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_,__) => const Text('Unable to load services'),
          ),
        ],
      ),
    );
  }
}

class _ExpertsSnippet extends StatelessWidget {
   final WidgetRef ref;
  const _ExpertsSnippet({required this.ref});

  @override
  Widget build(BuildContext context) {
     final lawyersAsync = ref.watch(lawyersProvider);
     
     return Column(
       mainAxisSize: MainAxisSize.min,
       children: [
         _GlassCard(
           child: lawyersAsync.when(
             data: (lawyers) {
               if (lawyers.isEmpty) return const Text('Connecting...');
               final lawyer = lawyers.first;
               return Row(
                 children: [
                   CircleAvatar(
                     radius: 24,
                     backgroundImage: lawyer.photoUrl != null ? NetworkImage(lawyer.photoUrl!) : null,
                     child: lawyer.photoUrl == null ? const Icon(Icons.person) : null,
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(lawyer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                         const SizedBox(height: 4),
                         Text(lawyer.title, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                       ],
                     ),
                   ),
                   Icon(Icons.verified, color: Theme.of(context).colorScheme.primary, size: 20),
                 ],
               );
             },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_,__) => const SizedBox(),
           ),
         ),
         const SizedBox(height: 16),
         Wrap(
           spacing: 8,
           runSpacing: 8,
           alignment: WrapAlignment.center,
           children: [
             _trustChip(context, Icons.lock_outline, 'Secure'),
             _trustChip(context, Icons.visibility_off_outlined, 'Confidential'),
             _trustChip(context, Icons.bolt, 'Fast'),
           ],
         )
       ],
     );
  }
  
  Widget _trustChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _BookingSnippet extends StatelessWidget {
  const _BookingSnippet();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           _step(context, Icons.calendar_today_rounded, 'Select Date', true),
           Container(
             margin: const EdgeInsets.only(left: 20),
             height: 20,
             width: 1,
             color: Theme.of(context).dividerColor,
           ),
           _step(context, Icons.access_time_rounded, 'Pick Time Slot', true),
           Container(
             margin: const EdgeInsets.only(left: 20),
             height: 20,
             width: 1,
             color: Theme.of(context).dividerColor,
           ),
           _step(context, Icons.check_circle_outline_rounded, 'Confirm Request', false),
         ],
       ),
    );
  }
  
  Widget _step(BuildContext context, IconData icon, String label, bool active) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(active ? 0.1 : 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Text(
          label, 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface,
          )
        ),
      ],
    );
  }
}
