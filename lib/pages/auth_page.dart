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

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '✨ Welcome to Meritbox ✨',
                style: AppTypography.headline1,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Support dreams or make yours come true',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: 'Continue with Google',
                onPressed: () => controller.signInWithGoogle(),
                isGoogle: true,
              ),

              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Email',
                hint: 'your@email.com',
                onChanged: (value) => controller.email.value = value,
              ),
              const SizedBox(height: 20),

              Obx(
                () => CustomButton(
                  text: controller.isLoading.value ? 'Checking...' : 'Continue',
                  onPressed: () async {
                    if (controller.email.value.isEmpty) {
                      Get.snackbar('Error', 'Please enter your email');
                      return;
                    }

                    final peekedUserStatus = await controller.peekUser(
                      controller.email.value,
                    );

                    switch (peekedUserStatus) {
                      case PeekedUserStatus.error:
                        // Show error, stay on same page
                        Get.snackbar(
                          'Error',
                          'Connection failed. Please try again.',
                        );
                        break;

                      case PeekedUserStatus.exists:
                        // User exists -> go to sign in with passcode
                        Get.toNamed(AppRoutes.signinPasscode);
                        break;

                      case PeekedUserStatus.notExists:
                        // New user -> go to create passcode
                        Get.toNamed(AppRoutes.signupPasscode);
                        break;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
