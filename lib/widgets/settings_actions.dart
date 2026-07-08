// lib/widgets/settings_actions.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/controllers/settings_controller.dart';
import 'package:meritbox_mobile/design/design.dart';

class ThemeToggleButton extends GetView<SettingsController> {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: Icon(controller.themeIcon),
        tooltip: controller.themeLabel,
        onPressed: controller.toggleTheme,
      ),
    );
  }
}

class LanguageSwitcherButton extends GetView<SettingsController> {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Design.icons.language),
      onSelected: controller.changeLocale,
      itemBuilder: (context) => controller.supportedLocales
          .map(
            (entry) => PopupMenuItem<String>(
              value: entry.key,
              child: Obx(
                () => Row(
                  children: [
                    if (controller.isLocale(entry.key))
                      Icon(Design.icons.check, size: Design.spacing.iconSmall)
                    else
                      SizedBox(width: Design.spacing.iconSmall),
                    SizedBox(width: Design.spacing.sm),
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

List<Widget> settingsActions() => const [
  ThemeToggleButton(),
  LanguageSwitcherButton(),
];
