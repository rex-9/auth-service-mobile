import 'package:flutter/material.dart';

import '../../atoms/atoms.dart';
import '../alert_message.dart';
import '../app_button.dart';
import '../passcode_boxes_input.dart';
import '../text_link.dart';

/// Mirrors web `src/design/molecules/auth/SignupPasscodeConfirmDialog.tsx`.
class SignupPasscodeConfirmDialog extends StatelessWidget {
  const SignupPasscodeConfirmDialog({
    super.key,
    required this.email,
    required this.passcodeConfirmation,
    required this.passcodeError,
    required this.isLoading,
    required this.error,
    required this.onPasscodeConfirmationChange,
    required this.onSubmit,
    required this.onUseDifferentEmail,
    required this.onForgotPasscode,
  });

  final String email;
  final String passcodeConfirmation;
  final String passcodeError;
  final bool isLoading;
  final String error;
  final ValueChanged<String> onPasscodeConfirmationChange;
  final VoidCallback onSubmit;
  final VoidCallback onUseDifferentEmail;
  final VoidCallback onForgotPasscode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          email.isNotEmpty
              ? TextSpan(
                  text: 'Confirm your passcode for ',
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              : const TextSpan(text: 'Confirm your passcode'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: AppColors.navy900),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter the same 6 digits again',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.navy900.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        PasscodeBoxesInput(
          value: passcodeConfirmation,
          onChanged: onPasscodeConfirmationChange,
          label: 'Confirm Passcode',
          helperText: 'Enter the same 6 digits again',
          errorText: passcodeError,
          disabled: isLoading,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: isLoading ? 'Checking passcode...' : 'Continue',
          fullWidth: true,
          disabled: isLoading || passcodeConfirmation.length != 6,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextLink(
            label: 'Use a different email',
            onTap: onUseDifferentEmail,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextLink(
            label: 'Forgot your passcode?',
            onTap: onForgotPasscode,
          ),
        ),
        if (error.isNotEmpty) ...[
          const SizedBox(height: 12),
          AlertMessage(message: error, type: AlertType.error),
        ],
      ],
    );
  }
}
