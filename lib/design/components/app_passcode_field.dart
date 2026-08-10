// lib/design/components/passcode_field.dart
import 'package:flutter/material.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// A 6-digit passcode field with consistent styling across the app
class AppPasscodeField extends StatelessWidget {
  const AppPasscodeField({
    super.key,
    required this.pinController,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
    this.error,
  });

  final PinInputController pinController;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;
  final bool enabled;
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
          onChanged: onChanged,
          onCompleted: onCompleted,
          theme: MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: const Size(48, 56),
            spacing: Design.spacing.sm,
            borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
            borderWidth: 1.5,
            focusedBorderWidth: 2.0,
            borderColor: Design.theme.colors.border,
            focusedBorderColor: Design.theme.colors.primary,
            errorColor: Design.theme.colors.error,
            fillColor: Design.theme.colors.surface,
            textStyle: context.typo.headline3.copyWith(
              fontWeight: FontWeight.bold,
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
              color: Design.theme.colors.error,
            ),
          ),
        ],
      ],
    );
  }
}
