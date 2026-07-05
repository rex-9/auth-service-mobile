import 'package:flutter/material.dart';

import '../../atoms/atoms.dart';
import '../alert_message.dart';
import '../app_button.dart';
import '../passcode_boxes_input.dart';
import '../text_link.dart';

/// Mirrors web `src/design/molecules/auth/VerifyEmailDialog.tsx`.
class VerifyEmailDialog extends StatelessWidget {
  const VerifyEmailDialog({
    super.key,
    required this.email,
    required this.otp,
    required this.otpError,
    required this.message,
    required this.error,
    required this.isLoading,
    required this.resendCountdownActive,
    required this.resendCountdownSecondsLeft,
    required this.onOtpChange,
    required this.onSubmit,
    required this.onResendCode,
    required this.onUseDifferentEmail,
  });

  final String email;
  final String otp;
  final String otpError;
  final String message;
  final String error;
  final bool isLoading;
  final bool resendCountdownActive;
  final int resendCountdownSecondsLeft;
  final ValueChanged<String> onOtpChange;
  final VoidCallback onSubmit;
  final VoidCallback onResendCode;
  final VoidCallback onUseDifferentEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PasscodeBoxesInput(
          value: otp,
          onChanged: onOtpChange,
          label: 'Verification Code',
          errorText: otpError,
          helperText: 'Enter the 6-digit code sent to your email',
          disabled: isLoading,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: isLoading ? 'Verifying...' : 'Verify Email',
          fullWidth: true,
          disabled: isLoading || otp.length != 6,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 16),
        const Text(
          'Verify your email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.navy900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'We have sent a confirmation code to:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.navy900.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.navy900,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextLink(
            label: resendCountdownActive
                ? 'Resend code in ${resendCountdownSecondsLeft}s'
                : 'Did not receive the code? Resend',
            disabled: resendCountdownActive,
            onTap: resendCountdownActive ? null : onResendCode,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Check your inbox and enter the code to complete signup.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.navy900.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextLink(
            label: 'Use a different email',
            onTap: onUseDifferentEmail,
          ),
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 12),
          AlertMessage(message: message, type: AlertType.success),
        ],
        if (error.isNotEmpty) ...[
          const SizedBox(height: 12),
          AlertMessage(message: error, type: AlertType.error),
        ],
      ],
    );
  }
}
