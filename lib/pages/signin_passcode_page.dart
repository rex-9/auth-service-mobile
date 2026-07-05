// lib/pages/signin_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(title: Text('signin_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'signin_heading'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'signin_subtitle'.trParams({'email': controller.email.value}),
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
                    'cooldown_message'.trParams({
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
                    'attempts_remaining'.trParams({
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
                    ? 'try_again_in'.trParams({
                        'seconds': '${controller.cooldownSecondsLeft.value}',
                      })
                    : controller.isLoading.value
                    ? 'signing_in'.tr
                    : 'signin_title'.tr,
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
                child: Text('use_different_email'.tr),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPasscode),
                child: Text('forgot_passcode_link'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
