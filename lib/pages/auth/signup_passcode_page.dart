// lib/pages/signup_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/routes/routes.dart';

/// Create + confirm a 6-digit passcode. Used for both email sign up and
/// finishing a new Google account (challenge token flow).
class SignUpPasscodePage extends GetView<AuthController> {
  const SignUpPasscodePage({super.key});

  void _onContinue() {
    if (controller.passcode.value.length != 6) {
      controller.signupPin.triggerError();
      AppSnackbar.error(Constants.locale.passcode6Digits.tr);
      return;
    }
    if (controller.passcode.value != controller.confirmPasscode.value) {
      controller.signupConfirmPin.triggerError();
      AppSnackbar.error(Constants.locale.passcodesDoNotMatch.tr);
      return;
    }

    if (controller.isGooglePasscodeSetup) {
      controller.completeGoogleSignIn();
      return;
    }

    AppRoutes.toSignUpInfo(
      email: controller.email.value,
      passcode: controller.passcode.value,
      confirmPasscode: controller.confirmPasscode.value,
    );
  }

  void _syncConfirmError() {
    if (controller.passcode.value.length == 6 &&
        controller.confirmPasscode.value.length == 6) {
      if (controller.passcode.value != controller.confirmPasscode.value) {
        controller.signupConfirmPin.triggerError();
      } else {
        controller.signupConfirmPin.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGoogle = controller.isGooglePasscodeSetup;

    return AppPage(
      title: Constants.locale.signupTitle.tr,
      showBackButton: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGoogle
                  ? Constants.locale.googlePasscodeHeading.tr
                  : Constants.locale.createPasscodeHeading.tr,
              style: context.typo.headline3,
            ),
            SizedBox(height: Design.spacing.sm),
            Text(
              isGoogle
                  ? Constants.locale.googlePasscodeSubtitle.tr
                  : Constants.locale.createPasscodeSubtitle.tr,
              style: context.typo.bodyMedium,
            ),
            SizedBox(height: Design.spacing.xxxl),

            Text(
              Constants.locale.passcodeLabel.tr,
              style: context.typo.labelMedium,
            ),
            SizedBox(height: Design.spacing.sm),
            AppPasscodeField(
              pinController: controller.signupPin,
              onChanged: (value) {
                controller.passcode.value = value;
                _syncConfirmError();
              },
            ),

            SizedBox(height: Design.spacing.xxl),
            Text(
              Constants.locale.confirmPasscodeLabel.tr,
              style: context.typo.labelMedium,
            ),
            SizedBox(height: Design.spacing.sm),
            AppPasscodeField(
              pinController: controller.signupConfirmPin,
              onChanged: (value) {
                controller.confirmPasscode.value = value;
                _syncConfirmError();
              },
            ),

            SizedBox(height: Design.spacing.xxxl),
            AppButton(
              text: Constants.locale.continueButton.tr,
              onPressed: _onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
