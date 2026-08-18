// lib/pages/auth/signup_info_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/controllers/controllers.dart';
import 'package:rexone_mobile/design/design.dart';

class SignUpInfoPage extends GetView<AuthController> {
  const SignUpInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];
    controller.passcode.value = arguments['passcode'];
    controller.confirmPasscode.value =
        arguments['confirm_passcode'] ?? arguments['passcode'];

    return AppPage(
      title: Constants.locale.signupInfoTitle.tr,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Design.spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Constants.locale.signupInfoHeading.tr,
                style: context.typo.headline1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.xxxl),

              AppInputField(
                label: Constants.locale.fullNameLabel.tr,
                hint: Constants.locale.fullNameHint.tr,
                onChanged: (value) => controller.fullName.value = value,
              ),
              SizedBox(height: Design.spacing.lg),

              AppInputField(
                label: Constants.locale.usernameLabel.tr,
                hint: Constants.locale.usernameHint.tr,
                onChanged: (value) =>
                    controller.username.value = value.toLowerCase().trim(),
              ),

              SizedBox(height: Design.spacing.xxxl),
              AppButton(
                text: Constants.locale.createAccountButton.tr,
                onPressed: () => controller.signUp(),
              ),

              SizedBox(height: Design.spacing.lg),
              AppButton(
                type: ButtonType.text,
                onPressed: () {
                  controller.passcode.value = '';
                  controller.confirmPasscode.value = '';
                  controller.signupPin.clear();
                  controller.signupConfirmPin.clear();
                  Get.back();
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
