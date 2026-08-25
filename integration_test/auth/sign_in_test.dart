import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rexone_mobile/main.dart' as app;
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

  group('Authentication > Sign in', () {
    testWidgets('allows an existing user to sign in with email', (tester) async {
      app.main();

      // Wait for app to boot and navigate past splash to Auth screen
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(TextField).evaluate().isNotEmpty) break;
      }

      final emailFinder = find.byType(TextField);
      expect(emailFinder, findsOneWidget);

      // Enter email
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

      // Enter Passcode
      final pinFinder = find.byType(EditableText);
      expect(pinFinder, findsWidgets);
      await tester.enterText(pinFinder.first, TestUsers.existing.password);
      
      // Wait for auth completion and navigation to HomePage
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(HomePage).evaluate().isNotEmpty) break;
      }

      // Verify HomePage is displayed
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
