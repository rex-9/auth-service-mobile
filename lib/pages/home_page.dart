import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/settings_actions.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          ...settingsActions(),
          IconButton(
            onPressed: () => controller.signout(),
            icon: const Icon(Icons.logout),
            tooltip: 'sign_out_button'.tr,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('welcome_home'.tr),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                'Email: ${controller.currentUser.value?.email ?? 'loading'.tr}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
