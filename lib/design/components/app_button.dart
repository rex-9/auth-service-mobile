// lib/design/components/button.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isExpanded = false,
    this.text,
    this.icon,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isExpanded;
  final String? text;
  final IconData? icon;
  final String? tooltip;

  static bool get isIOS => GetPlatform.isIOS;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton(context);

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildButton(BuildContext context) {
    final child = _buildContent(context);

    switch (type) {
      case ButtonType.primary:
        return osElevatedButton(onPressed: onPressed, child: child);

      case ButtonType.secondary:
        return osOutlinedButton(onPressed: onPressed, child: child);

      case ButtonType.text:
        return osTextButton(onPressed: onPressed, child: child);

      case ButtonType.icon:
        return osIconButton(
          onPressed: onPressed,
          icon: icon!,
          tooltip: tooltip,
        );

      case ButtonType.google:
        return osGoogleButton(onPressed: onPressed, child: child);
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

  static Widget osElevatedButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: Get.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
        padding: EdgeInsets.symmetric(
          horizontal: Design.spacing.xl,
          vertical: Design.spacing.md,
        ),
        child: DefaultTextStyle(
          style: Design.typo.button.copyWith(color: Colors.white),
          child: child,
        ),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: Design.styles.buttonPrimary,
      child: child,
    );
  }

  static Widget osOutlinedButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          border: Border.all(color: Get.theme.colorScheme.primary),
        ),
        child: CupertinoButton(
          onPressed: onPressed,
          padding: EdgeInsets.symmetric(
            horizontal: Design.spacing.xl,
            vertical: Design.spacing.md,
          ),
          child: DefaultTextStyle(
            style: Design.typo.button.copyWith(
              color: Get.theme.colorScheme.primary,
            ),
            child: child,
          ),
        ),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: Design.styles.buttonSecondary,
      child: child,
    );
  }

  static Widget osTextButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(
          horizontal: Design.spacing.sm,
          vertical: Design.spacing.sm,
        ),
        child: DefaultTextStyle(
          style: Design.typo.labelLarge.copyWith(
            color: Get.theme.colorScheme.primary,
          ),
          child: child,
        ),
      );
    }
    return TextButton(
      onPressed: onPressed,
      style: Design.styles.buttonText,
      child: child,
    );
  }

  static Widget osIconButton({
    required VoidCallback? onPressed,
    required IconData icon,
    String? tooltip,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Icon(icon, color: Get.theme.colorScheme.onSurface),
      );
    }
    return IconButton(onPressed: onPressed, icon: Icon(icon), tooltip: tooltip);
  }

  static Widget osGoogleButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (isIOS) {
      return Container(
        height: Design.spacing.buttonHeight,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          border: Border.all(color: Get.theme.colorScheme.outline),
        ),
        child: CupertinoButton(
          onPressed: onPressed,
          padding: EdgeInsets.symmetric(
            horizontal: Design.spacing.xl,
            vertical: Design.spacing.md,
          ),
          child: child,
        ),
      );
    }
    return SizedBox(
      height: Design.spacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: Design.styles.buttonGoogle,
        child: child,
      ),
    );
  }
}

// ===== ENUMS =====

enum ButtonType { primary, secondary, text, icon, google }
