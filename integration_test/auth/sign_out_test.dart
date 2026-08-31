import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';
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

  group('Authentication > Sign out', () {
    testWidgets('signs out an authenticated user and returns to landing', (tester) async {
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

      // Enter Passcode
      final pinFinder = find.byType(EditableText);
      expect(pinFinder, findsWidgets);
      await tester.enterText(pinFinder.first, TestUsers.existing.password);

      // Wait for HomePage
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(HomePage).evaluate().isNotEmpty) break;
      }
      expect(find.byType(HomePage), findsOneWidget);

      // Tap settings action icon in appBar
      final settingsIcon = find.byIcon(Design.icons.settings);
      expect(settingsIcon, findsOneWidget);
      await tester.tap(settingsIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Scroll to and tap Sign Out tile
      final signOutText = AppLocales.common.signOut.tr;
      final signOutTile = find.text(signOutText).first;
      await tester.scrollUntilVisible(
        signOutTile,
        50.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(signOutTile);
      await tester.pumpAndSettle();
      await tester.tap(signOutTile);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Confirm sign out in dialog
      final dialogConfirmButton = find.widgetWithText(AppButton, signOutText);
      if (dialogConfirmButton.evaluate().isNotEmpty) {
        await tester.tap(dialogConfirmButton.last);
      } else {
        final anyConfirm = find.text(signOutText);
        await tester.tap(anyConfirm.last);
      }
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify returned to Auth screen
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(TextField).evaluate().isNotEmpty) break;
      }
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
