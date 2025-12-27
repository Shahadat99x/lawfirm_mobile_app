import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSearchPill extends StatelessWidget {
  final VoidCallback onTap;
  final String placeholder;

  const GlassSearchPill({
    super.key,
    required this.onTap,
    this.placeholder = 'Search services, insights, team...',
  });

  @override
  Widget build(BuildContext context) {
    // Determine opacity based on theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgOpacity = isDark ? 0.30 : 0.70; 
    final borderOpacity = isDark ? 0.15 : 0.10;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 52, // Slightly taller for premium feel
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(bgOpacity),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(borderOpacity),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    placeholder,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
