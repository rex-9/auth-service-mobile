import 'package:flutter/material.dart';

import '../../atoms/atoms.dart';
import '../alert_message.dart';
import '../app_button.dart';
import '../app_input.dart';
import '../google_btn.dart';

/// Mirrors web `src/design/molecules/auth/InitialDialog.tsx`.
class InitialDialog extends StatelessWidget {
  const InitialDialog({
    super.key,
    required this.isLoading,
    required this.emailController,
    required this.emailError,
    required this.error,
    required this.onSubmit,
    required this.onGoogleSignIn,
  });

  final bool isLoading;
  final TextEditingController emailController;
  final String emailError;
  final String error;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoogleBtn(
          label: 'Continue with Google',
          isLoading: isLoading,
          onPressed: onGoogleSignIn,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.gray300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.navy900.withValues(alpha: 0.6),
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.gray300)),
          ],
        ),
        const SizedBox(height: 16),
        AppInput(
          controller: emailController,
          label: 'Email',
          hintText: 'your@email.com',
          helperText: 'Enter your email to sign in or create an account',
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: isLoading ? 'Checking...' : 'Continue',
          fullWidth: true,
          disabled: isLoading,
          onPressed: onSubmit,
        ),
        if (error.isNotEmpty) ...[
          const SizedBox(height: 12),
          AlertMessage(message: error, type: AlertType.error),
        ],
      ],
    );
  }
}
