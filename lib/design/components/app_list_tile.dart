// lib/design/components/app_list_tile.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../design.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.isDestructive = false,
    this.contentPadding,
  });

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool isDestructive;
  final EdgeInsetsGeometry? contentPadding;

  static bool get isIOS => GetPlatform.isIOS;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;

    return osListTile(
      leading: leading,
      title: DefaultTextStyle(
        style: isDestructive
            ? typo.bodyLarge.copyWith(color: colors.error)
            : typo.bodyLarge,
        child: title,
      ),
      subtitle: subtitle != null
          ? DefaultTextStyle(style: typo.bodyMedium, child: subtitle!)
          : null,
      trailing: trailing,
      onTap: onTap,
      backgroundColor: backgroundColor ?? colors.surface,
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: Design.spacing.lg,
            vertical: Design.spacing.sm,
          ),
      isDestructive: isDestructive,
    );
  }

  static Widget osListTile({
    required Widget leading,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    bool isDestructive = false,
  }) {
    if (isIOS) {
      return CupertinoListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        backgroundColor: backgroundColor ?? Get.theme.colorScheme.surface,
        padding: contentPadding ?? EdgeInsets.zero,
      );
    }
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      tileColor: backgroundColor,
      contentPadding:
          contentPadding ??
           EdgeInsets.symmetric(horizontal: Design.spacing.lg, vertical: Design.spacing.sm),
      visualDensity: VisualDensity.compact,
    );
  }
}
