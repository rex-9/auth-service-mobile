// lib/design/app_styles.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppStyles {
  const AppStyles();

  // ===== INPUT STYLES =====
  InputDecoration input({
    String? label,
    String? hint,
    String? error,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: error,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Design.colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Design.spacing.lg,
        vertical: Design.spacing.md + 2,
      ),
      labelStyle: Design.typo.labelMedium,
      hintStyle: Design.typo.helper,
      errorStyle: Design.typo.caption.copyWith(color: Design.colors.error),
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
    textStyle: Design.typo.button,
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
    textStyle: Design.typo.button,
  );

  ButtonStyle get buttonText => TextButton.styleFrom(
    foregroundColor: Design.colors.primary,
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.sm,
      vertical: Design.spacing.sm,
    ),
    textStyle: Design.typo.labelLarge,
  );

  ButtonStyle get buttonGoogle => ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Design.colors.textPrimary,
    minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.xl,
      vertical: Design.spacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    ),
    side: BorderSide(color: Design.colors.border),
    textStyle: Design.typo.button,
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
