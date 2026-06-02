// lib/pages/signin_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';

class SignInPasscodePage extends GetView<AuthController> {
  const SignInPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pinController = PinInputController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your passcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'Enter your 6-digit passcode for ${controller.email.value}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 32),

            MaterialPinField(
              length: 6,
              pinController: pinController,
              onCompleted: (pin) {
                controller.passcode.value = pin;
                controller.signIn();
              },
              onChanged: (value) {
                controller.passcode.value = value;
              },
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                spacing: 12,
                borderRadius: BorderRadius.circular(12),
                borderWidth: 1.5,
                focusedBorderWidth: 2.0,
                borderColor: Colors.grey,
                focusedBorderColor: Colors.blue,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: controller.isLoading.value ? 'Signing in...' : 'Sign In',
                onPressed: () {
                  if (controller.passcode.value.length == 6) {
                    controller.signIn();
                  } else {
                    pinController.triggerError();
                    Get.snackbar('Error', 'Please enter 6-digit passcode');
                  }
                },
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text('Use different email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
