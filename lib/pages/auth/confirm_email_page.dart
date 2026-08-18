// lib/pages/auth/confirm_email_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/controllers/controllers.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/routes/routes.dart';

class ConfirmEmailPage extends GetView<AuthController> {
  const ConfirmEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];

    // Auto-send code if not already sent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.resendSecondsLeft.value == 0) {
        controller.sendConfirmationOTPCode();
      }
    });

    return AppPage(
      title: Constants.locale.confirmEmailTitle.tr,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Design.spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Constants.locale.confirmEmailHeading.tr,
                style: context.typo.headline1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.sm),
              Obx(
                () => Text(
                  Constants.locale.confirmEmailSubtitle.trParams({
                    'email': controller.email.value,
                  }),
                  style: context.typo.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Design.spacing.xxxl),

              AppPasscodeField(
                pinController: controller.confirmPin,
                onCompleted: (pin) {
                  controller.confirmOTPCode(pin);
                },
              ),

              SizedBox(height: Design.spacing.xxxl),
              AppButton(
                text: Constants.locale.confirmCodeButton.tr,
                onPressed: () {
                  if (controller.confirmPin.text.length != 6) {
                    controller.confirmPin.triggerError();
                    AppSnackbar.error(Constants.locale.enter6DigitCode.tr);
                    return;
                  }
                  controller.confirmOTPCode(controller.confirmPin.text);
                },
              ),

              SizedBox(height: Design.spacing.lg),
              Obx(
                () => AppButton(
                  type: ButtonTypeEnum.text,
                  onPressed: controller.resendSecondsLeft.value > 0
                      ? null
                      : () => controller.sendConfirmationOTPCode(),
                  text: controller.resendSecondsLeft.value > 0
                      ? Constants.locale.resendCodeIn.trParams({
                          'seconds': '${controller.resendSecondsLeft.value}',
                        })
                      : Constants.locale.resendCode.tr,
                ),
              ),

              SizedBox(height: Design.spacing.lg),
              AppButton(
                type: ButtonTypeEnum.text,
                onPressed: () {
                  controller.email.value = '';
                  controller.confirmPin.clear();
                  Get.offAllNamed(AppRoutes.auth);
                },
                text: Constants.locale.useDifferentEmail.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
