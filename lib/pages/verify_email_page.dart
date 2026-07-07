// lib/pages/verify_email_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/widgets/widgets.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailPage extends GetView<AuthController> {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];

    return Scaffold(
      appBar: AppBar(title: Text('verify_email_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'verify_email_heading'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'verify_email_subtitle'.trParams({
                  'email': controller.email.value,
                }),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 32),

            PasscodeField(
              pinController: controller.verifyPin,
              onCompleted: (pin) {
                controller.verifyCode(pin);
              },
            ),

            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: controller.isLoading.value
                    ? 'verifying'.tr
                    : 'verify_code_button'.tr,
                onPressed: () {
                  if (controller.verifyPin.text.length != 6) {
                    controller.verifyPin.triggerError();
                    AppSnackbar.error('enter_6_digit_code'.tr);
                    return;
                  }
                  controller.verifyCode(controller.verifyPin.text);
                },
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Obx(
                () => TextButton(
                  onPressed: controller.resendSecondsLeft.value > 0
                      ? null
                      : () => controller.sendConfirmationCode(),
                  child: Text(
                    controller.resendSecondsLeft.value > 0
                        ? 'resend_code_in'.trParams({
                            'seconds': '${controller.resendSecondsLeft.value}',
                          })
                        : 'resend_code'.tr,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
