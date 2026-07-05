import 'package:flutter/material.dart';

import '../atoms/atoms.dart';

/// Mirrors web `src/design/molecules/AlertMessage.tsx`.
enum AlertType { info, success, warning, error }

class AlertMessage extends StatelessWidget {
  const AlertMessage({
    super.key,
    required this.message,
    required this.type,
  });

  final String message;
  final AlertType type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      AlertType.info => AppColors.info,
      AlertType.success => AppColors.success,
      AlertType.warning => AppColors.warning,
      AlertType.error => AppColors.error,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: color),
      ),
    );
  }
}
