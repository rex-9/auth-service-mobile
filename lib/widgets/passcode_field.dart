// lib/widgets/passcode_field.dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../design/app_colors.dart';

/// Shared 6-digit passcode field so every page uses the same pin styling
/// (theme-aware, replaces the per-page MaterialPinTheme copies).
class PasscodeField extends StatelessWidget {
  final PinInputController pinController;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;
  final bool enabled;

  const PasscodeField({
    super.key,
    required this.pinController,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MaterialPinField(
      length: 6,
      pinController: pinController,
      enabled: enabled,
      onChanged: onChanged,
      onCompleted: onCompleted,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: const Size(48, 56),
        spacing: 10,
        borderRadius: BorderRadius.circular(12),
        borderWidth: 1.5,
        focusedBorderWidth: 2.0,
        borderColor: isDark ? AppColors.borderDark : AppColors.border,
        focusedBorderColor: AppColors.primary,
        errorColor: AppColors.error,
        textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
    );
  }
}
