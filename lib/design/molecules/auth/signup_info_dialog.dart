import 'package:flutter/material.dart';

import '../../atoms/atoms.dart';
import '../alert_message.dart';
import '../app_button.dart';
import '../app_input.dart';

/// Mirrors web `src/design/molecules/auth/SignupInfoDialog.tsx`.
class SignupInfoDialog extends StatelessWidget {
  const SignupInfoDialog({
    super.key,
    required this.fullNameController,
    required this.usernameController,
    required this.isLoading,
    required this.error,
    required this.onUsernameChanged,
    required this.onSubmit,
  });

  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final bool isLoading;
  final String error;
  final ValueChanged<String> onUsernameChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Almost done! Tell us a bit about yourself',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: AppColors.navy900),
        ),
        const SizedBox(height: 16),
        AppInput(
          controller: fullNameController,
          label: 'Full Name',
          hintText: 'John Doe',
          helperText: 'Your real name (visible to others)',
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        AppInput(
          controller: usernameController,
          label: 'Username',
          hintText: 'john_doe',
          helperText: 'Unique identifier (letters, numbers, underscores only)',
          enabled: !isLoading,
          onChanged: onUsernameChanged,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: isLoading ? 'Creating account...' : 'Create Account',
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
