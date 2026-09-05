// lib/design/components/app_password_field.dart
import 'package:flutter/material.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// A 6-digit password field with consistent styling across the app.
/// Strictly masked with asterisks (*) for enhanced security.
class AppPasswordField extends StatelessWidget {
  const AppPasswordField({
    super.key,
    required this.pinController,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
    this.obscureText = true,
    this.error,
  });

  final PinInputController pinController;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;
  final bool enabled;
  final bool obscureText;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MaterialPinField(
          length: 6,
          pinController: pinController,
          enabled: enabled,
          obscureText: obscureText,
          blinkWhenObscuring: false,
          onChanged: onChanged,
          onCompleted: onCompleted,
          theme: MaterialPinTheme(
            obscuringCharacter: '*',
            shape: MaterialPinShape.outlined,
            cellSize: const Size(48, 56),
            spacing: Design.spacing.sm,
            borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
            borderWidth: 1.5,
            focusedBorderWidth: 2.0,
            borderColor: context.colors.border,
            focusedBorderColor: context.colors.primary,
            fillColor: context.colors.surface,
            focusedFillColor: context.colors.surface,
            filledFillColor: context.colors.surface,
            cursorColor: context.colors.primary,
            errorColor: context.colors.error,
            textStyle: context.typo.headline3.copyWith(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            completeTextStyle: context.typo.headline3.copyWith(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            entryAnimation: MaterialPinAnimation.scale,
            animationDuration: Design.timers.short,
            errorAnimationDuration: Design.timers.medium,
            enableErrorShake: true,
          ),
        ),
        if (error != null) ...[
          SizedBox(height: Design.spacing.xs),
          Text(
            error!,
            style: context.typo.caption.copyWith(
              color: context.colors.error,
            ),
          ),
        ],
      ],
    );
  }
}
