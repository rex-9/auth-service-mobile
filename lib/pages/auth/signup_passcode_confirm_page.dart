// lib/pages/auth/signup_passcode_confirm_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/controllers/controllers.dart';
import 'package:rexone_mobile/design/design.dart';

class SignUpPasscodeConfirmPage extends GetView<AuthController> {
  const SignUpPasscodeConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: Constants.locale.signupTitle.tr,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Design.spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Constants.locale.confirmPasscodeHeading.tr,
                style: context.typo.headline1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.sm),
              Text(
                Constants.locale.confirmPasscodeSubtitle.tr,
                style: context.typo.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.xxxl),

              Text(
                Constants.locale.confirmPasscodeHeading.tr,
                style: context.typo.labelMedium,
              ),
              SizedBox(height: Design.spacing.sm),
              AppPasscodeField(
                pinController: controller.signupConfirmPin,
                onChanged: (value) => controller.confirmPasscode.value = value,
                onCompleted: (_) => controller.handleConfirmPasscode(),
              ),

              SizedBox(height: Design.spacing.xxxl),
              AppButton(
                text: Constants.locale.confirm.tr,
                onPressed: controller.handleConfirmPasscode,
              ),

              SizedBox(height: Design.spacing.lg),
              AppButton(
                type: EButtonType.text,
                onPressed: () {
                  controller.confirmPasscode.value = '';
                  controller.signupConfirmPin.clear();
                  controller.passcode.value = '';
                  controller.signupPin.clear();
                  Get.back();
                },
                text: Constants.locale.changePasscode.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
