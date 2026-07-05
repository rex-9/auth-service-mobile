// lib/design/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../design/app_spacing.dart';
import '../design/app_typography.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String) onChanged;
  final String? error;
  final String? helper;
  final TextEditingController? textController;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.error,
    this.helper,
    this.textController,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: textController,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          // Border/fill styling comes from the theme's InputDecorationTheme,
          // so the field adapts to light and dark mode.
          decoration: InputDecoration(
            hintText: hint,
            errorText: error,
            helperText: helper,
            helperMaxLines: 2,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
