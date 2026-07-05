import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contexts/contexts.dart';
import '../../controllers/controllers.dart';
import '../../locales/app_locales.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

/// Mirrors web `src/design/pages/HomePage.tsx` — the protected landing
/// after sign in.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasFetchedCurrentUser = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthContext>();
      if (auth.currentUser != null || _hasFetchedCurrentUser) return;
      _hasFetchedCurrentUser = true;
      userController.getCurrentUser(auth.setCurrentUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthContext>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppLocales.home,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy900,
                ),
              ),
              const SizedBox(height: 12),
              if (currentUser != null)
                Text(
                  'Welcome, ${currentUser.email}!',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.navy900,
                  ),
                ),
              const SizedBox(height: 24),
              const SignOutBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
