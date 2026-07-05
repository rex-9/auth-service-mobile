import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'contexts/contexts.dart';
import 'design/atoms/atoms.dart';
import 'design/molecules/molecules.dart';
import 'routes/route_manager.dart';
import 'services/services.dart';

/// Mirrors web `src/App.tsx` — wires providers, the API interceptor hooks,
/// the loading overlay, and the route manager.
class App extends StatelessWidget {
  const App({super.key, required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthContext(storage)),
        ChangeNotifierProvider(create: (_) => LoadingContext()),
      ],
      child: const _AppShell(),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Mirrors `useAxiosInterceptor` on web: token header, loading overlay,
    // and session-replaced handling.
    final auth = context.read<AuthContext>();
    final loading = context.read<LoadingContext>();

    Api.tokenProvider = () => auth.token;
    Api.onLoading = loading.setLoading;
    Api.onSessionReplaced = (message) {
      auth.signout();
      auth.setSessionMessage(message);
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.client.public.root,
        (route) => false,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthContext>();

    return MaterialApp(
      title: 'Auth Service Mobile',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold500,
          primary: AppColors.gold500,
        ),
      ),
      onGenerateRoute: (settings) =>
          RouteManager.onGenerateRoute(settings, auth),
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            const LoadingOverlay(),
          ],
        );
      },
    );
  }
}
