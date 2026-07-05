import 'package:flutter/material.dart';

import '../atoms/atoms.dart';

/// Mirrors web `src/design/molecules/TextLink.tsx`.
class TextLink extends StatelessWidget {
  const TextLink({
    super.key,
    required this.label,
    this.onTap,
    this.disabled = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: disabled
                ? AppColors.gold600.withValues(alpha: 0.5)
                : AppColors.gold600,
          ),
        ),
      ),
    );
  }
}
