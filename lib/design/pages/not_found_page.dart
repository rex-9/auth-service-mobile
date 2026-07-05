import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../locales/app_locales.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

/// Mirrors web `src/design/pages/NotFoundPage.tsx`.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '404 — Page not found',
                style: TextStyle(fontSize: 18, color: AppColors.navy900),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: AppLocales.goBack,
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.client.public.root),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
