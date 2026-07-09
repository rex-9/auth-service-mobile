// lib/routes/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/controllers/auth_controller.dart';
import 'package:meritbox_mobile/services/storage_service.dart';
import 'app_routes.dart';

class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final storage = Get.find<StorageService>();
    final isLoggedIn = authController.isLoggedIn.value;

    // ===== PROTECTED ROUTES (saved/restored) =====
    const protectedRoutes = [AppRoutes.home, AppRoutes.settings];

    // If not logged in and trying to access protected route
    if (protectedRoutes.contains(route) && !isLoggedIn) {
      storage.clearLastRoute();
      return const RouteSettings(name: AppRoutes.auth);
    }

    // If logged in and on auth page - redirect to last protected route or home
    if (route == AppRoutes.auth && isLoggedIn) {
      final lastRoute = storage.getLastRoute();
      if (lastRoute != null && protectedRoutes.contains(lastRoute)) {
        return RouteSettings(name: lastRoute);
      }
      return const RouteSettings(name: AppRoutes.home);
    }

    // Save protected routes when accessed
    if (protectedRoutes.contains(route) && isLoggedIn) {
      storage.setLastRoute(route!);
    }

    // Don't save public/flow routes
    return null;
  }
}
