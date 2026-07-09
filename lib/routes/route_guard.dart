// lib/routes/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/controllers/auth_controller.dart';
import 'app_routes.dart';

class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final isLoggedIn = authController.isLoggedIn.value;

    // Protected routes
    const protectedRoutes = [AppRoutes.home, AppRoutes.settings];

    // If not logged in and trying to access protected route
    if (protectedRoutes.contains(route) && !isLoggedIn) {
      return const RouteSettings(name: AppRoutes.auth);
    }

    // If logged in and trying to access auth page
    if (route == AppRoutes.auth && isLoggedIn) {
      return null; // Let the current route stay
    }

    return null;
  }
}
