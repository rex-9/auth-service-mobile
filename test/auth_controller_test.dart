import 'package:flutter_test/flutter_test.dart';

import 'package:auth_service_mobile/controllers/auth_controller.dart';

void main() {
  group('AuthController.extractPasscodeRetryMeta', () {
    test('reads server retry metadata from a nested payload', () {
      final meta = authController.extractPasscodeRetryMeta({
        'status': {'code': 401},
        'data': {
          'remaining_attempts': 2,
          'retry_after': 0,
        },
      });

      expect(meta.remainingAttempts, 2);
      expect(meta.cooldownSeconds, 0);
    });

    test('derives cooldownUntilMs from retry_after seconds', () {
      final before = DateTime.now().millisecondsSinceEpoch;
      final meta = authController.extractPasscodeRetryMeta({
        'data': {
          'remaining_attempts': 0,
          'retry_after': 30,
        },
      });
      final after = DateTime.now().millisecondsSinceEpoch;

      expect(meta.remainingAttempts, 0);
      expect(meta.cooldownSeconds, 30);
      expect(meta.cooldownUntilMs, isNotNull);
      expect(meta.cooldownUntilMs!, greaterThanOrEqualTo(before + 30000));
      expect(meta.cooldownUntilMs!, lessThanOrEqualTo(after + 30000));
    });

    test('supports the alternate attempts_remaining_before_cooldown key', () {
      final meta = authController.extractPasscodeRetryMeta({
        'data': {'attempts_remaining_before_cooldown': 1},
      });

      expect(meta.remainingAttempts, 1);
    });

    test('normalizes numeric strings', () {
      final meta = authController.extractPasscodeRetryMeta({
        'data': {
          'remaining_attempts': '2',
          'cooldown_remaining': '15',
        },
      });

      expect(meta.remainingAttempts, 2);
      expect(meta.cooldownSeconds, 15);
    });

    test('returns empty meta when no keys are present', () {
      final meta = authController.extractPasscodeRetryMeta({
        'data': {'something_else': true},
      });

      expect(meta.remainingAttempts, isNull);
      expect(meta.cooldownSeconds, isNull);
      expect(meta.cooldownUntilMs, isNull);
    });
  });
}
