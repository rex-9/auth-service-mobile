// lib/design/components/app_badge.dart
import 'package:flutter/material.dart';
import '../design.dart';

enum BadgeType { success, warning, error, info }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.text,
    this.type = BadgeType.info,
    this.icon,
  });

  final String text;
  final BadgeType type;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Color bg;
    Color fg;

    switch (type) {
      case BadgeType.success:
        bg = Design.colors.success.withValues(alpha: 0.15);
        fg = Design.colors.successDark;
        break;
      case BadgeType.warning:
        bg = Design.colors.warning.withValues(alpha: 0.15);
        fg = Design.colors.warningDark;
        break;
      case BadgeType.error:
        bg = Design.colors.error.withValues(alpha: 0.15);
        fg = Design.colors.errorDark;
        break;
      case BadgeType.info:
        bg = colors.primary.withValues(alpha: 0.15);
        fg = colors.primary;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Design.spacing.md,
        vertical: Design.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Design.spacing.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            SizedBox(width: Design.spacing.xs),
          ],
          Text(
            text,
            style: Design.typo.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
