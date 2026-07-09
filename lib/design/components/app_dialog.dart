// lib/design/components/app_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import '../design.dart';

class AppDialog {
  AppDialog._();

  static Future<void> error({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return _show(
      context: context,
      title: title,
      message: message,
      background: Design.colors.error.withValues(alpha: 0.12),
      foreground: Design.colors.errorDark,
      icon: Design.icons.error,
    );
  }

  static Future<void> success({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return _show(
      context: context,
      title: title,
      message: message,
      background: Design.colors.success.withValues(alpha: 0.12),
      foreground: Design.colors.successDark,
      icon: Design.icons.check,
    );
  }

  static Future<void> warning({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return _show(
      context: context,
      title: title,
      message: message,
      background: Design.colors.warning.withValues(alpha: 0.12),
      foreground: Design.colors.warningDark,
      icon: Design.icons.warning,
    );
  }

  static Future<void> info({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return _show(
      context: context,
      title: title,
      message: message,
      background: Design.colors.primary.withValues(alpha: 0.12),
      foreground: Design.colors.primaryDark,
      icon: Design.icons.info,
    );
  }

  static Future<void> _show({
    required BuildContext context,
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
          borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
          side: BorderSide(color: foreground.withValues(alpha: 0.25)),
        ),
        title: Row(
          children: [
            Icon(icon, color: foreground),
            SizedBox(width: Design.spacing.md),
            Expanded(
              child: Text(
                title,
                style: context.typo.headline4.copyWith(color: foreground),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: context.typo.bodyMedium.copyWith(color: foreground),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'OK',
              style: context.typo.labelLarge.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> exit(BuildContext context) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
        ),
        title: Text(
          Constants.locale.exitTitle.tr,
          style: context.typo.headline4.copyWith(
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          Constants.locale.exitConfirm.tr,
          style: context.typo.bodyMedium.copyWith(
            color: Get.theme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              Constants.locale.cancel.tr,
              style: context.typo.labelLarge.copyWith(
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              Constants.locale.exit.tr,
              style: context.typo.labelLarge.copyWith(
                color: Get.theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
