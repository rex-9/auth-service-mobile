// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:meritbox_mobile/design/extensions/theme_extensions.dart';
import '../design/design.dart';
import '../design/components/app_loading.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✨ Meritbox ✨', style: context.styles.headline1),
            SizedBox(height: Design.spacing.md),
            Text('Loading...', style: context.styles.bodyMedium),
            SizedBox(height: Design.spacing.lg),
            const AppLoading(),
          ],
        ),
      ),
    );
  }
}
