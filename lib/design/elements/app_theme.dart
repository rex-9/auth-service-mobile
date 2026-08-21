// lib/design/elements/app_theme.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/design/design.dart';

class AppTheme {
  const AppTheme();

  // ===== THEME DATA =====
  ThemeData get light => _buildLightTheme();
  ThemeData get dark => _buildDarkTheme();

  // ===== THEME-AWARE DYNAMIC GETTERS =====
  AppThemeColors get colors => const AppThemeColors();
}

/// Theme-aware dynamic colors resolved from current GetX theme.
class AppThemeColors {
  const AppThemeColors();

  Color get primary => Get.theme.colorScheme.primary;
  Color get secondary => Get.theme.colorScheme.secondary;
  Color get error => Get.theme.colorScheme.error;
  Color get background => Get.theme.scaffoldBackgroundColor;
  Color get surface => Get.theme.colorScheme.surface;
  Color get card => Get.theme.cardTheme.color ?? Get.theme.colorScheme.surface;
  Color get divider => Get.theme.dividerColor;
  Color get border => Get.theme.colorScheme.outline;
  Color get textPrimary => Get.theme.colorScheme.onSurface;
  Color get textSecondary => Get.theme.colorScheme.onSurfaceVariant;
  Color get textMuted =>
      Get.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
  Color get textTertiary => textMuted;
}

// ===== THEME BUILDERS =====
ThemeData _buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Design.colors.primary,
    scaffoldBackgroundColor: Design.colors.day.background,
    colorScheme: ColorScheme.light(
      primary: Design.colors.primary,
      secondary: Design.colors.secondary,
      error: Design.colors.error,
      surface: Design.colors.day.surface,
      onSurface: Design.colors.day.textPrimary,
      onSurfaceVariant: Design.colors.day.textSecondary,
      outline: Design.colors.day.border,
    ),
    fontFamily: Design.typo.fontFamily,
    textTheme: TextTheme(
      displayLarge: Design.typo.headline1,
      displayMedium: Design.typo.headline2,
      displaySmall: Design.typo.headline3,
      bodyLarge: Design.typo.bodyLarge,
      bodyMedium: Design.typo.bodyMedium,
      bodySmall: Design.typo.bodySmall,
      labelLarge: Design.typo.labelLarge,
      labelMedium: Design.typo.labelMedium,
      labelSmall: Design.typo.labelSmall,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Design.colors.day.surface,
      foregroundColor: Design.colors.day.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: Design.typo.headline4,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
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
        textStyle: Design.typo.button,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
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
        textStyle: Design.typo.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Design.colors.primary,
        textStyle: Design.typo.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Design.colors.day.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.day.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.day.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.error),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Design.spacing.inputHorizontal,
        vertical: Design.spacing.inputVertical,
      ),
      labelStyle: Design.typo.labelMedium,
      hintStyle: Design.typo.helper,
      errorStyle: Design.typo.caption.copyWith(color: Design.colors.error),
    ),
    cardTheme: CardThemeData(
      color: Design.colors.day.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: Design.colors.day.divider,
      thickness: 1,
      space: Design.spacing.lg,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Design.colors.day.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
      ),
      backgroundColor: Design.colors.day.textPrimary,
      contentTextStyle: Design.typo.bodyMedium.copyWith(color: Colors.white),
    ),
  );
}

ThemeData _buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Design.colors.primary,
    scaffoldBackgroundColor: Design.colors.night.background,
    colorScheme: ColorScheme.dark(
      primary: Design.colors.primary,
      secondary: Design.colors.secondary,
      error: Design.colors.error,
      surface: Design.colors.night.surface,
      onSurface: Design.colors.night.textPrimary,
      onSurfaceVariant: Design.colors.night.textSecondary,
      outline: Design.colors.night.border,
    ),
    fontFamily: Design.typo.fontFamily,
    textTheme: TextTheme(
      displayLarge: Design.typo.headline1.copyWith(
        color: Design.colors.night.textPrimary,
      ),
      displayMedium: Design.typo.headline2.copyWith(
        color: Design.colors.night.textPrimary,
      ),
      displaySmall: Design.typo.headline3.copyWith(
        color: Design.colors.night.textPrimary,
      ),
      bodyLarge: Design.typo.bodyLarge.copyWith(
        color: Design.colors.night.textPrimary,
      ),
      bodyMedium: Design.typo.bodyMedium.copyWith(
        color: Design.colors.night.textSecondary,
      ),
      bodySmall: Design.typo.bodySmall.copyWith(
        color: Design.colors.night.textMuted,
      ),
      labelLarge: Design.typo.labelLarge.copyWith(
        color: Design.colors.night.textPrimary,
      ),
      labelMedium: Design.typo.labelMedium.copyWith(
        color: Design.colors.night.textSecondary,
      ),
      labelSmall: Design.typo.labelSmall.copyWith(
        color: Design.colors.night.textMuted,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Design.colors.night.surface,
      foregroundColor: Design.colors.night.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: Design.typo.headline4.copyWith(
        color: Design.colors.night.textPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
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
        textStyle: Design.typo.button,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
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
        textStyle: Design.typo.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Design.colors.primary,
        textStyle: Design.typo.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Design.colors.night.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.night.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.night.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.error),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Design.spacing.inputHorizontal,
        vertical: Design.spacing.inputVertical,
      ),
      labelStyle: Design.typo.labelMedium.copyWith(
        color: Design.colors.night.textSecondary,
      ),
      hintStyle: Design.typo.helper.copyWith(
        color: Design.colors.night.textMuted,
      ),
      errorStyle: Design.typo.caption.copyWith(color: Design.colors.error),
    ),
    cardTheme: CardThemeData(
      color: Design.colors.night.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: Design.colors.night.divider,
      thickness: 1,
      space: Design.spacing.lg,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Design.colors.night.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
      ),
      backgroundColor: Design.colors.night.textPrimary,
      contentTextStyle: Design.typo.bodyMedium.copyWith(color: Colors.white),
    ),
  );
}
