// lib/controllers/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

/// Theme + locale settings, persisted with GetStorage.
/// Mirrors the web ThemeToggle ("auto" | "day" | "night") and LanguageSwitcher.
class SettingsController extends GetxController {
  final StorageService _storage = Get.find();

  var themeName = 'auto'.obs; // auto | day | night (same values as web)
  var localeCode = 'en_US'.obs; // en_US | es_ES | my_MM

  ThemeMode get themeMode => switch (themeName.value) {
    'day' => ThemeMode.light,
    'night' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  Locale get locale {
    final parts = localeCode.value.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }

  IconData get themeIcon => switch (themeName.value) {
    'day' => Icons.light_mode_outlined,
    'night' => Icons.dark_mode_outlined,
    _ => Icons.brightness_auto_outlined,
  };

  @override
  void onInit() {
    super.onInit();
    themeName.value = _storage.getThemeName() ?? 'auto';
    localeCode.value = _storage.getLocaleCode() ?? 'en_US';
  }

  /// Cycles auto -> day -> night -> auto (like the web toggle).
  void cycleTheme() {
    themeName.value = switch (themeName.value) {
      'auto' => 'day',
      'day' => 'night',
      _ => 'auto',
    };
    _storage.setThemeName(themeName.value);
    Get.changeThemeMode(themeMode);
  }

  void changeLocale(String code) {
    localeCode.value = code;
    _storage.setLocaleCode(code);
    Get.updateLocale(locale);
  }
}
