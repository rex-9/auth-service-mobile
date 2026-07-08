// lib/pages/signup_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/components/components.dart';
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
      appBar: AppBar(title: Text(Constants.locale.signupTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isGoogle
                    ? Constants.locale.googlePasscodeHeading.tr
                    : Constants.locale.createPasscodeHeading.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isGoogle
                    ? Constants.locale.googlePasscodeSubtitle.tr
                    : Constants.locale.createPasscodeSubtitle.tr,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              Text(
                Constants.locale.passcodeLabel.tr,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              AppPasscodeField(
                pinController: controller.signupPin,
                onChanged: (value) {
                  controller.passcode.value = value;
                  _syncConfirmError();
                },
              ),

              const SizedBox(height: 24),
              Text(
                Constants.locale.confirmPasscodeLabel.tr,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              AppPasscodeField(
                pinController: controller.signupConfirmPin,
                onChanged: (value) {
                  controller.confirmPasscode.value = value;
                  _syncConfirmError();
                },
              ),

              const SizedBox(height: 32),
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
