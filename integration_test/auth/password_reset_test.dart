import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/main.dart' as app;
import 'package:rexone_mobile/modules/auth/pages/forgot_password.page.dart';
import 'package:rexone_mobile/services/storage.service.dart';

import '../data/users.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUp(() async {
    if (Get.isRegistered<StorageService>()) {
      Get.find<StorageService>().clearSession();
      Get.find<StorageService>().clearRouteStack();
    }
  });

  group('Authentication > Password reset', () {
    testWidgets('allows requesting a password reset link', (tester) async {
      app.main();

      // Wait for app to boot and navigate past splash to Auth screen
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(TextField).evaluate().isNotEmpty) break;
      }

      // Enter email
      final emailFinder = find.byType(TextField);
      expect(emailFinder, findsOneWidget);
      await tester.enterText(emailFinder, TestUsers.existing.email);
      await tester.pumpAndSettle();

      // Tap Continue
      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
      } else {
        await tester.tap(find.text('Continue'));
      }
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Scroll and Tap Forgot Password link
      final forgotText = AppLocales.auth.signInPasscode.forgotPasscodeLink.tr;
      final forgotButton = find.text(forgotText);
      if (forgotButton.evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          forgotButton,
          50.0,
          scrollable: find.byType(Scrollable).first,
        );
      }
      await tester.ensureVisible(forgotButton);
      await tester.pumpAndSettle();
      await tester.tap(forgotButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify ForgotPasswordPage is visible
      expect(find.byType(ForgotPasswordPage), findsOneWidget);

      // Tap Send Reset Link
      final sendResetText = AppLocales.auth.forgotPasscode.sendResetLink.tr;
      final sendButton = find.text(sendResetText);
      expect(sendButton, findsOneWidget);
      await tester.tap(sendButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });
}
