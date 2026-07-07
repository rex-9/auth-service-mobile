import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';

import '../design/design.dart';

class AppSnackbar {
  AppSnackbar._();

  static void error(String message) {
    _show(
      title: LocaleConstants.error.tr,
      message: message,
      background: AppColors.error.withValues(alpha: 0.12),
      foreground: AppColors.errorDark,
      icon: AppIcons.error,
    );
  }

  static void success(String message) {
    _show(
      title: LocaleConstants.success.tr,
      message: message,
      background: AppColors.success.withValues(alpha: 0.12),
      foreground: AppColors.successDark,
      icon: AppIcons.check,
    );
  }

  static void warning(String message) {
    _show(
      title: LocaleConstants.warning.tr,
      message: message,
      background: AppColors.warning.withValues(alpha: 0.12),
      foreground: AppColors.warningDark,
      icon: AppIcons.warning,
    );
  }

  static void info(String message) {
    _show(
      title: LocaleConstants.info.tr,
      message: message,
      background: AppColors.primary.withValues(alpha: 0.12),
      foreground: AppColors.primaryDark,
      icon: AppIcons.info,
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
