import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deep_link/app/scaffold_with_bottom_nav_bar.dart';
import 'package:go_router_deep_link/screens/animation_sample.dart';
import 'package:go_router_deep_link/screens/car_detail_screen.dart';
import 'package:go_router_deep_link/screens/car_list_screen.dart';
import 'package:go_router_deep_link/screens/login_screen.dart';
import 'package:go_router_deep_link/screens/profile_screen.dart';
import 'package:go_router_deep_link/screens/settings_screen.dart';
import 'package:go_router_deep_link/state/auth_provider.dart';

import 'go_router_refresh_stream.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _carTabNavigatorKey = GlobalKey<NavigatorState>();
final _animationTabNavigatorKey = GlobalKey<NavigatorState>();
final _profileTabNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(),
    redirect: (context, state) {
      debugPrint("page location: ${state.matchedLocation}");
      final isLoggedIn = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        authProvider.setPendingDeepLink(state.matchedLocation);
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _carTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const CarListScreen(),
                routes: [
                  GoRoute(
                    path: 'car/:id',
                    builder: (context, state) {
                      final carId = int.parse(state.pathParameters['id']!);
                      return CarDetailScreen(carId: carId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _animationTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/animation',
                builder: (context, state) => const AnimationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
