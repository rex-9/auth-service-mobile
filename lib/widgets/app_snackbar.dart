import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../design/design.dart';

class AppSnackbar {
  AppSnackbar._();

  static void error(String message) {
    _show(
      title: 'error'.tr,
      message: message,
      background: AppColors.error.withValues(alpha: 0.12),
      foreground: AppColors.errorDark,
      icon: Icons.error_outline_rounded,
    );
  }

  static void success(String message) {
    _show(
      title: 'success'.tr,
      message: message,
      background: AppColors.success.withValues(alpha: 0.12),
      foreground: AppColors.successDark,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void warning(String message) {
    _show(
      title: 'warning'.tr,
      message: message,
      background: AppColors.warning.withValues(alpha: 0.12),
      foreground: AppColors.warningDark,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void info(String message) {
    _show(
      title: 'info'.tr,
      message: message,
      background: AppColors.primary.withValues(alpha: 0.12),
      foreground: AppColors.primaryDark,
      icon: Icons.info_outline_rounded,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color background,
    required Color foreground,
    required IconData icon,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: background,
      colorText: foreground,
      margin: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppSpacing.radiusMedium,
      duration: const Duration(seconds: 3),
      icon: Icon(icon, color: foreground),
      borderColor: foreground.withValues(alpha: 0.25),
      borderWidth: 1,
      titleText: Text(
        title,
        style: AppTypography.labelLarge.copyWith(color: foreground),
      ),
      messageText: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(color: foreground),
      ),
    );
  }
}
