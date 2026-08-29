// lib/design/components/app_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    this.type = EButtonType.primary,
    this.isExpanded = false,
    this.text,
    this.icon,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final EButtonType type;
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
      case EButtonType.primary:
        return _InteractivePrimaryButton(onPressed: onPressed, child: child);

      case EButtonType.neon:
        return _InteractiveNeonButton(onPressed: onPressed, child: child);

      case EButtonType.secondary:
        return _InteractiveSecondaryButton(onPressed: onPressed, child: child);

      case EButtonType.tertiary:
      case EButtonType.text:
        return osTextButton(onPressed: onPressed, child: child);

      case EButtonType.icon:
        return osIconButton(
          onPressed: onPressed,
          icon: icon!,
          tooltip: tooltip,
        );

      case EButtonType.google:
        return osGoogleButton(onPressed: onPressed, child: child);
    }
  }

  Widget _buildContent(BuildContext context) {
    if (type == EButtonType.google) {
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

/// Interactive Primary Button with touch Press & Hold neon glow reaction
class _InteractivePrimaryButton extends StatefulWidget {
  const _InteractivePrimaryButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<_InteractivePrimaryButton> createState() =>
      _InteractivePrimaryButtonState();
}

class _InteractivePrimaryButtonState extends State<_InteractivePrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _isPressed ? Design.colors.primary : Design.colors.glass.tagBg,
          borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          border: Border.all(
            color: _isPressed
                ? Design.colors.primary
                : Design.colors.glass.border,
            width: 1,
          ),
          boxShadow: _isPressed
              ? Design.colors.shadows.neonLg
              : Design.colors.shadows.neon,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (highlighted) {
              setState(() => _isPressed = highlighted);
            },
            borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Design.spacing.xl,
                vertical: Design.spacing.md,
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: Design.typo.button.copyWith(
                    color: _isPressed ? Colors.white : Design.colors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Interactive Neon Button with touch Press & Hold animated glow reaction
class _InteractiveNeonButton extends StatefulWidget {
  const _InteractiveNeonButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<_InteractiveNeonButton> createState() => _InteractiveNeonButtonState();
}

class _InteractiveNeonButtonState extends State<_InteractiveNeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _isPressed ? Design.colors.primary : Design.colors.glass.card,
          borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          border: Border.all(
            color: _isPressed
                ? Design.colors.primary
                : Design.colors.glass.border,
            width: 1,
          ),
          boxShadow: _isPressed
              ? Design.colors.shadows.neonLg
              : Design.colors.shadows.neon,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (highlighted) {
              setState(() => _isPressed = highlighted);
            },
            borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Design.spacing.xl,
                vertical: Design.spacing.md,
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: Design.typo.button.copyWith(
                    color: Design.colors.glowWhite,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(color: Design.colors.glowWhite, blurRadius: 6),
                      Shadow(color: Design.colors.primary, blurRadius: 12),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Interactive Secondary Button with touch Press & Hold feedback
class _InteractiveSecondaryButton extends StatefulWidget {
  const _InteractiveSecondaryButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<_InteractiveSecondaryButton> createState() =>
      _InteractiveSecondaryButtonState();
}

class _InteractiveSecondaryButtonState
    extends State<_InteractiveSecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _isPressed
              ? Design.colors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
          border: Border.all(
            color: Design.colors.primary,
            width: 1.5,
          ),
          boxShadow: _isPressed ? Design.colors.shadows.neon : const [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (highlighted) {
              setState(() => _isPressed = highlighted);
            },
            borderRadius: BorderRadius.circular(Design.spacing.radiusMedium),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Design.spacing.xl,
                vertical: Design.spacing.md,
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: Design.typo.button.copyWith(
                    color: Design.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
