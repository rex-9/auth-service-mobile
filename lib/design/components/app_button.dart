// lib/design/components/button.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/components/app_loading.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isExpanded;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton(context);

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildButton(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            height: Design.spacing.iconMedium,
            width: Design.spacing.iconMedium,
            child: AppLoading(strokeWidth: 2, color: _getLoaderColor()),
          )
        : _buildContent(context);

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: Design.styles.buttonPrimary,
          child: child,
        );

      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: Design.styles.buttonSecondary,
          child: child,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: Design.styles.buttonText,
          child: child,
        );

      case ButtonType.google:
        return SizedBox(
          height: Design.spacing.buttonHeight,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: Design.styles.buttonGoogle,
            child: child,
          ),
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    if (type == ButtonType.google) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Design.media.googleLogo,
            height: Design.spacing.iconMedium,
            width: Design.spacing.iconMedium,
          ),
          SizedBox(width: Design.spacing.sm),
          Text(text, style: Design.typography.bodyMedium),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: Design.spacing.sm),
          Text(text, style: Design.typography.button),
        ],
      );
    }

    return Text(text, style: Design.typography.button);
  }

  Color _getLoaderColor() {
    switch (type) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
      case ButtonType.text:
      case ButtonType.google:
        return Design.colors.primary; // Fixed: was Colors.red
    }
  }
}

// ===== ENUMS =====

enum ButtonType { primary, secondary, text, google }
