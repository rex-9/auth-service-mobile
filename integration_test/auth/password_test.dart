import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rexone_mobile/main.dart' as app;
import 'package:rexone_mobile/modules/auth/pages/signin_password.page.dart';
import 'package:rexone_mobile/modules/home/pages/home.page.dart';
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

  group('Authentication > Password', () {
    testWidgets('rejects incorrect password and remains on password step', (tester) async {
      app.main();

      // Wait for app to boot and navigate past splash to Auth screen
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(TextField).evaluate().isNotEmpty) break;
      }

      final emailFinder = find.byType(TextField);
      expect(emailFinder, findsOneWidget);

      await tester.enterText(emailFinder, TestUsers.existing.email);
      await tester.pumpAndSettle();

      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
      } else {
        await tester.tap(find.text('Continue'));
      }
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter wrong password
      final pinFinder = find.byType(EditableText);
      expect(pinFinder, findsWidgets);
      await tester.enterText(pinFinder.first, '000000');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify remains on SignInPasswordPage
      expect(find.byType(SignInPasswordPage), findsOneWidget);
    });

    testWidgets('accepts correct password and advances to home', (tester) async {
      app.main();

      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(TextField).evaluate().isNotEmpty) break;
      }

      final emailFinder = find.byType(TextField);
      expect(emailFinder, findsOneWidget);

      await tester.enterText(emailFinder, TestUsers.existing.email);
      await tester.pumpAndSettle();

      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
      } else {
        await tester.tap(find.text('Continue'));
      }
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final pinFinder = find.byType(EditableText);
      expect(pinFinder, findsWidgets);
      await tester.enterText(pinFinder.first, TestUsers.existing.password);

      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(HomePage).evaluate().isNotEmpty) break;
      }

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
