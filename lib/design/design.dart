import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_decoration.dart';
import 'app_spacing.dart';
import 'app_theme.dart';
import 'app_typography.dart';
import 'app_icons.dart';
import 'app_media.dart';
import 'app_timers.dart';

class Design {
  Design._(); // Private constructor - never instantiate

  // ===== COLORS =====
  static const colors = AppColors();

  // ===== TYPOGRAPHY =====
  static const typography = AppTypography();

  // ===== SPACING =====
  static const spacing = AppSpacing();

  // ===== DECORATION =====
  static const decoration = AppDecoration();

  // ==== ICONS =====
  static const icons = AppIcons();

  // ==== MEDIA =====
  static const media = AppMedia();

  // ==== TIMERS =====
  static const timers = AppTimers();

  // ===== THEMES =====
  static ThemeData lightTheme() => AppTheme.light();
  static ThemeData darkTheme() => AppTheme.dark();

  // ===== COMPONENTS =====
  // static const buttons = _Buttons();
}
