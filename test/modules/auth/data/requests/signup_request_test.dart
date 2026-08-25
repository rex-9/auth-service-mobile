import 'package:flutter_test/flutter_test.dart';
import 'package:rexone_mobile/modules/auth/data/requests/signup.request.dart';

void main() {
  group('SignUpRequest', () {
    test('toJson() includes name field under the user key', () {
      final request = SignUpRequest(
        username: 'johndoe',
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      final json = request.toJson();
      
      expect(json['user'], isNotNull);
      expect(json['user']['name'], equals('John Doe'));
    });

    test('toJson() produces exact expected structure with all fields', () {
      final request = SignUpRequest(
        username: 'johndoe',
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      final json = request.toJson();
      
      expect(json, equals({
        'user': {
          'username': 'johndoe',
          'name': 'John Doe',
          'email': 'john@example.com',
          'password': 'password123',
          'password_confirmation': 'password123',
        }
      }));
    });

    test('toJson() preserves whitespace in name', () {
      final request = SignUpRequest(
        username: 'johndoe',
        name: '  John Doe  ',
        email: 'john@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      final json = request.toJson();
      
      expect(json['user']['name'], equals('  John Doe  '));
    });

    test('All fields are mapped to correct JSON keys', () {
      final request = SignUpRequest(
        username: 'u',
        name: 'n',
        email: 'e',
        password: 'p',
        passwordConfirmation: 'pc',
      );

      final userJson = request.toJson()['user'] as Map<String, dynamic>;
      
      expect(userJson.containsKey('username'), isTrue);
      expect(userJson.containsKey('name'), isTrue);
      expect(userJson.containsKey('email'), isTrue);
      expect(userJson.containsKey('password'), isTrue);
      expect(userJson.containsKey('password_confirmation'), isTrue);
    });
  });
}
