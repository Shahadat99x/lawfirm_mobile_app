import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/home_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/appointment/appointment_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/admin_webview.dart';
import '../../shared/widgets/scaffold_with_navbar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorServicesKey = GlobalKey<NavigatorState>(debugLabel: 'shellServices');
final _shellNavigatorInsightsKey = GlobalKey<NavigatorState>(debugLabel: 'shellInsights');
final _shellNavigatorAppointmentKey = GlobalKey<NavigatorState>(debugLabel: 'shellAppointment');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorServicesKey,
            routes: [
              GoRoute(
                path: '/services',
                pageBuilder: (context, state) => const NoTransitionPage(child: ServicesScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorInsightsKey,
            routes: [
              GoRoute(
                path: '/insights',
                pageBuilder: (context, state) => const NoTransitionPage(child: InsightsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAppointmentKey,
            routes: [
              GoRoute(
                path: '/appointment',
                pageBuilder: (context, state) => const NoTransitionPage(child: AppointmentScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/admin',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminWebView(),
      ),
    ],
  );
});
