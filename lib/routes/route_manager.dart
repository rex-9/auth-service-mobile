import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../contexts/contexts.dart';
import '../design/pages/pages.dart';

/// Mirrors web `src/routes/RouteManager.tsx` + `ProtectedRoute.tsx` +
/// `PublicRoute.tsx` — named routes with auth guards.
class RouteManager {
  RouteManager._();

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    AuthContext auth,
  ) {
    final name = settings.name ?? AppRoutes.client.public.root;

    // Protected routes: bounce unauthenticated users to root.
    final protectedPages = <String, WidgetBuilder>{
      AppRoutes.client.protected.home: (_) => const HomePage(),
    };
    if (protectedPages.containsKey(name)) {
      if (!auth.isAuthenticated) {
        return MaterialPageRoute(
          settings: RouteSettings(name: AppRoutes.client.public.root),
          builder: (_) => const _GuardedRoot(),
        );
      }
      return MaterialPageRoute(
        settings: settings,
        builder: protectedPages[name]!,
      );
    }

    // Public routes: authenticated users go straight home.
    if (name == AppRoutes.client.public.root) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const _GuardedRoot(),
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const NotFoundPage(),
    );
  }
}

/// Root shows the landing page for guests and home for signed-in users
/// (mirrors PublicRoute redirecting authenticated users to HOME).
class _GuardedRoot extends StatelessWidget {
  const _GuardedRoot();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthContext>().isAuthenticated;
    return isAuthenticated ? const HomePage() : const LandingPage();
  }
}
