import 'package:flutter/material.dart';

import '../atoms/atoms.dart';

/// Mirrors web `src/design/molecules/Dialog.tsx` — rounded panel over a
/// dimmed backdrop, with optional back button (left) and close button (right).
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.onClose,
    required this.child,
    this.onBack,
  });

  final VoidCallback onClose;
  final VoidCallback? onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgPrimary,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 448,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (onBack != null)
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.navy900,
                    )
                  else
                    const SizedBox(width: 48),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                    color: AppColors.navy900,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
