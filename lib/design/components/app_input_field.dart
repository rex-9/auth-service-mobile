// lib/design/components/app_input_field.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/design/design.dart';

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
    final theme = Get.theme;
    if (isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
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
            placeholderStyle: Design.typo.helper.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            style: Design.typo.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Design.spacing.lg,
              vertical: Design.spacing.md + 2,
            ),
            prefix: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: Design.spacing.md),
                    child: prefixIcon,
                  )
                : null,
            suffix: suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: Design.spacing.md),
                    child: suffixIcon,
                  )
                : null,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
              border: Border.all(
                color: error != null
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
                width: error != null ? 1.5 : 1.0,
              ),
            ),
          ),
          if (error != null) ...[
            SizedBox(height: Design.spacing.xs),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Design.spacing.xs),
              child: Text(
                error,
                style: Design.typo.caption.copyWith(color: theme.colorScheme.error),
              ),
            ),
          ] else if (helper != null) ...[
            SizedBox(height: Design.spacing.xs),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Design.spacing.xs),
              child: Text(
                helper,
                style: Design.typo.caption.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ],
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
