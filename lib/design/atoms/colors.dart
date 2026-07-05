import 'package:flutter/material.dart';

/// Meritbox Design System - Color Tokens
///
/// Mirrors web `src/design/atoms/colors.ts`.
/// Colors that evoke: inner peace, mindfulness, warmth, hope, soft melanated light.
class AppColors {
  AppColors._();

  // Core Brand Colors
  static const gold400 = Color(0xFFF9E3A8);
  static const gold500 = Color(0xFFF8D57E); // Primary Brand Color - Kindness Gold
  static const gold600 = Color(0xFFEAC065);

  static const blue400 = Color(0xFFCBE1FF);
  static const blue500 = Color(0xFF9EC9FF); // Secondary Brand Color - Clarity Blue
  static const blue600 = Color(0xFF7FB8FF);

  static const navy700 = Color(0xFF1A2A3A);
  static const navy900 = Color(0xFF14202E); // Anchor Color - Deep Navy

  // Utility Grays - Minimalist vibe
  static const gray50 = Color(0xFFF8F9FA);
  static const gray100 = Color(0xFFF1F3F5);
  static const gray200 = Color(0xFFE9ECEF);
  static const gray300 = Color(0xFFDEE2E6);
  static const gray500 = Color(0xFFADB5BD);
  static const gray700 = Color(0xFF495057);
  static const gray900 = Color(0xFF212529);

  // Background Colors - Light Mode (Warm Off-White)
  static const bgPrimary = Color(0xFFFAFAF8);
  static const bgSecondary = Color(0xFFF5F5F3);
  static const bgTertiary = Color(0xFFF0F0EE);

  // Semantic Colors (for status)
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC85C);
  static const error = Color(0xFFF05454);
  static const info = Color(0xFF74B3FF);
}
