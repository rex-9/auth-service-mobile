// lib/pages/signup_info_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class SignUpInfoPage extends GetView<AuthController> {
  const SignUpInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];
    controller.passcode.value = arguments['passcode'];
    controller.confirmPasscode.value =
        arguments['confirm_passcode'] ?? arguments['passcode'];

    return Scaffold(
      appBar: AppBar(title: Text('signup_info_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'signup_info_heading'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            CustomTextField(
              label: 'full_name_label'.tr,
              hint: 'full_name_hint'.tr,
              onChanged: (value) => controller.fullName.value = value,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'username_label'.tr,
              hint: 'username_hint'.tr,
              onChanged: (value) =>
                  controller.username.value = value.toLowerCase().trim(),
            ),

            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: controller.isLoading.value
                    ? 'creating_account'.tr
                    : 'create_account_button'.tr,
                onPressed: () => controller.signUp(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
