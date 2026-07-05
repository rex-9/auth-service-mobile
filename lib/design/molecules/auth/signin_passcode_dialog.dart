import 'package:flutter/material.dart';

import '../../atoms/atoms.dart';
import '../alert_message.dart';
import '../app_button.dart';
import '../passcode_boxes_input.dart';
import '../text_link.dart';

/// Mirrors web `src/design/molecules/auth/SigninPasscodeDialog.tsx`.
enum SigninPasscodeMode { email, google }

class SigninPasscodeDialog extends StatelessWidget {
  const SigninPasscodeDialog({
    super.key,
    required this.email,
    this.mode = SigninPasscodeMode.email,
    required this.passcode,
    required this.passcodeError,
    required this.helperText,
    required this.isLoading,
    required this.isCooldownActive,
    required this.cooldownSecondsLeft,
    required this.shouldShowAttempts,
    required this.attemptsLabel,
    required this.error,
    required this.isSubmitDisabled,
    required this.onPasscodeChange,
    required this.onSubmit,
    required this.onUseDifferentEmail,
    required this.onForgotPassword,
  });

  final String email;
  final SigninPasscodeMode mode;
  final String passcode;
  final String passcodeError;
  final String helperText;
  final bool isLoading;
  final bool isCooldownActive;
  final int cooldownSecondsLeft;
  final bool shouldShowAttempts;
  final String attemptsLabel;
  final String error;
  final bool isSubmitDisabled;
  final ValueChanged<String> onPasscodeChange;
  final VoidCallback onSubmit;
  final VoidCallback onUseDifferentEmail;
  final VoidCallback onForgotPassword;

  bool get _isGoogleMode => mode == SigninPasscodeMode.google;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          _isGoogleMode
              ? const TextSpan(
                  text: 'Enter your passcode to continue with Google')
              : TextSpan(
                  text: 'Sign in to ',
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: AppColors.navy900),
        ),
        const SizedBox(height: 16),
        PasscodeBoxesInput(
          value: passcode,
          onChanged: (value) {
            if (isCooldownActive) return;
            onPasscodeChange(value);
          },
          label: '6-Digit Passcode',
          errorText: passcodeError,
          helperText: helperText,
          disabled: isLoading || isCooldownActive,
        ),
        if (shouldShowAttempts) ...[
          const SizedBox(height: 12),
          Text(
            attemptsLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.navy900.withValues(alpha: 0.7),
            ),
          ),
        ],
        if (isCooldownActive) ...[
          const SizedBox(height: 12),
          AlertMessage(
            type: AlertType.warning,
            message: _isGoogleMode
                ? 'Too many attempts. Please wait $cooldownSecondsLeft seconds.'
                : 'Too many incorrect passcode attempts. Please wait $cooldownSecondsLeft seconds.',
          ),
        ],
        const SizedBox(height: 16),
        AppButton(
          label: isCooldownActive
              ? 'Try again in ${cooldownSecondsLeft}s'
              : isLoading
                  ? (_isGoogleMode ? 'Verifying...' : 'Signing in...')
                  : 'Sign In',
          fullWidth: true,
          disabled: isSubmitDisabled,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextLink(
            label: _isGoogleMode
                ? 'Back to sign in options'
                : 'Use a different email',
            onTap: onUseDifferentEmail,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextLink(
            label: 'Forgot your passcode?',
            onTap: onForgotPassword,
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
