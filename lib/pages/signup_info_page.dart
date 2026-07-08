// lib/pages/signup_info_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
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
      appBar: AppBar(title: Text(Constants.locale.signupInfoTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Constants.locale.signupInfoHeading.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            CustomTextField(
              label: Constants.locale.fullNameLabel.tr,
              hint: Constants.locale.fullNameHint.tr,
              onChanged: (value) => controller.fullName.value = value,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: Constants.locale.usernameLabel.tr,
              hint: Constants.locale.usernameHint.tr,
              onChanged: (value) =>
                  controller.username.value = value.toLowerCase().trim(),
            ),

            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: controller.isLoading.value
                    ? Constants.locale.creatingAccount.tr
                    : Constants.locale.createAccountButton.tr,
                onPressed: () => controller.signUp(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
