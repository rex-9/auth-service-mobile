// lib/modules/auth/pages/signup_password_create_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/routes/routes.dart';

import '../auth.dart';

class SignUpPasswordCreatePage extends GetView<AuthController> {
  const SignUpPasswordCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isGoogle = controller.isGooglePasswordSetup;

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
                isGoogle
                    ? Constants.locale.googlePasscodeHeading.tr
                    : Constants.locale.createPasscodeHeading.tr,
                style: context.typo.headline1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.sm),
              Text(
                isGoogle
                    ? Constants.locale.googlePasscodeSubtitle.tr
                    : Constants.locale.createPasscodeSubtitle.tr,
                style: context.typo.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Design.spacing.xxxl),

              Text(
                Constants.locale.passcodeLabel.tr,
                style: context.typo.labelMedium,
              ),
              SizedBox(height: Design.spacing.sm),
              AppPasswordField(
                pinController: controller.signupPin,
                onChanged: (value) => controller.password.value = value,
                onCompleted: (_) {
                  // Auto-move to confirm page when 6 digits entered
                  if (controller.password.value.length == 6) {
                    controller.signupConfirmPin.clear();
                    controller.confirmPassword.value = '';
                    AppRoutes.toSignUpPasswordConfirm();
                  }
                },
              ),

              SizedBox(height: Design.spacing.xl),
              AppButton(
                type: EButtonType.text,
                onPressed: () => Get.back(),
                text: Constants.locale.goBack.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


