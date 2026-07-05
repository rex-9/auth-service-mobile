// lib/pages/forgot_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

/// Email a passcode reset link (mirrors the web ForgotPasswordDialog,
/// with the same 60s resend countdown).
class ForgotPasscodePage extends GetView<AuthController> {
  const ForgotPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(
      text: controller.email.value,
    );

    return Scaffold(
      appBar: AppBar(title: Text('forgot_passcode_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'forgot_passcode_subtitle'.tr,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            Obx(
              () => CustomTextField(
                label: 'email_label'.tr,
                hint: 'email_hint'.tr,
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
                    ? 'resend_code_in'.trParams({
                        'seconds': '${controller.resendSecondsLeft.value}',
                      })
                    : controller.isLoading.value
                    ? 'sending'.tr
                    : 'send_reset_link'.tr,
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
                child: Text('back_to_sign_in'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
