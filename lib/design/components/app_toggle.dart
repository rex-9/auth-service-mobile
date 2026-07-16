// lib/design/components/app_toggle.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../design.dart';

class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.trackColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? trackColor;

  static bool get isIOS => GetPlatform.isIOS;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return osToggle(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? colors.primary,
      trackColor: trackColor ?? colors.border,
    );
  }

  static Widget osToggle({
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
    Color? trackColor,
  }) {
    if (isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeColor ?? CupertinoColors.systemBlue,
        inactiveTrackColor: trackColor ?? CupertinoColors.systemGrey4,
      );
    }
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeColor,
      activeTrackColor: activeColor,
      trackColor: trackColor != null
          ? WidgetStateProperty.all(trackColor)
          : null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
