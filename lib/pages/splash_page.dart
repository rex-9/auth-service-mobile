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
      final stack = storage.getRouteStack();

      // Only restore protected routes
      const protectedRoutes = [AppRoutes.home, AppRoutes.settings];

      if (stack.isNotEmpty && protectedRoutes.contains(stack.last)) {
        Get.offAllNamed(stack.last);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      storage.clearRouteStack();
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
          children: [const AppLoading()],
        ),
      ),
    );
  }
}
