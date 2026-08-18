// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/config/config.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/controllers/controllers.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/helpers/helpers.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return AppPage(
      title: Constants.locale.settings.tr,
      showBackButton: true,
      child: ListView(
        padding: EdgeInsets.all(Design.spacing.lg),
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
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: Design.spacing.sm,
        bottom: Design.spacing.md,
        top: Design.spacing.md,
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
      () => Card(
        clipBehavior: Clip.antiAlias,
        child: AppListTile(
          leading: Icon(controller.themeIcon, color: context.colors.primary),
          title: Text(Constants.locale.theme.tr),
          subtitle: Text(controller.themeLabel),
          trailing: AppToggle(
            value: controller.isDarkMode.value,
            onChanged: (_) => controller.toggleTheme(),
            activeColor: context.colors.primary,
          ),
          onTap: controller.toggleTheme,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: AppListTile(
        leading: _buildFlagIcon(context),
        title: Text(Constants.locale.language.tr),
        subtitle: Obx(() => Text(controller.currentLanguageName)),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Design.icons.downArrow,
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
                        _buildFlagIcon(context, locale: entry.key),
                        SizedBox(width: Design.spacing.sm),
                        Text(
                          entry.value,
                          style: context.typo.bodyMedium.copyWith(
                            color: controller.isLocale(entry.key)
                                ? context.colors.primary
                                : context.colors.textPrimary,
                          ),
                        ),
                        if (controller.isLocale(entry.key))
                          Icon(
                            Design.icons.check,
                            size: Design.spacing.iconSmall,
                            color: context.colors.primary,
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

  Widget _buildFlagIcon(BuildContext context, {String? locale}) {
    final String code = locale ?? controller.localeCode.value;
    return Text(
      FlagHelper.getEmoji(code),
      style: TextStyle(fontSize: Design.spacing.iconLarge),
    );
  }

  Widget _buildAccountTile(
    BuildContext context,
    AuthController authController,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AppListTile(
            leading: CircleAvatar(
              backgroundColor: context.colors.primary.withValues(alpha: 0.1),
              backgroundImage: authController.currentUser.value?.photo != null
                  ? NetworkImage(authController.currentUser.value!.photo!)
                  : null,
              child: authController.currentUser.value?.photo == null
                  ? Icon(Design.icons.person, color: context.colors.primary)
                  : null,
            ),
            title: Text(
              authController.currentUser.value?.name ??
                  authController.currentUser.value?.username ??
                  Constants.locale.account.tr,
            ),
            subtitle: Obx(
              () => Text(
                authController.currentUser.value?.email ??
                    Constants.locale.loading.tr,
              ),
            ),
          ),
          Divider(
            color: context.colors.divider,
            height: 1,
            indent: Design.spacing.lg,
            endIndent: Design.spacing.lg,
          ),
          AppListTile(
            leading: Icon(Design.icons.logout, color: context.colors.error),
            title: Text(Constants.locale.signOutButton.tr),
            isDestructive: true,
            onTap: () => _showLogoutDialog(context, authController),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoTile(BuildContext context) {
    final config = AppConfig();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: AppListTile(
        leading: Icon(Design.icons.info, color: context.colors.textSecondary),
        title: Text(config.appName),
        subtitle: Obx(() => Text('v${controller.appVersion.value}')),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AuthController authController,
  ) async {
    final confirmed = await AppDialog.confirm(
      context: context,
      title: Constants.locale.signOutButton.tr,
      message: Constants.locale.logoutConfirmation.tr,
      confirmLabel: Constants.locale.signOutButton.tr,
    );
    if (confirmed) authController.signOut();
  }
}
