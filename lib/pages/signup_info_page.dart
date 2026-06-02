// lib/pages/register_info_page.dart
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

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about yourself',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            CustomTextField(
              label: 'Full Name',
              hint: 'John Doe',
              onChanged: (value) => controller.fullName.value = value,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Username',
              hint: 'john_doe',
              onChanged: (value) =>
                  controller.username.value = value.toLowerCase(),
            ),

            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: controller.isLoading.value
                    ? 'Creating account...'
                    : 'Create Account',
                onPressed: () => controller.signUp(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
