// lib/modules/auth/pages/forgot_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';

import '../auth.dart';

class ForgotPasscodePage extends GetView<AuthController> {
  const ForgotPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: controller.email.value);

    return AppPage(
      title: Constants.locale.forgotPasscodeTitle.tr,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Design.spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Constants.locale.forgotPasscodeSubtitle.tr,
                style: context.typo.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.xxxl),

              Obx(
                () => AppInputField(
                  label: Constants.locale.emailLabel.tr,
                  hint: Constants.locale.emailHint.tr,
                  error: controller.emailError.value,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => controller.email.value = value,
                ),
              ),

              SizedBox(height: Design.spacing.xxxl),
              Obx(() {
                final waiting = controller.resendSecondsLeft.value > 0;
                return AppButton(
                  text: waiting
                      ? Constants.locale.resendCodeIn.trParams({
                          'seconds': '${controller.resendSecondsLeft.value}',
                        })
                      : Constants.locale.sendResetLink.tr,
                  onPressed: () {
                    if (waiting) return;
                    controller.forgotPassword();
                  },
                );
              }),

              SizedBox(height: Design.spacing.lg),
              AppButton(
                type: EButtonType.text,
                onPressed: () => Get.back(),
                text: Constants.locale.backToSignIn.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
