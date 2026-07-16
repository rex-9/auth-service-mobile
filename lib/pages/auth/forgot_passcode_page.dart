// lib/pages/forgot_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/design.dart';

/// Email a passcode reset link (mirrors the web ForgotPasswordDialog,
/// with the same 60s resend countdown).
class ForgotPasscodePage extends GetView<AuthController> {
  const ForgotPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: controller.email.value);

    return AppPage(
      title: Constants.locale.forgotPasscodeTitle.tr,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Constants.locale.forgotPasscodeSubtitle.tr,
            style: context.typo.bodyMedium,
          ),
          SizedBox(height: Design.spacing.xxxl),

          Obx(
            () => AppInputField(
              label: Constants.locale.emailLabel.tr,
              hint: Constants.locale.emailHint.tr,
              error: controller.emailError.value,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => controller.email.value = value,
            ),
          ),

          SizedBox(height: Design.spacing.xxxl),
          Obx(() {
            final waiting = controller.resendSecondsLeft.value > 0;
            return AppButton(
              text: waiting
                  ? Constants.locale.resendCodeIn.trParams({
                      'seconds': '${controller.resendSecondsLeft.value}',
                    })
                  : controller.isLoading.value
                  ? Constants.locale.sending.tr
                  : Constants.locale.sendResetLink.tr,
              onPressed: () {
                if (waiting || controller.isLoading.value) return;
                controller.forgotPassword();
              },
            );
          }),

          SizedBox(height: Design.spacing.lg),
          Center(
            child: AppButton(
              type: ButtonType.text,
              onPressed: () => Get.back(),
              text: Constants.locale.backToSignIn.tr,
            ),
          ),
        ],
      ),
    );
  }
}
