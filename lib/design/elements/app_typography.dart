// lib/design/elements/app_typography.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppTypography {
  const AppTypography();

  // Font Family
  String get fontFamily => 'Poppins';

  // Headlines
  TextStyle get headline1 => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  TextStyle get headline2 => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  TextStyle get headline3 =>
      TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3);

  TextStyle get headline4 =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);

  // Body Text
  TextStyle get bodyLarge =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);

  TextStyle get bodyMedium =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);

  TextStyle get bodySmall =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);

  // Labels
  TextStyle get labelLarge =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4);

  TextStyle get labelMedium =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.4);

  TextStyle get labelSmall =>
      TextStyle(fontSize: 10, fontWeight: FontWeight.w600, height: 1.4);

  // Button Text
  TextStyle get button => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  TextStyle get buttonSmall => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // Caption
  TextStyle get caption => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Design.colors.textSecondary,
  );

  // Helper Text
  TextStyle get helper => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: Design.colors.textTertiary,
  );

  // Link
  TextStyle get link => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: Design.colors.primary,
    decoration: TextDecoration.underline,
  );
}
