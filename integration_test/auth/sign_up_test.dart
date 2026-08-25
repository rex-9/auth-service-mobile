import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rexone_mobile/main.dart' as app;
import 'package:rexone_mobile/modules/auth/pages/confirm_email.page.dart';
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

  group('Authentication > Sign up', () {
    testWidgets('allows a new user to register with email', (tester) async {
      final newUser = TestUsers.generate(prefix: 'signup');
      app.main();

      // Wait for app to boot and navigate past splash to Auth screen
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(TextField).evaluate().isNotEmpty) break;
      }

      // 1. Initial email entry
      final emailFinder = find.byType(TextField);
      expect(emailFinder, findsOneWidget);
      await tester.enterText(emailFinder, newUser.email);
      await tester.pumpAndSettle();

      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
      } else {
        await tester.tap(find.text('Continue'));
      }
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 2. Create Passcode
      final pinFinder = find.byType(EditableText);
      expect(pinFinder, findsWidgets);
      await tester.enterText(pinFinder.first, newUser.password);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final nextButton = find.widgetWithText(ElevatedButton, 'Continue');
      if (nextButton.evaluate().isNotEmpty) {
        await tester.tap(nextButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }

      // 3. Confirm Passcode
      final confirmPinFinder = find.byType(EditableText);
      if (confirmPinFinder.evaluate().isNotEmpty) {
        await tester.enterText(confirmPinFinder.first, newUser.password);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final confirmButton = find.widgetWithText(ElevatedButton, 'Continue');
        if (confirmButton.evaluate().isNotEmpty) {
          await tester.tap(confirmButton);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      }

      // 4. Sign Up Info (Full Name + Username)
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length >= 2) {
        await tester.enterText(textFields.at(0), newUser.name);
        await tester.enterText(textFields.at(1), newUser.username);
        await tester.pumpAndSettle();

        final createAccountButton = find.widgetWithText(ElevatedButton, 'Create Account');
        if (createAccountButton.evaluate().isNotEmpty) {
          await tester.tap(createAccountButton);
        } else {
          await tester.tap(find.text('Create Account'));
        }
      }

      // 5. Verify reaches ConfirmEmailPage
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(ConfirmEmailPage).evaluate().isNotEmpty) break;
      }

      expect(find.byType(ConfirmEmailPage), findsOneWidget);
    });
  });
}
