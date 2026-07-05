import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contexts/contexts.dart';
import '../../locales/app_locales.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

/// Mirrors web `src/design/pages/RootPage.tsx` + `LandingPage.tsx` — the
/// public entry point. The auth dialog opens over this page (the web
/// equivalent is `/?dialog=auth`).
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    // If the session was replaced by a newer sign in, reopen the auth
    // dialog with the message (mirrors the `session_message` URL param).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthContext>();
      final sessionMessage = auth.sessionMessage;
      if (sessionMessage != null && sessionMessage.isNotEmpty) {
        showAuthDialog(context, sessionMessage: sessionMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthContext>().isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Landing Page',
                style: TextStyle(fontSize: 16, color: AppColors.navy900),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 192,
                child: isAuthenticated
                    ? const SignOutBtn()
                    : AppButton(
                        label: AppLocales.signInButton,
                        fullWidth: true,
                        onPressed: () => showAuthDialog(context),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
