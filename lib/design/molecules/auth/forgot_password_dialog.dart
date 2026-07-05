import 'package:flutter/material.dart';

import '../../atoms/atoms.dart';
import '../alert_message.dart';
import '../app_button.dart';
import '../app_input.dart';
import '../text_link.dart';

/// Mirrors web `src/design/molecules/auth/ForgotPasswordDialog.tsx`.
class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({
    super.key,
    required this.emailController,
    required this.message,
    required this.error,
    required this.isLoading,
    required this.resendCountdownActive,
    required this.resendCountdownSecondsLeft,
    required this.onSubmit,
    required this.onBackToSignin,
  });

  final TextEditingController emailController;
  final String message;
  final String error;
  final bool isLoading;
  final bool resendCountdownActive;
  final int resendCountdownSecondsLeft;
  final VoidCallback onSubmit;
  final VoidCallback onBackToSignin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter your email and we will send you a link to reset your passcode.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.navy900.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        AppInput(
          controller: emailController,
          label: 'Email',
          hintText: 'your@email.com',
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: resendCountdownActive
              ? 'Resend in ${resendCountdownSecondsLeft}s'
              : isLoading
                  ? 'Sending...'
                  : 'Send Passcode Reset Link',
          fullWidth: true,
          disabled: isLoading || resendCountdownActive,
          onPressed: onSubmit,
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 12),
          AlertMessage(message: message, type: AlertType.success),
        ],
        if (error.isNotEmpty) ...[
          const SizedBox(height: 12),
          AlertMessage(message: error, type: AlertType.error),
        ],
        const SizedBox(height: 12),
        Center(
          child: TextLink(label: 'Back to Sign In', onTap: onBackToSignin),
        ),
      ],
    );
  }
}
