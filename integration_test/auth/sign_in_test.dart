import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rexone_mobile/main.dart' as app;
import 'package:rexone_mobile/modules/auth/auth.dart';
import 'package:rexone_mobile/modules/home/pages/home.page.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/storage.service.dart';

import '../data/users.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUp(() async {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().authToken.value = '';
      Get.find<AuthController>().currentUser.value = null;
      Get.find<AuthController>().email.value = '';
      Get.find<AuthController>().password.value = '';
      Get.find<AuthController>().confirmPassword.value = '';
    }
    if (Get.isRegistered<StorageService>()) {
      Get.find<StorageService>().clearSession();
      Get.find<StorageService>().clearRouteStack();
    }
    if (Get.key.currentState != null) {
      Get.offAllNamed(AppRoutes.auth);
    }
  });

  group('Authentication > Sign in', () {
    testWidgets('allows an existing user to sign in with email', (
      tester,
    ) async {
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

      // Enter Password
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

      // Clean up session and navigate back to Auth
      if (Get.isRegistered<AuthController>()) {
        await Get.find<AuthController>().signOut();
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets(
      'redirects unconfirmed user directly to confirm email OTP when re-entering email',
      (tester) async {
        final unconfirmedUser = TestUsers.generate(prefix: 'unconf');

        // 1. Create unconfirmed user via backend API
        if (Get.isRegistered<AuthService>()) {
          await Get.find<AuthService>().signUp(
            SignUpRequest(
              email: unconfirmedUser.email,
              name: unconfirmedUser.name,
              username: unconfirmedUser.username,
              password: unconfirmedUser.password,
              passwordConfirmation: unconfirmedUser.password,
            ),
          );
        }

        // Navigate to Auth screen
        if (Get.key.currentState != null) {
          AppRoutes.toAuth();
          await tester.pumpAndSettle();
        } else {
          app.main();
        }

        // Wait for auth screen to be visible
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(milliseconds: 500));
          if (find.byType(TextField).evaluate().isNotEmpty) break;
        }

        final emailFinder = find.byType(TextField);
        expect(emailFinder, findsOneWidget);

        // 2. Enter unconfirmed user email
        await tester.enterText(emailFinder, unconfirmedUser.email);
        await tester.pumpAndSettle();

        // 3. Tap Continue
        final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
        if (continueButton.evaluate().isNotEmpty) {
          await tester.tap(continueButton);
        } else {
          await tester.tap(find.text('Continue'));
        }
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // 4. Verify lands directly on ConfirmEmailPage
        expect(find.byType(ConfirmEmailPage), findsOneWidget);

        // 5. Verify password signin and password creation screens are NOT displayed
        expect(find.byType(SignInPasswordPage), findsNothing);
        expect(find.byType(SignUpPasswordCreatePage), findsNothing);
      },
    );
  });
}
