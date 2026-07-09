// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../design/design.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authController = Get.find<AuthController>();

    // Wait for auth check to complete
    await Future.delayed(const Duration(milliseconds: 500));

    if (authController.isLoggedIn.value) {
      // If logged in, go to last visited page or home
      final currentRoute = Get.currentRoute;
      if (currentRoute != '/' &&
          currentRoute != AppRoutes.splash &&
          currentRoute != AppRoutes.auth) {
        // Stay on current route
        return;
      }
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✨ Meritbox ✨', style: context.typo.headline1),
            SizedBox(height: Design.spacing.md),
            Text('Loading...', style: context.typo.bodyMedium),
            SizedBox(height: Design.spacing.lg),
            const AppLoading(),
          ],
        ),
      ),
    );
  }
}
