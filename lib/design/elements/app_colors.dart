// lib/design/elements/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  // ===== BASE COLORS =====
  // Primary Colors
  Color get primary => const Color(0xFF6366F1);
  Color get primaryLight => const Color(0xFF818CF8);
  Color get primaryDark => const Color(0xFF4F46E5);

  // Secondary Colors
  Color get secondary => const Color(0xFF8B5CF6);
  Color get secondaryLight => const Color(0xFFA78BFA);
  Color get secondaryDark => const Color(0xFF7C3AED);

  // Success Colors
  Color get success => const Color(0xFF10B981);
  Color get successLight => const Color(0xFF34D399);
  Color get successDark => const Color(0xFF059669);

  // Error Colors
  Color get error => const Color(0xFFEF4444);
  Color get errorLight => const Color(0xFFF87171);
  Color get errorDark => const Color(0xFFDC2626);

  // Warning Colors
  Color get warning => const Color(0xFFF59E0B);
  Color get warningLight => const Color(0xFFFBBF24);
  Color get warningDark => const Color(0xFFD97706);

  // Neutral Colors (Light Mode)
  Color get background => const Color(0xFFF9FAFB);
  Color get surface => const Color(0xFFFFFFFF);
  Color get textPrimary => const Color(0xFF111827);
  Color get textSecondary => const Color(0xFF6B7280);
  Color get textTertiary => const Color(0xFF9CA3AF);
  Color get border => const Color(0xFFE5E7EB);
  Color get divider => const Color(0xFFF3F4F6);

  // Dark Mode Colors
  Color get backgroundDark => const Color(0xFF111827);
  Color get surfaceDark => const Color(0xFF1F2937);
  Color get textPrimaryDark => const Color(0xFFF9FAFB);
  Color get textSecondaryDark => const Color(0xFF9CA3AF);
  Color get textTertiaryDark => const Color(0xFF6B7280);
  Color get borderDark => const Color(0xFF374151);
  Color get dividerDark => const Color(0xFF1F2937);

  // ===== GRADIENT COLORS =====
  GradientColors get gradient => const GradientColors();

  // ===== SHADOWS =====
  Shadows get shadows => const Shadows();
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
    colors: [_colors.success, _colors.successLight],
  );

  LinearGradient get error => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_colors.error, _colors.errorLight],
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
