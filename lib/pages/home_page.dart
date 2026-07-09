// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/pages/pages.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: Constants.locale.home.tr,
      actions: [
        IconButton(
          icon: Icon(Design.icons.settings),
          onPressed: () => Get.to(() => const SettingsPage()),
          tooltip: Constants.locale.settings.tr,
        ),
      ],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Constants.locale.welcomeHome.tr,
              style: context.typo.headline1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Design.spacing.lg),
            Obx(
              () => Text(
                'Email: ${controller.currentUser.value?.email ?? Constants.locale.loading.tr}',
                style: context.typo.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
