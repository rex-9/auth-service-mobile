// lib/pages/forgot_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

/// Email a passcode reset link (mirrors the web ForgotPasswordDialog,
/// with the same 60s resend countdown).
class ForgotPasscodePage extends GetView<AuthController> {
  const ForgotPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: controller.email.value);

    return Scaffold(
      appBar: AppBar(title: Text(LocaleConstants.forgotPasscodeTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleConstants.forgotPasscodeSubtitle.tr,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            Obx(
              () => CustomTextField(
                label: LocaleConstants.emailLabel.tr,
                hint: LocaleConstants.emailHint.tr,
                error: controller.emailError.value,
                textController: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.email.value = value,
              ),
            ),

            const SizedBox(height: 32),
            Obx(() {
              final waiting = controller.resendSecondsLeft.value > 0;
              return CustomButton(
                text: waiting
                    ? LocaleConstants.resendCodeIn.trParams({
                        'seconds': '${controller.resendSecondsLeft.value}',
                      })
                    : controller.isLoading.value
                    ? LocaleConstants.sending.tr
                    : LocaleConstants.sendResetLink.tr,
                onPressed: () {
                  if (waiting || controller.isLoading.value) return;
                  controller.forgotPassword();
                },
              );
            }),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(LocaleConstants.backToSignIn.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
