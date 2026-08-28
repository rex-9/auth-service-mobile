// lib/design/components/app_handle_bar.dart
import 'package:flutter/material.dart';
import 'package:rexone_mobile/design/design.dart';

/// Reusable handle bar indicator for bottom sheets and drawer modals.
class AppHandleBar extends StatelessWidget {
  const AppHandleBar({
    super.key,
    this.width = 40.0,
    this.height = 4.0,
    this.color,
  });

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? context.colors.textSecondary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }
}
