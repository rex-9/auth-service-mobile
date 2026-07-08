// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/design/extensions/theme_extensions.dart';
import '../controllers/auth_controller.dart';
import '../widgets/settings_actions.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.textPrimary,
        elevation: 0,
        title: Text(Constants.locale.home.tr, style: context.styles.headline3),
        actions: [
          ...settingsActions(),
          IconButton(
            onPressed: () => controller.signout(),
            icon: Icon(Design.icons.logout, color: context.colors.textPrimary),
            tooltip: Constants.locale.signOutButton.tr,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Constants.locale.welcomeHome.tr,
              style: context.styles.headline1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Design.spacing.lg),
            Obx(
              () => Text(
                'Email: ${controller.currentUser.value?.email ?? Constants.locale.loading.tr}',
                style: context.styles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
