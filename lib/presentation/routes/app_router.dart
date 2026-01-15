import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import all your screens
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/library_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/player_screen.dart';
import '../screens/playlist_details_screen.dart';
import '../widgets/main_wrapper.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/',
        builder: (context , state) => const SplashScreen(),
      ),
      GoRoute(path: '/login',
        builder: (context , state) => const LoginScreen(),
      ),
      GoRoute(path: '/signup',
        builder: (context , state) => const SignupScreen(),
      ),
      GoRoute(path: '/player',
        builder: (context , state) => const PlayerScreen(),
      ),
      GoRoute(
          path: 'playlist/:id',
          parentNavigatorKey: _rootNavigatorKey,
        builder: (context , state) {
            final id= state.pathParameters['id']!;
            return PlaylistDetailsScreen(playlistId:id);
        },
      ),

      StatefulShellRoute.indexedStack(
          builder: (context , state , navigationShell){
            return MainWrapper(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: '/home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(routes: [
              GoRoute(path: '/search',
                  builder: (context,state) => const SearchScreen()
              ),
            ],
            ),
            StatefulShellBranch(routes: [
              GoRoute(path: '/library',
                builder: (context,state) => const LibraryScreen(),
              ),
            ],
            ),
            StatefulShellBranch(routes: [
              GoRoute(path: '/profile',
                builder: (context , state ) => const ProfileScreen(),
              ),
            ],
            ),

          ]
      )
    ],


  );
}