// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import '../design/design.dart';
import '../design/components/app_loading.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✨ Meritbox ✨', style: Design.typography.headline1),
            SizedBox(height: Design.spacing.md),
            Text('Loading...', style: Design.typography.bodyMedium),
            SizedBox(height: Design.spacing.lg),
            const AppLoading(),
          ],
        ),
      ),
    );
  }
}
