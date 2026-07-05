import 'package:flutter/material.dart';

import '../../atoms/atoms.dart';
import '../alert_message.dart';
import '../app_button.dart';
import '../passcode_boxes_input.dart';
import '../text_link.dart';

/// Mirrors web `src/design/molecules/auth/SignupPasscodeCreateDialog.tsx`.
class SignupPasscodeCreateDialog extends StatelessWidget {
  const SignupPasscodeCreateDialog({
    super.key,
    required this.email,
    required this.passcode,
    required this.passcodeError,
    required this.isLoading,
    required this.error,
    required this.onPasscodeChange,
    required this.onSubmit,
    required this.onUseDifferentEmail,
    required this.onForgotPasscode,
  });

  final String email;
  final String passcode;
  final String passcodeError;
  final bool isLoading;
  final String error;
  final ValueChanged<String> onPasscodeChange;
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
                  text: 'Create a passcode for ',
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              : const TextSpan(text: 'Create your passcode'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: AppColors.navy900),
        ),
        const SizedBox(height: 4),
        Text(
          'You will use this 6-digit passcode to sign in',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.navy900.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        PasscodeBoxesInput(
          value: passcode,
          onChanged: onPasscodeChange,
          label: 'Create Passcode',
          helperText: 'Choose a 6-digit number you will remember',
          errorText: passcodeError,
          disabled: isLoading,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Continue',
          fullWidth: true,
          disabled: isLoading || passcode.length != 6,
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
