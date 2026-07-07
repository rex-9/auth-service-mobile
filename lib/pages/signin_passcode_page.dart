// lib/pages/signin_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import '../controllers/auth_controller.dart';
import '../design/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/passcode_field.dart';

class SignInPasscodePage extends GetView<AuthController> {
  const SignInPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleConstants.signinTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleConstants.signinHeading.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                LocaleConstants.signinSubtitle.trParams({
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
                    LocaleConstants.cooldownMessage.trParams({
                      'seconds': '${controller.cooldownSecondsLeft.value}',
                    }),
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }
              if (controller.hasFailureHistory.value &&
                  controller.attemptsLeft.value < AuthController.maxAttempts) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    LocaleConstants.attemptsRemaining.trParams({
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
                    ? LocaleConstants.tryAgainIn.trParams({
                        'seconds': '${controller.cooldownSecondsLeft.value}',
                      })
                    : controller.isLoading.value
                    ? LocaleConstants.signingIn.tr
                    : LocaleConstants.signinTitle.tr,
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
                child: Text(LocaleConstants.useDifferentEmail.tr),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPasscode),
                child: Text(LocaleConstants.forgotPasscodeLink.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
