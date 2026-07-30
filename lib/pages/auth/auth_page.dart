// lib/pages/auth_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:auth_service_mobile/constants/constants.dart';
import 'package:auth_service_mobile/controllers/controllers.dart';
import 'package:auth_service_mobile/design/design.dart';
import 'package:auth_service_mobile/helpers/helpers.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  static bool get isIOS => GetPlatform.isIOS;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
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
            Padding(
              padding: EdgeInsets.only(top: isIOS ? 5.0 : 0.0),
              child: AppButton(
                type: ButtonTypeEnum.icon,
                icon: settingsController.themeIcon,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: isMobile ? double.infinity : 200.sp,
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
                    AppButton(
                      text: Constants.locale.continueWithGoogle.tr,
                      onPressed: controller.signInWithGoogle,
                      type: ButtonTypeEnum.google,
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
                    AppButton(
                      text: Constants.locale.continueButton.tr,
                      onPressed: controller.handleContinue,
                      type: ButtonTypeEnum.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
