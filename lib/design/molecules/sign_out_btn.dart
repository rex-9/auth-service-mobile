import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../app_routes.dart';
import '../../contexts/contexts.dart';
import '../../controllers/controllers.dart';
import '../../locales/app_locales.dart';
import 'app_button.dart';

/// Mirrors web `src/design/molecules/SignOutBtn.tsx` + `pages/auth/SignOut.tsx`.
class SignOutBtn extends StatelessWidget {
  const SignOutBtn({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final auth = context.read<AuthContext>();
    final navigator = Navigator.of(context);

    if (auth.token != null) {
      await authController.signOut();
    }

    if (auth.currentUser?.provider == 'google') {
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Local sign out still proceeds.
      }
    }

    auth.signout();
    navigator.pushNamedAndRemoveUntil(
      AppRoutes.client.public.root,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: AppLocales.signOutButton,
      variant: AppButtonVariant.secondary,
      onPressed: () => _handleSignOut(context),
    );
  }
}
