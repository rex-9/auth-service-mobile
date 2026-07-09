// lib/pages/auth_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/design.dart';
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
    final settingsController = Get.find<SettingsController>();
    return AppPage(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => IconButton(
                icon: Icon(settingsController.themeIcon),
                tooltip: settingsController.themeLabel,
                onPressed: settingsController.toggleTheme,
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Design.icons.language),
              onSelected: settingsController.changeLocale,
              itemBuilder: (context) => settingsController.supportedLocales
                  .map(
                    (entry) => PopupMenuItem<String>(
                      value: entry.key,
                      child: Obx(
                        () => Row(
                          children: [
                            if (settingsController.isLocale(entry.key))
                              Icon(
                                Design.icons.check,
                                size: Design.spacing.iconSmall,
                              )
                            else
                              SizedBox(width: Design.spacing.iconSmall),
                            SizedBox(width: Design.spacing.sm),
                            Text(entry.value),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Constants.locale.welcomeTitle.tr,
                  style: context.typo.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Design.spacing.md),
                Text(
                  Constants.locale.welcomeSubtitle.tr,
                  style: context.typo.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Design.spacing.xxxl),
                Obx(
                  () => AppButton(
                    text: Constants.locale.continueWithGoogle.tr,
                    onPressed: () => controller.signInWithGoogle(),
                    isLoading: controller.isLoading.value,
                    type: ButtonType.google,
                  ),
                ),
                SizedBox(height: Design.spacing.xl),
                Row(
                  children: [
                    Expanded(child: Divider(color: context.colors.divider)),
                    Padding(
                      padding: Design.spacing.paddingSymmetric(
                        h: Design.spacing.lg,
                      ),
                      child: Text(
                        Constants.locale.or.tr,
                        style: context.typo.bodyMedium,
                      ),
                    ),
                    Expanded(child: Divider(color: context.colors.divider)),
                  ],
                ),
                SizedBox(height: Design.spacing.xl),
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
    );
  }
}
