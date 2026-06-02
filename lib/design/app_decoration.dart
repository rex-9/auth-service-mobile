// lib/core/theme/app_decoration.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppDecoration {
  // Input Decoration
  static InputDecoration inputDecoration({
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
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.inputHorizontal,
        vertical: AppSpacing.inputVertical,
      ),
      labelStyle: AppTypography.labelMedium,
      hintStyle: AppTypography.helper,
      errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
    );
  }

  // Button Decoration
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.buttonHorizontal,
      vertical: AppSpacing.buttonVertical,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
    ),
    textStyle: AppTypography.button,
    elevation: 0,
    shadowColor: Colors.transparent,
  );

  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.buttonHorizontal,
      vertical: AppSpacing.buttonVertical,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
    ),
    side: const BorderSide(color: AppColors.primary),
    textStyle: AppTypography.button,
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.sm,
    ),
    textStyle: AppTypography.labelLarge,
  );

  static ButtonStyle googleButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary,
    minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.buttonHorizontal,
      vertical: AppSpacing.buttonVertical,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
    ),
    side: const BorderSide(color: AppColors.border),
    textStyle: AppTypography.button,
    elevation: 0,
  );

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
    boxShadow: AppColors.shadow,
  );

  // Container Decoration
  static BoxDecoration containerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
    border: Border.all(color: AppColors.border),
  );
}
