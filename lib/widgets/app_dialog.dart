import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../design/design.dart';

class AppDialog {
  AppDialog._();

  static Future<void> error({required String title, required String message}) {
    return _show(
      title: title,
      message: message,
      background: AppColors.error.withValues(alpha: 0.12),
      foreground: AppColors.errorDark,
      icon: AppIcons.error,
    );
  }

  static Future<void> success({
    required String title,
    required String message,
  }) {
    return _show(
      title: title,
      message: message,
      background: AppColors.success.withValues(alpha: 0.12),
      foreground: AppColors.successDark,
      icon: AppIcons.check,
    );
  }

  static Future<void> warning({
    required String title,
    required String message,
  }) {
    return _show(
      title: title,
      message: message,
      background: AppColors.warning.withValues(alpha: 0.12),
      foreground: AppColors.warningDark,
      icon: AppIcons.warning,
    );
  }

  static Future<void> info({required String title, required String message}) {
    return _show(
      title: title,
      message: message,
      background: AppColors.primary.withValues(alpha: 0.12),
      foreground: AppColors.primaryDark,
      icon: AppIcons.info,
    );
  }

  static Future<void> _show({
    required String title,
    required String message,
    required Color background,
    required Color foreground,
    required IconData icon,
  }) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          side: BorderSide(color: foreground.withValues(alpha: 0.25)),
        ),
        title: Row(
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.headline4.copyWith(color: foreground),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(color: foreground),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'OK',
              style: AppTypography.labelLarge.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
