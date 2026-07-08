// lib/pages/signin_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/design.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/passcode_field.dart';

class SignInPasscodePage extends GetView<AuthController> {
  const SignInPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Constants.locale.signinTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Constants.locale.signinHeading.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                Constants.locale.signinSubtitle.trParams({
                  'email': controller.email.value,
                }),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 32),

            Obx(
              () => PasscodeField(
                pinController: controller.signinPin,
                enabled: controller.cooldownSecondsLeft.value == 0,
                onChanged: (value) => controller.passcode.value = value,
                onCompleted: (pin) {
                  controller.passcode.value = pin;
                  controller.signIn();
                },
              ),
            ),

            // Attempts remaining + cooldown feedback (mirrors the web).
            Obx(() {
              if (controller.cooldownSecondsLeft.value > 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    Constants.locale.cooldownMessage.trParams({
                      'seconds': '${controller.cooldownSecondsLeft.value}',
                    }),
                    style: TextStyle(color: Design.colors.error),
                  ),
                );
              }
              if (controller.hasFailureHistory.value &&
                  controller.attemptsLeft.value < AuthController.maxAttempts) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    Constants.locale.attemptsRemaining.trParams({
                      'left': '${controller.attemptsLeft.value}',
                      'total': '${AuthController.maxAttempts}',
                    }),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: controller.cooldownSecondsLeft.value > 0
                    ? Constants.locale.tryAgainIn.trParams({
                        'seconds': '${controller.cooldownSecondsLeft.value}',
                      })
                    : controller.isLoading.value
                    ? Constants.locale.signingIn.tr
                    : Constants.locale.signinTitle.tr,
                onPressed: () => controller.signIn(),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  controller.passcode.value = '';
                  controller.signinPin.clear();
                  Get.back();
                },
                child: Text(Constants.locale.useDifferentEmail.tr),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPasscode),
                child: Text(Constants.locale.forgotPasscodeLink.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
