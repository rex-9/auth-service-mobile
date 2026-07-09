// lib/pages/verify_email_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/design.dart';

class VerifyEmailPage extends GetView<AuthController> {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];

    return AppPage(
      title: Constants.locale.verifyEmailTitle.tr,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Constants.locale.verifyEmailHeading.tr,
            style: context.typo.headline3,
          ),
          SizedBox(height: Design.spacing.sm),
          Obx(
            () => Text(
              Constants.locale.verifyEmailSubtitle.trParams({
                'email': controller.email.value,
              }),
              style: context.typo.bodyMedium,
            ),
          ),
          SizedBox(height: Design.spacing.xxxl),

          AppPasscodeField(
            pinController: controller.verifyPin,
            onCompleted: (pin) {
              controller.verifyCode(pin);
            },
          ),

          SizedBox(height: Design.spacing.xxxl),
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

          SizedBox(height: Design.spacing.lg),
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
                  style: context.typo.labelLarge.copyWith(
                    color: controller.resendSecondsLeft.value > 0
                        ? context.colors.textTertiary
                        : context.colors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
