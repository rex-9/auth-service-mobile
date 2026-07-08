// lib/design/elements/app_styles.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppStyles {
  const AppStyles();

  // ===== INPUT STYLES =====
  InputDecoration input({
    String? label,
    String? hint,
    String? error,
    String? helper,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final colors = Get.theme.colorScheme;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: error,
      helperText: helper,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: colors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: colors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: colors.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Design.spacing.lg,
        vertical: Design.spacing.md + 2,
      ),
      labelStyle: Design.typography.labelMedium,
      hintStyle: Design.typography.helper,
      errorStyle: Design.typography.caption.copyWith(color: colors.error),
    );
  }

  // ===== BUTTON STYLES =====
  ButtonStyle get buttonPrimary => ElevatedButton.styleFrom(
    backgroundColor: Design.colors.primary,
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.xl,
      vertical: Design.spacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    ),
    textStyle: Design.typography.button,
    elevation: 0,
    shadowColor: Colors.transparent,
  );

  ButtonStyle get buttonSecondary => OutlinedButton.styleFrom(
    foregroundColor: Design.colors.primary,
    minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.xl,
      vertical: Design.spacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    ),
    side: BorderSide(color: Design.colors.primary),
    textStyle: Design.typography.button,
  );

  ButtonStyle get buttonText => TextButton.styleFrom(
    foregroundColor: Design.colors.primary,
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.sm,
      vertical: Design.spacing.sm,
    ),
    textStyle: Design.typography.labelLarge,
  );

  ButtonStyle get buttonGoogle => ElevatedButton.styleFrom(
    backgroundColor: Get.theme.colorScheme.surface,
    foregroundColor: Get.theme.colorScheme.onSurface,
    minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.xl,
      vertical: Design.spacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    ),
    side: BorderSide(color: Get.theme.colorScheme.outline),
    textStyle: Design.typography.button,
    elevation: 0,
  );

  // ===== CARD STYLES =====
  BoxDecoration get card => BoxDecoration(
    color: Design.colors.surface,
    borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
    boxShadow: Design.colors.shadows.sm,
  );

  BoxDecoration get cardElevated => BoxDecoration(
    color: Design.colors.surface,
    borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
    boxShadow: Design.colors.shadows.md,
  );

  // ===== CONTAINER STYLES =====
  BoxDecoration get container => BoxDecoration(
    color: Design.colors.surface,
    borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    border: Border.all(color: Design.colors.border),
  );

  BoxDecoration get containerBordered => BoxDecoration(
    color: Design.colors.surface,
    borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    border: Border.all(color: Design.colors.primary, width: 2),
  );

  // ===== DIALOG STYLES =====
  BoxDecoration get dialog => BoxDecoration(
    color: Design.colors.surface,
    borderRadius: BorderRadius.circular(Design.spacing.radiusXLarge),
    boxShadow: Design.colors.shadows.lg,
  );

  // ===== CHIP STYLES =====
  BoxDecoration get chip => BoxDecoration(
    color: Design.colors.primary.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(Design.spacing.radiusXLarge),
    border: Border.all(color: Design.colors.primary.withValues(alpha: 0.2)),
  );

  BoxDecoration get chipSuccess => BoxDecoration(
    color: Design.colors.success.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(Design.spacing.radiusXLarge),
    border: Border.all(color: Design.colors.success.withValues(alpha: 0.2)),
  );

  BoxDecoration get chipError => BoxDecoration(
    color: Design.colors.error.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(Design.spacing.radiusXLarge),
    border: Border.all(color: Design.colors.error.withValues(alpha: 0.2)),
  );
}
