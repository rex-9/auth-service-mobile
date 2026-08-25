import 'package:flutter_test/flutter_test.dart';
import 'package:rexone_mobile/modules/auth/data/requests/google_signin_complete.request.dart';

void main() {
  group('GoogleSignInCompleteRequest', () {
    test('toJson() maps fields correctly', () {
      final request = GoogleSignInCompleteRequest(
        password: 'pass123',
        challengeToken: 'token123',
      );

      final json = request.toJson();

      expect(json, equals({
        'password': 'pass123',
        'challenge_token': 'token123',
      }));
    });
  });
}
