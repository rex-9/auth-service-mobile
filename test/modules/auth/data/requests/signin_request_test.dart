import 'package:flutter_test/flutter_test.dart';
import 'package:rexone_mobile/modules/auth/data/requests/signin.request.dart';

void main() {
  group('SignInRequest', () {
    test('toJson() maps fields correctly', () {
      final request = SignInRequest(
        signinKey: 'test@example.com',
        password: 'password123',
      );

      final json = request.toJson();

      expect(json, equals({
        'user': {
          'signin_key': 'test@example.com',
          'password': 'password123',
        }
      }));
    });
  });
}
