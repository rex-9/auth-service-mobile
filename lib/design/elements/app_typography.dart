// lib/design/elements/app_typography.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppTypography {
  const AppTypography();

  String get fontFamily => 'Poppins';

  TextStyle get headline1 => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: Design.theme.colors.textPrimary,
  );

  TextStyle get headline2 => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: Design.theme.colors.textPrimary,
  );

  TextStyle get headline3 => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: Design.theme.colors.textPrimary,
  );

  TextStyle get headline4 => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: Design.theme.colors.textPrimary,
  );

  TextStyle get bodyLarge => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Design.theme.colors.textPrimary,
  );

  TextStyle get bodyMedium => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Design.theme.colors.textSecondary,
  );

  TextStyle get bodySmall => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Design.theme.colors.textTertiary,
  );

  TextStyle get labelLarge => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Design.theme.colors.textPrimary,
  );

  TextStyle get labelMedium => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Design.theme.colors.textSecondary,
  );

  TextStyle get labelSmall => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Design.theme.colors.textTertiary,
  );

  TextStyle get button => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: Design.theme.colors.textPrimary,
  );

  TextStyle get caption => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Design.theme.colors.textSecondary,
  );

  TextStyle get helper => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: Design.theme.colors.textTertiary,
  );

  TextStyle get link => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    decoration: TextDecoration.underline,
    color: Design.colors.primary,
  );
}
