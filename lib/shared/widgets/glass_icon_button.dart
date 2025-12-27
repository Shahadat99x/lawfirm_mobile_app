import 'dart:ui';
import 'package:flutter/material.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgOpacity = isDark ? 0.30 : 0.70;
    final borderOpacity = isDark ? 0.15 : 0.10;

    return ClipRRect(
      borderRadius: BorderRadius.circular(50), // Fully rounded / circle
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(10), // Adjust padding for touch target
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(bgOpacity),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(borderOpacity),
                width: 1,
              ),
               boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
