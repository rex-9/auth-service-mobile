// lib/routes/route_guard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth_service_mobile/controllers/controllers.dart';
import 'package:auth_service_mobile/services/services.dart';
import 'app_routes.dart';

class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final storage = Get.find<StorageService>();
    final isLoggedIn = authController.isLoggedIn.value;

    // ===== PROTECTED ROUTES (saved/restored) =====
    const protectedRoutes = [
      AppRoutes.home,
      AppRoutes.settings,
      AppRoutes.subscription,
      AppRoutes.checkout,
    ];

    // If not logged in and trying to access protected route
    if (route != null && protectedRoutes.contains(route) && !isLoggedIn) {
      storage.clearRouteStack();
      return const RouteSettings(name: AppRoutes.auth);
    }

    // If logged in and on auth page - restore last route
    if (route == AppRoutes.auth && isLoggedIn) {
      final stack = storage.getRouteStack();
      if (stack.isNotEmpty) {
        return RouteSettings(name: stack.last);
      }
      return const RouteSettings(name: AppRoutes.home);
    }

    // Manage route stack for protected routes
    if (route != null && protectedRoutes.contains(route) && isLoggedIn) {
      final stack = storage.getRouteStack();

      // If going to home, clear stack and add home as root
      if (route == AppRoutes.home) {
        storage.saveRouteStack([AppRoutes.home]);
        return null;
      }

      // For settings (or other protected routes)
      // Ensure home is always the first item in stack
      if (stack.isEmpty) {
        // If stack is empty, add home first, then the route
        storage.saveRouteStack([AppRoutes.home, route]);
      } else if (stack.last != route) {
        // If route is not already the last, add it
        // But ensure we don't have duplicates
        if (stack.contains(route)) {
          // Remove existing occurrence
          stack.remove(route);
        }
        stack.add(route);
        storage.saveRouteStack(stack);
      }
    }

    // Don't save public/flow routes
    return null;
  }
}
