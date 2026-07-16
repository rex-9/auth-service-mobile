// lib/design/components/button.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/design.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isExpanded = false,
    this.text,
    this.icon,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isExpanded;
  final String? text;
  final IconData? icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton(context);

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildButton(BuildContext context) {
    final child = isLoading ? AppLoading() : _buildContent(context);

    switch (type) {
      case ButtonType.primary:
        return AppPlatform.elevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );

      case ButtonType.secondary:
        return AppPlatform.outlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );

      case ButtonType.text:
        return AppPlatform.textButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );

      case ButtonType.icon:
        return AppPlatform.iconButton(
          onPressed: isLoading ? null : onPressed,
          icon: icon!,
          tooltip: tooltip,
        );

      case ButtonType.google:
        return AppPlatform.googleButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
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
          Text(
            text ?? Constants.locale.continueWithGoogle.tr,
            style: context.typo.bodyMedium,
          ),
        ],
      );
    }

    if (icon != null && text != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(width: Design.spacing.sm),
          Text(text!, style: context.typo.button),
        ],
      );
    }

    return Text(text ?? '', style: context.typo.button);
  }
}

// ===== ENUMS =====

enum ButtonType { primary, secondary, text, icon, google }
