// lib/widgets/settings_actions.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';
import '../controllers/settings_controller.dart';
import '../locales/app_translations.dart';

/// Theme toggle + language switcher (mirrors the web NavBar ThemeToggle
/// and LanguageSwitcher). Use in any AppBar `actions`.
class ThemeToggleButton extends GetView<SettingsController> {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: Icon(controller.themeIcon),
        tooltip: controller.themeName.value,
        onPressed: controller.cycleTheme,
      ),
    );
  }
}

class LanguageSwitcherButton extends GetView<SettingsController> {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(AppIcons.language),
      onSelected: controller.changeLocale,
      itemBuilder: (context) => AppTranslations.supportedLocales.entries
          .map(
            (entry) => PopupMenuItem<String>(
              value: entry.key,
              child: Obx(
                () => Row(
                  children: [
                    if (controller.localeCode.value == entry.key)
                      const Icon(AppIcons.check, size: 16)
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Text(entry.value),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Convenience list for `AppBar(actions: settingsActions())`.
List<Widget> settingsActions() => const [
  ThemeToggleButton(),
  LanguageSwitcherButton(),
];
