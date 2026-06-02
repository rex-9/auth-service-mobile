// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import '../design/design.dart';
import '../widgets/loading_indicator.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✨ Meritbox ✨', style: AppTypography.headline1),
            const SizedBox(height: AppSpacing.md),
            const Text('Loading...', style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            const LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
