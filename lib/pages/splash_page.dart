// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/services/services.dart';
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
    final storage = Get.find<StorageService>();

    // Wait for auth check to complete
    await Future.delayed(const Duration(milliseconds: 10));

    if (authController.isLoggedIn.value) {
      final lastRoute = storage.getLastRoute();

      // Only restore protected routes
      const protectedRoutes = [AppRoutes.home, AppRoutes.settings];

      if (lastRoute != null && protectedRoutes.contains(lastRoute)) {
        Get.offAllNamed(lastRoute);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
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
