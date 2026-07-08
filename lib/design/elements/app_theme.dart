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

  // ===== THEME-AWARE TEXT STYLES =====
  AppThemeStyles get styles => const AppThemeStyles();
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

class AppThemeStyles {
  const AppThemeStyles();

  AppThemeColors get _colors => const AppThemeColors();

  // Headlines
  TextStyle get headline1 =>
      Design.typography.headline1.copyWith(color: _colors.textPrimary);
  TextStyle get headline2 =>
      Design.typography.headline2.copyWith(color: _colors.textPrimary);
  TextStyle get headline3 =>
      Design.typography.headline3.copyWith(color: _colors.textPrimary);
  TextStyle get headline4 =>
      Design.typography.headline4.copyWith(color: _colors.textPrimary);

  // Body
  TextStyle get bodyLarge =>
      Design.typography.bodyLarge.copyWith(color: _colors.textPrimary);
  TextStyle get bodyMedium =>
      Design.typography.bodyMedium.copyWith(color: _colors.textSecondary);
  TextStyle get bodySmall =>
      Design.typography.bodySmall.copyWith(color: _colors.textTertiary);

  // Labels
  TextStyle get labelLarge =>
      Design.typography.labelLarge.copyWith(color: _colors.textPrimary);
  TextStyle get labelMedium =>
      Design.typography.labelMedium.copyWith(color: _colors.textSecondary);

  // Others
  TextStyle get button =>
      Design.typography.button.copyWith(color: _colors.textPrimary);
  TextStyle get caption =>
      Design.typography.caption.copyWith(color: _colors.textSecondary);
  TextStyle get helper =>
      Design.typography.helper.copyWith(color: _colors.textTertiary);
  TextStyle get link => Design.typography.link;
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
    fontFamily: Design.typography.fontFamily,
    textTheme: TextTheme(
      displayLarge: Design.typography.headline1,
      displayMedium: Design.typography.headline2,
      displaySmall: Design.typography.headline3,
      bodyLarge: Design.typography.bodyLarge,
      bodyMedium: Design.typography.bodyMedium,
      bodySmall: Design.typography.bodySmall,
      labelLarge: Design.typography.labelLarge,
      labelMedium: Design.typography.labelMedium,
      labelSmall: Design.typography.labelSmall,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Design.colors.surface,
      foregroundColor: Design.colors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: Design.typography.headline4,
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
        textStyle: Design.typography.button,
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
        textStyle: Design.typography.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Design.colors.primary,
        textStyle: Design.typography.labelLarge,
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
      labelStyle: Design.typography.labelMedium,
      hintStyle: Design.typography.helper,
      errorStyle: Design.typography.caption.copyWith(
        color: Design.colors.error,
      ),
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
      contentTextStyle: Design.typography.bodyMedium.copyWith(
        color: Colors.white,
      ),
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
    fontFamily: Design.typography.fontFamily,
    textTheme: TextTheme(
      displayLarge: Design.typography.headline1.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      displayMedium: Design.typography.headline2.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      displaySmall: Design.typography.headline3.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      bodyLarge: Design.typography.bodyLarge.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      bodyMedium: Design.typography.bodyMedium.copyWith(
        color: Design.colors.textSecondaryDark,
      ),
      bodySmall: Design.typography.bodySmall.copyWith(
        color: Design.colors.textTertiaryDark,
      ),
      labelLarge: Design.typography.labelLarge.copyWith(
        color: Design.colors.textPrimaryDark,
      ),
      labelMedium: Design.typography.labelMedium.copyWith(
        color: Design.colors.textSecondaryDark,
      ),
      labelSmall: Design.typography.labelSmall.copyWith(
        color: Design.colors.textTertiaryDark,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Design.colors.surfaceDark,
      foregroundColor: Design.colors.textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: Design.typography.headline4.copyWith(
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
        textStyle: Design.typography.button,
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
        textStyle: Design.typography.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Design.colors.primary,
        textStyle: Design.typography.labelLarge,
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
      labelStyle: Design.typography.labelMedium.copyWith(
        color: Design.colors.textSecondaryDark,
      ),
      hintStyle: Design.typography.helper.copyWith(
        color: Design.colors.textTertiaryDark,
      ),
      errorStyle: Design.typography.caption.copyWith(
        color: Design.colors.error,
      ),
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
      contentTextStyle: Design.typography.bodyMedium.copyWith(
        color: Colors.white,
      ),
    ),
  );
}
