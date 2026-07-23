// lib/pages/auth/signup_passcode_create_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth_service_mobile/constants/constants.dart';
import 'package:auth_service_mobile/controllers/controllers.dart';
import 'package:auth_service_mobile/design/design.dart';
import 'package:auth_service_mobile/routes/routes.dart';

class SignUpPasscodeCreatePage extends GetView<AuthController> {
  const SignUpPasscodeCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isGoogle = controller.isGooglePasscodeSetup;

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
              AppPasscodeField(
                pinController: controller.signupPin,
                onChanged: (value) => controller.passcode.value = value,
                onCompleted: (_) {
                  // Auto-move to confirm page when 6 digits entered
                  if (controller.passcode.value.length == 6) {
                    controller.signupConfirmPin.clear();
                    controller.confirmPasscode.value = '';
                    AppRoutes.toSignUpPasscodeConfirm();
                  }
                },
              ),

              SizedBox(height: Design.spacing.xl),
              AppButton(
                type: ButtonTypeEnum.text,
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
