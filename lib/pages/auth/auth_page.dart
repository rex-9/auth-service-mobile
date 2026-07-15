// lib/pages/auth_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/helpers/helpers.dart';
import 'package:meritbox_mobile/models/enums.dart';
import 'package:meritbox_mobile/routes/app_routes.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  Future<void> _onContinue() async {
    if (!controller.validateEmail()) return;

    final status = await controller.peekUser(controller.email.value);

    switch (status) {
      case PeekedUserStatus.error:
        AppSnackbar.error(Constants.locale.connectionFailed.tr);
        break;

      case PeekedUserStatus.exists:
        // Fully onboarded user -> sign in with passcode
        controller.passcode.value = '';
        controller.signinPin.clear();
        controller.loadRetryState();
        Get.toNamed(AppRoutes.signinPasscode);
        break;

      case PeekedUserStatus.existsUnconfirmed:
        // User exists but incomplete onboarding -> resume from confirm email
        controller.passcode.value = '';
        controller.signupPin.clear();
        controller.signupConfirmPin.clear();
        controller.confirmPin.clear();
        // Send new confirmation code
        await controller.sendConfirmationCode();
        break;

      case PeekedUserStatus.notExists:
        // New user -> start sign up flow
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
    Widget buildFlagIcon(BuildContext context, {String? locale}) {
      final String code = locale ?? settingsController.localeCode.value;
      return Text(
        FlagHelper.getEmoji(code),
        style: TextStyle(fontSize: Design.spacing.iconLarge),
      );
    }

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
              icon: buildFlagIcon(context),
              onSelected: settingsController.changeLocale,
              itemBuilder: (context) => settingsController.supportedLocales
                  .map(
                    (entry) => PopupMenuItem<String>(
                      value: entry.key,
                      child: Obx(
                        () => Row(
                          children: [
                            buildFlagIcon(context, locale: entry.key),
                            SizedBox(width: Design.spacing.sm),
                            Text(entry.value),
                            if (settingsController.isLocale(entry.key))
                              Icon(
                                Design.icons.check,
                                size: Design.spacing.iconSmall,
                              ),
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
