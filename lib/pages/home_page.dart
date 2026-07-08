import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/design.dart';

import '../controllers/auth_controller.dart';
import '../widgets/settings_actions.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.locale.home.tr),
        actions: [
          ...settingsActions(),
          IconButton(
            onPressed: () => controller.signout(),
            icon: Icon(Design.icons.logout),
            tooltip: Constants.locale.signOutButton.tr,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Constants.locale.welcomeHome.tr),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                'Email: ${controller.currentUser.value?.email ?? Constants.locale.loading.tr}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
