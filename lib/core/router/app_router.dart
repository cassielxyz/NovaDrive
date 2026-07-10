import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/credentials/credentials_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/dashboard/main_layout_screen.dart';
import '../../features/dashboard/drive_browser_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/smart_vaults/smart_vault_screen.dart';

import '../../features/trash/trash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/credentials',
        builder: (context, state) => const CredentialsScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const MainLayoutScreen(),
      ),
      GoRoute(
        path: '/folder/:id',
        builder: (context, state) => DriveBrowserScreen(currentFolderId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const SmartVaultScreen(title: 'Favorites'),
      ),
      GoRoute(
        path: '/recents',
        builder: (context, state) => const SmartVaultScreen(title: 'Recents'),
      ),
      GoRoute(
        path: '/trash',
        builder: (context, state) => const TrashScreen(),
      ),
      GoRoute(
        path: '/vault/:id',
        builder: (context, state) => SmartVaultScreen(title: state.pathParameters['id']!),
      ),
    ],
  );
});
