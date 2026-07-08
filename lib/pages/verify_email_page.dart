// lib/pages/verify_email_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/components/components.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailPage extends GetView<AuthController> {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];

    return Scaffold(
      appBar: AppBar(title: Text(Constants.locale.verifyEmailTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Constants.locale.verifyEmailHeading.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                Constants.locale.verifyEmailSubtitle.trParams({
                  'email': controller.email.value,
                }),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 32),

            AppPasscodeField(
              pinController: controller.verifyPin,
              onCompleted: (pin) {
                controller.verifyCode(pin);
              },
            ),

            const SizedBox(height: 32),
            Obx(
              () => AppButton(
                text: controller.isLoading.value
                    ? Constants.locale.verifying.tr
                    : Constants.locale.verifyCodeButton.tr,
                onPressed: () {
                  if (controller.verifyPin.text.length != 6) {
                    controller.verifyPin.triggerError();
                    AppSnackbar.error(Constants.locale.enter6DigitCode.tr);
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
                        ? Constants.locale.resendCodeIn.trParams({
                            'seconds': '${controller.resendSecondsLeft.value}',
                          })
                        : Constants.locale.resendCode.tr,
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
