// lib/design/elements/app_theme.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppTheme {
  const AppTheme();

  // ===== THEME DATA =====
  ThemeData get light => _buildLightTheme();
  ThemeData get dark => _buildDarkTheme();

  // ===== THEME-AWARE COLORS =====
  AppThemeColors get colors => const AppThemeColors();
}

// lib/design/elements/app_theme.dart
class AppThemeColors {
  const AppThemeColors();

  Color get primary => Get.theme.colorScheme.primary;
  Color get error => Get.theme.colorScheme.error;
  Color get background => Get.theme.scaffoldBackgroundColor;
  Color get surface => Get.theme.colorScheme.surface;
  Color get divider => Get.theme.dividerColor;
  Color get border => Get.theme.colorScheme.outline;
  Color get textPrimary => Get.theme.colorScheme.onSurface;
  Color get textSecondary => Get.theme.colorScheme.onSurfaceVariant;
  Color get textTertiary =>
      Get.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
}

// ===== THEME BUILDERS =====
ThemeData _buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Design.colors.primary,
    scaffoldBackgroundColor: Design.colors.background,
    colorScheme: ColorScheme.light(
      primary: Design.colors.primary,
      secondary: Design.colors.secondary,
      error: Design.colors.error,
      surface: Design.colors.surface,
      onSurface: Design.colors.textPrimary,
      onSurfaceVariant: Design.colors.textSecondary,
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
      backgroundColor: Design.colors.surface,
      foregroundColor: Design.colors.textPrimary,
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
      fillColor: Design.colors.surface,
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
      contentPadding: EdgeInsets.symmetric(
        horizontal: Design.spacing.inputHorizontal,
        vertical: Design.spacing.inputVertical,
      ),
      labelStyle: Design.typo.labelMedium,
      hintStyle: Design.typo.helper,
      errorStyle: Design.typo.caption.copyWith(color: Design.colors.error),
    ),
    cardTheme: CardThemeData(
      color: Design.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: Design.colors.divider,
      thickness: 1,
      space: Design.spacing.lg,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Design.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
      ),
      backgroundColor: Design.colors.textPrimary,
      contentTextStyle: Design.typo.bodyMedium.copyWith(color: Colors.white),
    ),
  );
}

ThemeData _buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Design.colors.primary,
    scaffoldBackgroundColor: Design.colors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: Design.colors.primary,
      secondary: Design.colors.secondary,
      error: Design.colors.error,
      surface: Design.colors.surfaceDark,
      onSurface: Design.colors.textPrimaryDark,
      onSurfaceVariant: Design.colors.textSecondaryDark,
    ),
    fontFamily: Design.typo.fontFamily,
    textTheme: TextTheme(
      displayLarge: Design.typo.headline1.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      displayMedium: Design.typo.headline2.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      displaySmall: Design.typo.headline3.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      bodyLarge: Design.typo.bodyLarge.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      bodyMedium: Design.typo.bodyMedium.copyWith(
        color: Design.colors.textSecondaryDark,
      ),
      bodySmall: Design.typo.bodySmall.copyWith(
        color: Design.colors.textTertiaryDark,
      ),
      labelLarge: Design.typo.labelLarge.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      labelMedium: Design.typo.labelMedium.copyWith(
        color: Design.colors.textSecondaryDark,
      ),
      labelSmall: Design.typo.labelSmall.copyWith(
        color: Design.colors.textTertiaryDark,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Design.colors.surfaceDark,
      foregroundColor: Design.colors.textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: Design.typo.headline4.copyWith(
        color: Design.colors.textPrimaryDark,
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
      fillColor: Design.colors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        borderSide: BorderSide(color: Design.colors.borderDark),
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
        color: Design.colors.textSecondaryDark,
      ),
      hintStyle: Design.typo.helper.copyWith(
        color: Design.colors.textTertiaryDark,
      ),
      errorStyle: Design.typo.caption.copyWith(color: Design.colors.error),
    ),
    cardTheme: CardThemeData(
      color: Design.colors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: Design.colors.dividerDark,
      thickness: 1,
      space: Design.spacing.lg,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Design.colors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
      ),
      backgroundColor: Design.colors.textPrimaryDark,
      contentTextStyle: Design.typo.bodyMedium.copyWith(color: Colors.white),
    ),
  );
}
