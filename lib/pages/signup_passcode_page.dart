// lib/pages/register_passcode_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';

class SignUpPasscodePage extends GetView<AuthController> {
  const SignUpPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pinController = PinInputController();
    final confirmPinController = PinInputController();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a passcode',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ll use this 6-digit passcode to sign in',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              const Text(
                'Passcode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              MaterialPinField(
                length: 6,
                pinController: pinController,
                onChanged: (value) {
                  controller.passcode.value = value;
                  if (value.length == 6 &&
                      confirmPinController.text.isNotEmpty) {
                    if (value != confirmPinController.text) {
                      confirmPinController.triggerError();
                    } else {
                      confirmPinController.clearError();
                    }
                  }
                },
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(56, 64),
                  spacing: 12,
                  borderRadius: BorderRadius.circular(12),
                  borderWidth: 1.5,
                  focusedBorderWidth: 2.0,
                  borderColor: Colors.grey,
                  focusedBorderColor: Colors.blue,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Confirm Passcode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              MaterialPinField(
                length: 6,
                pinController: confirmPinController,
                onChanged: (value) {
                  controller.confirmPasscode.value = value;
                  if (pinController.text.length == 6 && value.length == 6) {
                    if (pinController.text != value) {
                      confirmPinController.triggerError();
                    } else {
                      confirmPinController.clearError();
                    }
                  }
                },
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(56, 64),
                  spacing: 12,
                  borderRadius: BorderRadius.circular(12),
                  borderWidth: 1.5,
                  focusedBorderWidth: 2.0,
                  borderColor: Colors.grey,
                  focusedBorderColor: Colors.blue,
                  errorColor: Colors.red,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Obx(
                () => CustomButton(
                  text: controller.isLoading.value
                      ? 'Sending code...'
                      : 'Continue',
                  onPressed: () {
                    if (pinController.text.length != 6) {
                      pinController.triggerError();
                      Get.snackbar('Error', 'Please enter 6-digit passcode');
                      return;
                    }
                    if (pinController.text != confirmPinController.text) {
                      confirmPinController.triggerError();
                      Get.snackbar('Error', 'Passcodes do not match');
                      return;
                    }
                    Get.toNamed(
                      AppRoutes.signupInfo,
                      arguments: {
                        'email': controller.email.value,
                        'passcode': pinController.text,
                        'confirm_passcode': confirmPinController.text,
                      },
                    );
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
