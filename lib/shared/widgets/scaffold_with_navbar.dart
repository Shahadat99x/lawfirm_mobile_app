import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:lexnova/l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true, // Important for glass effect
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          // If you want rounded corners on top, uncomment below
          // borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }
                  return TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  );
                }),
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return IconThemeData(
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }
                  return IconThemeData(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  );
                }),
                indicatorColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                height: 65,
              ),
              child: NavigationBar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surface.withOpacity(0.85),
                surfaceTintColor: Colors.transparent,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (int index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: AppLocalizations.of(context)!.navHome,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.grid_view_outlined),
                    selectedIcon: const Icon(Icons.grid_view),
                    label: AppLocalizations.of(context)!.navServices,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.article_outlined),
                    selectedIcon: const Icon(Icons.article),
                    label: AppLocalizations.of(context)!.navInsights,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.people_outline),
                    selectedIcon: const Icon(Icons.people),
                    label: AppLocalizations.of(context)!.navFirm,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.calendar_today_outlined),
                    selectedIcon: const Icon(Icons.calendar_today),
                    label: AppLocalizations.of(context)!.navBook,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
