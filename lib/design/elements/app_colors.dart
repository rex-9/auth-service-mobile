// lib/design/elements/app_colors.dart
import 'package:flutter/material.dart';

/// RexOne Design System Colors — Unified with Rex9 Design System.
/// Provides pure brand, semantic, day (light), night (dark), and glassmorphic tokens.
class AppColors {
  const AppColors();

  // ===== BRAND (Unified across Light & Dark) =====
  Color get primary => const Color(0xFFFF5E62);
  Color get secondary => const Color(0xFFFF7556);
  Color get accent => const Color(0xFFFF2A4B);

  // ===== SEMANTIC (Unified across Light & Dark) =====
  Color get success => const Color(0xFF10B981);
  Color get warning => const Color(0xFFF59E0B);
  Color get error => const Color(0xFFEF4444);
  Color get info => const Color(0xFF38BDF8);

  // ===== DAY THEME (Light Mode) =====
  AppDayColors get day => const AppDayColors();

  // ===== NIGHT THEME (Dark Mode - Rex9 Cyber Aesthetic) =====
  AppNightColors get night => const AppNightColors();

  // ===== GLASSMORPHISM =====
  AppGlassColors get glass => const AppGlassColors();

  // ===== GRADIENTS & SHADOWS =====
  GradientColors get gradient => const GradientColors();
  Shadows get shadows => const Shadows();
}

class AppDayColors {
  const AppDayColors();

  Color get background => const Color(0xFFFAFAF8);
  Color get surface => const Color(0xFFFFFFFF);
  Color get card => const Color(0xFFF5F5F3);
  Color get border => const Color(0xFFE5E7EB);
  Color get divider => const Color(0xFFF3F4F6);
  Color get textPrimary => const Color(0xFF111827);
  Color get textSecondary => const Color(0xFF4B5563);
  Color get textMuted => const Color(0xFF9CA3AF);
}

class AppNightColors {
  const AppNightColors();

  Color get background => const Color(0xFF080808);
  Color get surface => const Color(0xFF12060A);
  Color get card => const Color(0xFF16080E);
  Color get border => const Color(0xFF2A1018);
  Color get divider => const Color(0xFF1F0B13);
  Color get textPrimary => const Color(0xFFFFFFFF);
  Color get textSecondary => const Color(0xFFE2D4D8);
  Color get textMuted => const Color(0xFF8E7E84);
}

class AppGlassColors {
  const AppGlassColors();

  Color get nav => const Color(0xCC12060A);
  Color get card => const Color(0x9916080E);
  Color get border => const Color(0x38FF5E62);
}

class GradientColors {
  const GradientColors();
  final AppColors _colors = const AppColors();

  LinearGradient get primary => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_colors.primary, _colors.secondary],
  );

  LinearGradient get success => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_colors.success, const Color(0xFF34D399)],
  );

  LinearGradient get error => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_colors.error, const Color(0xFFF87171)],
  );
}

class Shadows {
  const Shadows();

  List<BoxShadow> get sm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  List<BoxShadow> get md => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  List<BoxShadow> get lg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 30,
      offset: const Offset(0, 8),
    ),
  ];
}
