// lib/design/app_decoration.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppDecoration {
  const AppDecoration();

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
        horizontal: Design.spacing.inputHorizontal,
        vertical: Design.spacing.inputVertical,
      ),
      labelStyle: Design.typography.labelMedium,
      hintStyle: Design.typography.helper,
      errorStyle: Design.typography.caption.copyWith(
        color: Design.colors.error,
      ),
    );
  }

  // Button Decoration
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Design.colors.primary,
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.buttonHorizontal,
      vertical: Design.spacing.buttonVertical,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    ),
    textStyle: Design.typography.button,
    elevation: 0,
    shadowColor: Colors.transparent,
  );

  ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: Design.colors.primary,
    minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.buttonHorizontal,
      vertical: Design.spacing.buttonVertical,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    ),
    side: BorderSide(color: Design.colors.primary),
    textStyle: Design.typography.button,
  );

  ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: Design.colors.primary,
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.sm,
      vertical: Design.spacing.sm,
    ),
    textStyle: Design.typography.labelLarge,
  );

  ButtonStyle get googleButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Design.colors.textPrimary,
    minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Design.spacing.buttonHorizontal,
      vertical: Design.spacing.buttonVertical,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    ),
    side: BorderSide(color: Design.colors.border),
    textStyle: Design.typography.button,
    elevation: 0,
  );

  // Card Decoration
  BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    boxShadow: Design.colors.shadow,
  );

  // Container Decoration
  BoxDecoration get containerDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
    border: Border.all(color: Design.colors.border),
  );
}
