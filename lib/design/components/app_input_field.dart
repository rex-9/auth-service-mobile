// lib/design/components/app_input_field.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.error,
    this.helper,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.autoFocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final String hint;
  final Function(String) onChanged;
  final String? error;
  final String? helper;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool autoFocus;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final TextCapitalization textCapitalization;

  static bool get isIOS => GetPlatform.isIOS;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.typo.labelMedium),
        SizedBox(height: Design.spacing.xs),
        osTextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autoFocus,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
          textCapitalization: textCapitalization,
          hint: hint,
          error: error,
          helper: helper,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }

  static Widget osTextField({
    TextEditingController? controller,
    FocusNode? focusNode,
    bool autofocus = false,
    bool obscureText = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
    int? minLines,
    bool enabled = true,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? hint,
    String? error,
    String? helper,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    if (isIOS) {
      return CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        minLines: minLines,
        enabled: enabled,
        placeholder: hint,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: error != null
                ? CupertinoColors.systemRed
                : CupertinoColors.systemGrey4,
          ),
        ),
      );
    }
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      textCapitalization: textCapitalization,
      decoration: Design.styles.input(
        hint: hint,
        error: error,
        helper: helper,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
