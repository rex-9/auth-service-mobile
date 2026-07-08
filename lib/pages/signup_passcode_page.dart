// lib/pages/signup_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/components/components.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/design/extensions/theme_extensions.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

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

    Get.toNamed(
      AppRoutes.signupInfo,
      arguments: {
        'email': controller.email.value,
        'passcode': controller.passcode.value,
        'confirm_passcode': controller.confirmPasscode.value,
      },
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

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.textPrimary,
        elevation: 0,
        title: Text(
          Constants.locale.signupTitle.tr,
          style: context.styles.headline4,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Design.spacing.screenPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isGoogle
                    ? Constants.locale.googlePasscodeHeading.tr
                    : Constants.locale.createPasscodeHeading.tr,
                style: context.styles.headline3,
              ),
              SizedBox(height: Design.spacing.sm),
              Text(
                isGoogle
                    ? Constants.locale.googlePasscodeSubtitle.tr
                    : Constants.locale.createPasscodeSubtitle.tr,
                style: context.styles.bodyMedium,
              ),
              SizedBox(height: Design.spacing.xxxl),

              Text(
                Constants.locale.passcodeLabel.tr,
                style: context.styles.labelMedium,
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
                style: context.styles.labelMedium,
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
              Obx(
                () => AppButton(
                  text: controller.isLoading.value
                      ? (isGoogle
                            ? Constants.locale.signingIn.tr
                            : Constants.locale.sendingCode.tr)
                      : Constants.locale.continueButton.tr,
                  onPressed: _onContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
