import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rexone_mobile/main.dart' as app;
import 'package:rexone_mobile/services/storage.service.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUp(() async {
    if (Get.isRegistered<StorageService>()) {
      Get.find<StorageService>().clearSession();
      Get.find<StorageService>().clearRouteStack();
    }
  });

  group('Authentication > SSO', () {
    testWidgets('displays Google SSO button on auth screen', (tester) async {
      app.main();

      // Wait for app to boot and navigate past splash to Auth screen
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(TextField).evaluate().isNotEmpty) break;
      }

      // Wait for auth screen to load
      final emailFinder = find.byType(TextField);
      expect(emailFinder, findsOneWidget);

      // Verify Google SSO button exists
      final googleButton = find.text('Continue with Google');
      final altGoogleButton = find.text('Google');
      expect(
        googleButton.evaluate().isNotEmpty || altGoogleButton.evaluate().isNotEmpty,
        isTrue,
      );
    });
  });
}
