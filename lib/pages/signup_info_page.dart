// lib/pages/signup_info_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/components/components.dart';
import 'package:meritbox_mobile/design/design.dart';
import '../controllers/auth_controller.dart';

class SignUpInfoPage extends GetView<AuthController> {
  const SignUpInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;

    controller.email.value = arguments['email'];
    controller.passcode.value = arguments['passcode'];
    controller.confirmPasscode.value =
        arguments['confirm_passcode'] ?? arguments['passcode'];

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.textPrimary,
        elevation: 0,
        title: Text(
          Constants.locale.signupInfoTitle.tr,
          style: context.typo.headline4,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Design.spacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Constants.locale.signupInfoHeading.tr,
              style: context.typo.headline3,
            ),
            SizedBox(height: Design.spacing.xxxl),

            AppInputField(
              label: Constants.locale.fullNameLabel.tr,
              hint: Constants.locale.fullNameHint.tr,
              onChanged: (value) => controller.fullName.value = value,
            ),
            SizedBox(height: Design.spacing.lg),

            AppInputField(
              label: Constants.locale.usernameLabel.tr,
              hint: Constants.locale.usernameHint.tr,
              onChanged: (value) =>
                  controller.username.value = value.toLowerCase().trim(),
            ),

            SizedBox(height: Design.spacing.xxxl),
            Obx(
              () => AppButton(
                text: controller.isLoading.value
                    ? Constants.locale.creatingAccount.tr
                    : Constants.locale.createAccountButton.tr,
                onPressed: () => controller.signUp(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
