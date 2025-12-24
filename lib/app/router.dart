import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/home_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/services/service_detail_screen.dart';
import '../../features/services/domain/practice_area.dart';
import '../../features/insights/domain/blog_post.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/insights/blog_detail_screen.dart';
import '../../features/appointment/appointment_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/admin_webview.dart';
import '../../shared/widgets/scaffold_with_navbar.dart';

import '../../features/team/team_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorServicesKey = GlobalKey<NavigatorState>(debugLabel: 'shellServices');
final _shellNavigatorInsightsKey = GlobalKey<NavigatorState>(debugLabel: 'shellInsights');
final _shellNavigatorTeamKey = GlobalKey<NavigatorState>(debugLabel: 'shellTeam');
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
                routes: [
                   GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final service = state.extra as PracticeArea;
                      return ServiceDetailScreen(service: service);
                    },
                  ),
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorInsightsKey,
            routes: [
              GoRoute(
                path: '/insights',
                pageBuilder: (context, state) => const NoTransitionPage(child: InsightsScreen()),
                 routes: [
                   GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final post = state.extra as BlogPost;
                      return BlogDetailScreen(post: post);
                    },
                  ),
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTeamKey,
            routes: [
              GoRoute(
                path: '/team',
                pageBuilder: (context, state) => const NoTransitionPage(child: TeamScreen()),
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
