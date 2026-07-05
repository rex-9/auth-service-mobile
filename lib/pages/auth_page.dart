// lib/pages/auth_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../design/app_spacing.dart';
import '../design/app_typography.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/settings_actions.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  Future<void> _onContinue() async {
    if (!controller.validateEmail()) return;

    final peekedUserStatus = await controller.peekUser(controller.email.value);

    switch (peekedUserStatus) {
      case PeekedUserStatus.error:
        // Show error, stay on same page
        Get.snackbar('error'.tr, 'connection_failed'.tr);
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
                      'welcome_title'.tr,
                      style: AppTypography.headline1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'welcome_subtitle'.tr,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    Obx(
                      () => CustomButton(
                        text: 'continue_with_google'.tr,
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
                          child: Text('or'.tr),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => CustomTextField(
                        label: 'email_label'.tr,
                        hint: 'email_hint'.tr,
                        helper: 'email_helper'.tr,
                        error: controller.emailError.value,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => controller.email.value = value,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => CustomButton(
                        text: controller.isLoading.value
                            ? 'checking'.tr
                            : 'continue_button'.tr,
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
