// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/config/config.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/design.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return AppPage(
      title: Constants.locale.settings.tr,
      showBackButton: true,
      child: ListView(
        children: [
          // Theme Section
          _buildSectionHeader(context, Constants.locale.theme.tr),
          _buildThemeTile(context),

          SizedBox(height: Design.spacing.xxl),

          // Language Section
          _buildSectionHeader(context, Constants.locale.language.tr),
          _buildLanguageTile(context),

          SizedBox(height: Design.spacing.xxl),

          // Account Section
          _buildSectionHeader(context, Constants.locale.account.tr),
          _buildAccountTile(context, authController),

          SizedBox(height: Design.spacing.xxl),

          // App Info Section
          _buildSectionHeader(context, Constants.locale.appInfo.tr),
          _buildAppInfoTile(context),

          SizedBox(height: Design.spacing.xl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: Design.spacing.sm,
        bottom: Design.spacing.md,
      ),
      child: Text(
        title.toUpperCase(),
        style: context.typo.labelMedium.copyWith(
          color: context.colors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return Obx(
      () => Container(
        decoration: Design.styles.card.copyWith(color: context.colors.surface),
        child: ListTile(
          leading: Icon(controller.themeIcon, color: context.colors.primary),
          title: Text(Constants.locale.theme.tr, style: context.typo.bodyLarge),
          subtitle: Text(controller.themeLabel, style: context.typo.bodyMedium),
          trailing: Switch(
            value: controller.isDarkMode.value,
            onChanged: (_) => controller.toggleTheme(),
            activeThumbColor: context.colors.primary,
          ),
          onTap: controller.toggleTheme,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return Container(
      decoration: Design.styles.card.copyWith(color: context.colors.surface),
      child: ListTile(
        leading: Icon(Design.icons.language, color: context.colors.primary),
        title: Text(
          Constants.locale.language.tr,
          style: context.typo.bodyLarge,
        ),
        subtitle: Obx(
          () => Text(
            controller.currentLanguageName,
            style: context.typo.bodyMedium,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: context.colors.textSecondary,
          ),
          onSelected: controller.changeLocale,
          itemBuilder: (context) => controller.supportedLocales
              .map(
                (entry) => PopupMenuItem<String>(
                  value: entry.key,
                  child: Obx(
                    () => Row(
                      children: [
                        if (controller.isLocale(entry.key))
                          Icon(
                            Design.icons.check,
                            size: Design.spacing.iconSmall,
                            color: context.colors.primary,
                          )
                        else
                          SizedBox(width: Design.spacing.iconSmall),
                        SizedBox(width: Design.spacing.sm),
                        Text(
                          entry.value,
                          style: context.typo.bodyMedium.copyWith(
                            color: controller.isLocale(entry.key)
                                ? context.colors.primary
                                : context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAccountTile(
    BuildContext context,
    AuthController authController,
  ) {
    return Container(
      decoration: Design.styles.card.copyWith(color: context.colors.surface),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Design.icons.person,
              color: context.colors.textSecondary,
            ),
            title: Text(
              Constants.locale.account.tr,
              style: context.typo.bodyLarge,
            ),
            subtitle: Obx(
              () => Text(
                authController.currentUser.value?.email ??
                    Constants.locale.loading.tr,
                style: context.typo.bodyMedium,
              ),
            ),
          ),
          Divider(
            color: context.colors.divider,
            height: 1,
            indent: Design.spacing.lg,
            endIndent: Design.spacing.lg,
          ),
          ListTile(
            leading: Icon(Design.icons.logout, color: context.colors.error),
            title: Text(
              Constants.locale.signOutButton.tr,
              style: context.typo.bodyLarge.copyWith(
                color: context.colors.error,
              ),
            ),
            onTap: () => _showLogoutDialog(context, authController),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoTile(BuildContext context) {
    final config = AppConfig();

    return Container(
      decoration: Design.styles.card.copyWith(color: context.colors.surface),
      child: ListTile(
        leading: Icon(Design.icons.info, color: context.colors.textSecondary),
        title: Text(config.appName, style: context.typo.bodyLarge),
        subtitle: Obx(
          () => Text(
            'v${controller.appVersion.value}',
            style: context.typo.bodyMedium,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.dialog(
      AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Design.spacing.radiusLarge),
        ),
        title: Text(
          Constants.locale.signOutButton.tr,
          style: context.typo.headline4,
        ),
        content: Text(
          Constants.locale.logoutConfirmation.tr,
          style: context.typo.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              Constants.locale.cancel.tr,
              style: context.typo.labelLarge,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.signOut();
            },
            child: Text(
              Constants.locale.signOutButton.tr,
              style: context.typo.labelLarge.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
