// lib/pages/verify_email_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';

class VerifyEmailPage extends GetView<AuthController> {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pinController = PinInputController();
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify your email',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'We sent a 6-digit code to ${controller.email.value}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 32),

            MaterialPinField(
              length: 6,
              pinController: pinController,
              onCompleted: (pin) {
                controller.verifyCode(pin);
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
                errorColor: Colors.red,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: controller.isLoading.value
                    ? 'Verifying...'
                    : 'Verify Code',
                onPressed: () {
                  if (pinController.text.length != 6) {
                    pinController.triggerError();
                    Get.snackbar('Error', 'Please enter 6-digit code');
                    return;
                  }
                  controller.verifyCode(pinController.text);
                },
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => controller.sendConfirmationCode(),
                child: const Text('Resend Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
