// lib/design/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/design.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGoogle;
  final bool isLoading;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGoogle = false,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGoogle) {
      return SizedBox(
        width: double.infinity,
        height: Design.spacing.buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Design.colors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Design.media.googleLogo, height: 20, width: 20),
                    SizedBox(width: Design.spacing.sm),
                    Text(
                      text,
                      style: Design.typography.button.copyWith(
                        color: Design.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: Design.spacing.buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Design.colors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(text, style: Design.typography.button),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: Design.spacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Design.colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(text, style: Design.typography.button),
      ),
    );
  }
}
