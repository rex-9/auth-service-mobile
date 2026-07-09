// lib/pages/auth_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/components/components.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/pages/pages.dart';
import 'package:meritbox_mobile/models/models.dart';
import 'package:meritbox_mobile/routes/app_routes.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  Future<void> _onContinue() async {
    if (!controller.validateEmail()) return;

    final peekedUserStatus = await controller.peekUser(controller.email.value);

    switch (peekedUserStatus) {
      case PeekedUserStatus.error:
        AppSnackbar.error(Constants.locale.connectionFailed.tr);
        break;

      case PeekedUserStatus.exists:
        controller.passcode.value = '';
        controller.signinPin.clear();
        controller.loadRetryState();
        Get.toNamed(AppRoutes.signinPasscode);
        break;

      case PeekedUserStatus.notExists:
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
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Design.spacing.screenPadding),
          child: Column(
            children: [
              IconButton(
                icon: Icon(Design.icons.settings),
                onPressed: () => Get.to(() => const SettingsPage()),
                tooltip: 'Settings',
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome Title
                    Text(
                      Constants.locale.welcomeTitle.tr,
                      style: context.typo.headline1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Design.spacing.md),

                    // Welcome Subtitle
                    Text(
                      Constants.locale.welcomeSubtitle.tr,
                      style: context.typo.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Design.spacing.xxxl),

                    // Google Button
                    Obx(
                      () => AppButton(
                        text: Constants.locale.continueWithGoogle.tr,
                        onPressed: () => controller.signInWithGoogle(),
                        isLoading: controller.isLoading.value,
                        type: ButtonType.google,
                      ),
                    ),

                    SizedBox(height: Design.spacing.xl),

                    // OR Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Design.theme.colors.divider),
                        ),
                        Padding(
                          padding: Design.spacing.paddingSymmetric(
                            h: Design.spacing.lg,
                          ),
                          child: Text(
                            Constants.locale.or.tr,
                            style: context.typo.bodyMedium,
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Design.theme.colors.divider),
                        ),
                      ],
                    ),
                    SizedBox(height: Design.spacing.xl),

                    // Email Field
                    Obx(
                      () => AppInputField(
                        label: Constants.locale.emailLabel.tr,
                        hint: Constants.locale.emailHint.tr,
                        helper: Constants.locale.emailHelper.tr,
                        error: controller.emailError.value,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => controller.email.value = value,
                      ),
                    ),
                    SizedBox(height: Design.spacing.xl),

                    // Continue Button
                    Obx(
                      () => AppButton(
                        text: controller.isLoading.value
                            ? Constants.locale.checking.tr
                            : Constants.locale.continueButton.tr,
                        onPressed: _onContinue,
                        isLoading: controller.isLoading.value,
                        type: ButtonType.primary,
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
