// lib/pages/signin_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/components/components.dart';
import 'package:meritbox_mobile/design/design.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class SignInPasscodePage extends GetView<AuthController> {
  const SignInPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.textPrimary,
        elevation: 0,
        title: Text(
          Constants.locale.signinTitle.tr,
          style: context.typo.headline4,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Design.spacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Constants.locale.signinHeading.tr,
              style: context.typo.headline3,
            ),
            SizedBox(height: Design.spacing.sm),
            Obx(
              () => Text(
                Constants.locale.signinSubtitle.trParams({
                  'email': controller.email.value,
                }),
                style: context.typo.bodyMedium,
              ),
            ),
            SizedBox(height: Design.spacing.xxxl),

            Obx(
              () => AppPasscodeField(
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
                  padding: EdgeInsets.only(top: Design.spacing.lg),
                  child: Text(
                    Constants.locale.cooldownMessage.trParams({
                      'seconds': '${controller.cooldownSecondsLeft.value}',
                    }),
                    style: context.typo.caption.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                );
              }
              if (controller.hasFailureHistory.value &&
                  controller.attemptsLeft.value < AuthController.maxAttempts) {
                return Padding(
                  padding: EdgeInsets.only(top: Design.spacing.lg),
                  child: Text(
                    Constants.locale.attemptsRemaining.trParams({
                      'left': '${controller.attemptsLeft.value}',
                      'total': '${AuthController.maxAttempts}',
                    }),
                    style: context.typo.caption,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            SizedBox(height: Design.spacing.xxxl),
            Obx(
              () => AppButton(
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

            SizedBox(height: Design.spacing.lg),
            Center(
              child: TextButton(
                onPressed: () {
                  controller.passcode.value = '';
                  controller.signinPin.clear();
                  Get.back();
                },
                child: Text(
                  Constants.locale.useDifferentEmail.tr,
                  style: context.typo.labelLarge,
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPasscode),
                child: Text(
                  Constants.locale.forgotPasscodeLink.tr,
                  style: context.typo.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
