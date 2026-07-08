// lib/design/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  // Primary Colors
  Color get primary => Color(0xFF6366F1); // Indigo 500
  Color get primaryLight => Color(0xFF818CF8); // Indigo 400
  Color get primaryDark => Color(0xFF4F46E5); // Indigo 600

  // Secondary Colors
  Color get secondary => Color(0xFF8B5CF6); // Violet 500
  Color get secondaryLight => Color(0xFFA78BFA); // Violet 400
  Color get secondaryDark => Color(0xFF7C3AED); // Violet 600

  // Success Colors
  Color get success => Color(0xFF10B981); // Emerald 500
  Color get successLight => Color(0xFF34D399); // Emerald 400
  Color get successDark => Color(0xFF059669); // Emerald 600

  // Error Colors
  Color get error => Color(0xFFEF4444); // Red 500
  Color get errorLight => Color(0xFFF87171); // Red 400
  Color get errorDark => Color(0xFFDC2626); // Red 600

  // Warning Colors
  Color get warning => Color(0xFFF59E0B); // Amber 500
  Color get warningLight => Color(0xFFFBBF24); // Amber 400
  Color get warningDark => Color(0xFFD97706); // Amber 600

  // Neutral Colors (Light Mode)
  Color get background => Color(0xFFF9FAFB);
  Color get surface => Color(0xFFFFFFFF);
  Color get textPrimary => Color(0xFF111827);
  Color get textSecondary => Color(0xFF6B7280);
  Color get textTertiary => Color(0xFF9CA3AF);
  Color get border => Color(0xFFE5E7EB);
  Color get divider => Color(0xFFF3F4F6);

  // Dark Mode Colors
  Color get backgroundDark => Color(0xFF111827);
  Color get surfaceDark => Color(0xFF1F2937);
  Color get textPrimaryDark => Color(0xFFF9FAFB);
  Color get textSecondaryDark => Color(0xFF9CA3AF);
  Color get textTertiaryDark => Color(0xFF6B7280);
  Color get borderDark => Color(0xFF374151);
  Color get dividerDark => Color(0xFF1F2937);

  // Gradient Colors
  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  LinearGradient get successGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successLight],
  );

  LinearGradient get errorGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, errorLight],
  );

  // Shadow
  List<BoxShadow> get shadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 30,
      offset: const Offset(0, 8),
    ),
  ];
}
