import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contexts/contexts.dart';

/// Mirrors web `src/design/molecules/LoadingOverlay.tsx`.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<LoadingContext>().isLoading;

    if (!isLoading) return const SizedBox.shrink();

    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.5),
        child: const Center(
          child: Text(
            'Loading...',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
