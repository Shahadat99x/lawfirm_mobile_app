import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String body;
  final Widget? snippet;
  final Widget? background;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.body,
    this.snippet,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        background ?? Stack(
          children: [
            Container(color: Theme.of(context).colorScheme.surface),
            // Hero Blob 1 (Top Left)
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),
             // Hero Blob 2 (Center Right)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                   color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                   boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60), // More top spacing for "premium" feel
                
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Body
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                    fontSize: 18, 
                  ),
                ),
                
                 const SizedBox(height: 48), // Spacing before snippet
                
                // Real Data Snippet (if provided)
                if (snippet != null)
                  Expanded( 
                    child: Center(
                      child: snippet!,
                    ),
                  ),
                  
                if (snippet == null) const Spacer(),
                
                const SizedBox(height: 100), // Bottom spacing for buttons/dots
              ],
            ),
          ),
        ),
      ],
    );
  }
}
