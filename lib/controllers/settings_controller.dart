// lib/controllers/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';
import '../services/storage_service.dart';
import '../locales/app_translations.dart';

/// Theme + locale settings, persisted with GetStorage.
class SettingsController extends GetxController {
  final StorageService _storage = Get.find();

  // ===== OBSERVABLES =====
  var isDarkMode = false.obs; // true = dark, false = light
  var localeCode = 'en_US'.obs; // en_US | es_ES | my_MM

  // ===== THEME =====
  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  IconData get themeIcon =>
      isDarkMode.value ? Design.icons.darkMode : Design.icons.lightMode;

  String get themeLabel => isDarkMode.value ? 'Dark' : 'Light';

  // ===== COLORS (Theme-Aware) =====
  Color get backgroundColor => isDarkMode.value
      ? Design.colors.backgroundDark
      : Design.colors.background;

  Color get surfaceColor =>
      isDarkMode.value ? Design.colors.surfaceDark : Design.colors.surface;

  Color get textPrimaryColor => isDarkMode.value
      ? Design.colors.textPrimaryDark
      : Design.colors.textPrimary;

  Color get textSecondaryColor => isDarkMode.value
      ? Design.colors.textSecondaryDark
      : Design.colors.textSecondary;

  Color get textTertiaryColor => isDarkMode.value
      ? Design.colors.textTertiaryDark
      : Design.colors.textTertiary;

  Color get borderColor =>
      isDarkMode.value ? Design.colors.borderDark : Design.colors.border;

  Color get dividerColor =>
      isDarkMode.value ? Design.colors.dividerDark : Design.colors.divider;

  // ===== TYPOGRAPHY (Theme-Aware) =====
  TextStyle get headline1 =>
      Design.typography.headline1.copyWith(color: textPrimaryColor);
  TextStyle get headline2 =>
      Design.typography.headline2.copyWith(color: textPrimaryColor);
  TextStyle get headline3 =>
      Design.typography.headline3.copyWith(color: textPrimaryColor);
  TextStyle get headline4 =>
      Design.typography.headline4.copyWith(color: textPrimaryColor);

  TextStyle get bodyLarge =>
      Design.typography.bodyLarge.copyWith(color: textPrimaryColor);
  TextStyle get bodyMedium =>
      Design.typography.bodyMedium.copyWith(color: textSecondaryColor);
  TextStyle get bodySmall =>
      Design.typography.bodySmall.copyWith(color: textTertiaryColor);

  TextStyle get labelLarge =>
      Design.typography.labelLarge.copyWith(color: textPrimaryColor);
  TextStyle get labelMedium =>
      Design.typography.labelMedium.copyWith(color: textSecondaryColor);

  TextStyle get button =>
      Design.typography.button.copyWith(color: textPrimaryColor);
  TextStyle get caption =>
      Design.typography.caption.copyWith(color: textSecondaryColor);
  TextStyle get helper =>
      Design.typography.helper.copyWith(color: textTertiaryColor);
  TextStyle get link => Design.typography.link;

  // ===== LOCALE =====
  Locale get locale {
    final parts = localeCode.value.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }

  String get currentLanguageName =>
      AppTranslations.supportedLocales[localeCode.value] ?? 'English';

  List<MapEntry<String, String>> get supportedLocales =>
      AppTranslations.supportedLocales.entries.toList();

  // ===== INIT =====
  @override
  void onInit() {
    super.onInit();
    // Load saved theme or default to system
    final savedTheme = _storage.getThemeName();
    if (savedTheme != null) {
      isDarkMode.value = savedTheme == 'dark';
    } else {
      // Default to system theme
      isDarkMode.value = Get.isDarkMode;
    }
    localeCode.value = _storage.getLocaleCode() ?? 'en_US';
  }

  // ===== THEME METHODS =====
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.setThemeName(isDarkMode.value ? 'dark' : 'light');
    Get.changeThemeMode(themeMode);
  }

  void setDarkMode(bool isDark) {
    isDarkMode.value = isDark;
    _storage.setThemeName(isDark ? 'dark' : 'light');
    Get.changeThemeMode(themeMode);
  }

  // ===== LOCALE METHODS =====
  void setLocale(String code) {
    localeCode.value = code;
    _storage.setLocaleCode(code);
    Get.updateLocale(locale);
  }

  void changeLocale(String code) => setLocale(code);

  void cycleLocale() {
    final keys = AppTranslations.supportedLocales.keys.toList();
    final currentIndex = keys.indexOf(localeCode.value);
    final nextIndex = (currentIndex + 1) % keys.length;
    setLocale(keys[nextIndex]);
  }

  // ===== CONVENIENCE =====
  bool isLocale(String code) => localeCode.value == code;

  // ===== RESET =====
  void resetToDefaults() {
    isDarkMode.value = Get.isDarkMode;
    _storage.setThemeName(isDarkMode.value ? 'dark' : 'light');
    Get.changeThemeMode(themeMode);
    setLocale('en_US');
  }
}
