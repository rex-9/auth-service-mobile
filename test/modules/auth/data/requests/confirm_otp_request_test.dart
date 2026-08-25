import 'package:flutter_test/flutter_test.dart';
import 'package:rexone_mobile/modules/auth/data/requests/confirm_otp.request.dart';

void main() {
  group('ConfirmOtpRequest', () {
    test('toJson() maps fields correctly', () {
      final request = ConfirmOtpRequest(
        signinKey: 'test@example.com',
        confirmationCode: '123456',
      );

      final json = request.toJson();

      expect(json, equals({
        'signin_key': 'test@example.com',
        'confirmation_code': '123456',
      }));
    });
  });
}
