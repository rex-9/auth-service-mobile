// lib/design/components/app_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../design.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final VoidCallback? onTap;

  static bool get isIOS => GetPlatform.isIOS;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = borderRadius ?? Design.spacing.radiusMedium;

    final content = Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(Design.spacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? colors.border,
          width: 1.0,
        ),
        boxShadow: isIOS ? [] : Design.colors.shadows.sm,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
