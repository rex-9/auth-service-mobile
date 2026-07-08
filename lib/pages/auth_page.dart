// lib/pages/auth_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/widgets/widgets.dart';
import '../controllers/auth_controller.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  Future<void> _onContinue() async {
    if (!controller.validateEmail()) return;

    final peekedUserStatus = await controller.peekUser(controller.email.value);

    switch (peekedUserStatus) {
      case PeekedUserStatus.error:
        // Show error, stay on same page
        AppSnackbar.error(Constants.locale.connectionFailed.tr);
        break;

      case PeekedUserStatus.exists:
        // User exists -> go to sign in with passcode
        controller.passcode.value = '';
        controller.signinPin.clear();
        controller.loadRetryState();
        Get.toNamed(AppRoutes.signinPasscode);
        break;

      case PeekedUserStatus.notExists:
        // New user -> go to create passcode
        controller.passcode.value = '';
        controller.confirmPasscode.value = '';
        controller.signupPin.clear();
        controller.signupConfirmPin.clear();
        Get.toNamed(AppRoutes.signupPasscode);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: settingsActions(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constants.locale.welcomeTitle.tr,
                      style: Design.typography.headline1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Design.spacing.md),
                    Text(
                      Constants.locale.welcomeSubtitle.tr,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    Obx(
                      () => CustomButton(
                        text: Constants.locale.continueWithGoogle.tr,
                        isLoading: controller.isLoading.value,
                        onPressed: () => controller.signInWithGoogle(),
                        isGoogle: true,
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(Constants.locale.or.tr),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => CustomTextField(
                        label: Constants.locale.emailLabel.tr,
                        hint: Constants.locale.emailHint.tr,
                        helper: Constants.locale.emailHelper.tr,
                        error: controller.emailError.value,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => controller.email.value = value,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => CustomButton(
                        text: controller.isLoading.value
                            ? Constants.locale.checking.tr
                            : Constants.locale.continueButton.tr,
                        onPressed: _onContinue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
