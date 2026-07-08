// lib/design/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppTheme {
  const AppTheme();

  ThemeData get light {
    return ThemeData(
      // Color Scheme
      brightness: Brightness.light,
      primaryColor: Design.colors.primary,
      scaffoldBackgroundColor: Design.colors.background,
      colorScheme: ColorScheme.light(
        primary: Design.colors.primary,
        secondary: Design.colors.secondary,
        error: Design.colors.error,
        surface: Design.colors.surface,
      ),

      // Typography
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

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Design.colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: Design.typography.headline4,
      ),

      // Button Themes
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

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
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

      // Card Theme - Fixed for Flutter 3.x
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
        ),
        margin: EdgeInsets.zero,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Design.colors.divider,
        thickness: 1,
        space: Design.spacing.lg,
      ),

      // Dialog Theme - Fixed for Flutter 3.x
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
        ),
      ),

      // Snackbar Theme
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

  ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Design.colors.primary,
      scaffoldBackgroundColor: Design.colors.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: Design.colors.primary,
        secondary: Design.colors.secondary,
        error: Design.colors.error,
        surface: Design.colors.surfaceDark,
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
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Design.colors.surfaceDark,
        foregroundColor: Design.colors.textPrimaryDark,
        elevation: 0,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Design.colors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, Design.spacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          ),
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
        labelStyle: Design.typography.labelMedium.copyWith(
          color: Design.colors.textSecondaryDark,
        ),
        hintStyle: Design.typography.helper.copyWith(
          color: Design.colors.textTertiaryDark,
        ),
      ),

      // Card Theme - Fixed for Flutter 3.x
      cardTheme: CardThemeData(
        color: Design.colors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: Design.colors.dividerDark,
        thickness: 1,
      ),
    );
  }
}
