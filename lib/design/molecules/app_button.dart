import 'package:flutter/material.dart';

import '../atoms/atoms.dart';

/// Mirrors web `src/design/molecules/Button.tsx`.
enum AppButtonVariant { primary, secondary, tertiary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
    this.disabled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool fullWidth;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = disabled ? null : onPressed;

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.gold500,
            foregroundColor: AppColors.navy900,
            disabledBackgroundColor: AppColors.gold500.withValues(alpha: 0.25),
            disabledForegroundColor: AppColors.navy900.withValues(alpha: 0.4),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Text(label),
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gold600,
            side: const BorderSide(color: AppColors.gold500, width: 1.5),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(label),
        ),
      AppButtonVariant.tertiary => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.navy900,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          child: Text(label),
        ),
    };

    return fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
