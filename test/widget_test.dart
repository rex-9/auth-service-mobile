// Auth flow widget smoke tests.
//
// These cover the client-side flow without a backend: landing page,
// opening the auth dialog, email validation, and the passcode input.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:auth_service_mobile/app.dart';
import 'package:auth_service_mobile/contexts/contexts.dart';
import 'package:auth_service_mobile/design/molecules/molecules.dart';
import 'package:auth_service_mobile/services/services.dart';

Future<StorageService> buildTestStorage() async {
  SharedPreferences.setMockInitialValues({});
  return StorageService.init();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows the landing page with a Sign In button', (tester) async {
    final storage = await buildTestStorage();
    await tester.pumpWidget(App(storage: storage));

    expect(find.text('Landing Page'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('opens the auth dialog on Sign In tap', (tester) async {
    final storage = await buildTestStorage();
    await tester.pumpWidget(App(storage: storage));

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Meritbox'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('rejects an invalid email on the initial step', (tester) async {
    final storage = await buildTestStorage();
    await tester.pumpWidget(App(storage: storage));

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'not-an-email');
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(
      find.text('Please enter a valid email address. (e.g. example@domain.com)'),
      findsOneWidget,
    );
  });

  testWidgets('signed-in users land on Home instead of the landing page',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'token': 'jwt-token',
      'user':
          '{"username":"john_doe","email":"john@example.com","provider":"email"}',
    });
    final storage = await StorageService.init();
    await tester.pumpWidget(App(storage: storage));
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome, john@example.com!'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('PasscodeBoxesInput renders six boxes and reports input',
      (tester) async {
    var value = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => PasscodeBoxesInput(
              value: value,
              onChanged: (next) => setState(() => value = next),
              label: '6-Digit Passcode',
            ),
          ),
        ),
      ),
    );

    expect(find.text('6-Digit Passcode'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();

    expect(value, '123456');
    for (final digit in ['1', '2', '3', '4', '5', '6']) {
      expect(find.text(digit), findsWidgets);
    }
  });

  testWidgets('AuthContext.signout clears persisted credentials',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'token': 'jwt-token',
      'user': '{"username":"john_doe","email":"john@example.com"}',
    });
    final storage = await StorageService.init();
    final auth = AuthContext(storage);

    expect(auth.isAuthenticated, isTrue);

    auth.signout();

    expect(auth.isAuthenticated, isFalse);
    expect(auth.currentUser, isNull);
    expect(storage.getString('token'), isNull);
  });
}
