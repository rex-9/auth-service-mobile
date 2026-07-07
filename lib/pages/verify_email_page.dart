// lib/pages/verify_email_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/widgets/widgets.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailPage extends GetView<AuthController> {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];

    return Scaffold(
      appBar: AppBar(title: Text(LocaleConstants.verifyEmailTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleConstants.verifyEmailHeading.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                LocaleConstants.verifyEmailSubtitle.trParams({
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
                    ? LocaleConstants.verifying.tr
                    : LocaleConstants.verifyCodeButton.tr,
                onPressed: () {
                  if (controller.verifyPin.text.length != 6) {
                    controller.verifyPin.triggerError();
                    AppSnackbar.error(LocaleConstants.enter6DigitCode.tr);
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
                        ? LocaleConstants.resendCodeIn.trParams({
                            'seconds': '${controller.resendSecondsLeft.value}',
                          })
                        : LocaleConstants.resendCode.tr,
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
