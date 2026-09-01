// test/modules/payment/data/models/payment_models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rexone_mobile/modules/payment/data/models/models.dart';

void main() {
  group('ProductModel', () {
    test('parses free product correctly', () {
      final json = {
        'id': 'prod_free_1',
        'name': 'Free Course',
        'description': 'A free course',
        'price': 'Free',
        'price_unit_amount': 0,
        'currency': 'usd',
        'cycle': null,
        'period_label': 'One-time purchase',
        'recurring': false,
        'active': true,
        'free': true,
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, 'prod_free_1');
      expect(product.name, 'Free Course');
      expect(product.priceUnitAmount, 0);
      expect(product.price, 'Free');
      expect(product.isFree, true);
      expect(product.recurring, false);
      expect(product.active, true);
    });

    test('parses paid product correctly', () {
      final json = {
        'id': 'prod_paid_1',
        'name': 'Pro Plan',
        'description': 'Monthly subscription',
        'price': 'USD 10.00',
        'price_unit_amount': 1000,
        'currency': 'usd',
        'cycle': 'month',
        'period_label': 'monthly',
        'recurring': true,
        'active': true,
        'free': false,
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, 'prod_paid_1');
      expect(product.priceUnitAmount, 1000);
      expect(product.isFree, false);
      expect(product.recurring, true);
    });
  });

  group('AccessModel', () {
    test('parses active access correctly', () {
      final json = {
        'id': 'acc_123',
        'status': 'active',
        'granted_at': '2026-09-01T00:00:00Z',
        'expires_at': null,
        'product_id': 'prod_free_1',
        'product_name': 'Free Course',
        'days_remaining': null,
        'active': true,
      };

      final access = AccessModel.fromJson(json);

      expect(access.id, 'acc_123');
      expect(access.productId, 'prod_free_1');
      expect(access.status, 'active');
      expect(access.active, true);
      expect(access.productName, 'Free Course');
    });

    test('parses revoked access with timestamps', () {
      final json = {
        'id': 'acc_456',
        'status': 'revoked',
        'granted_at': '2026-08-01T00:00:00Z',
        'revoked_at': '2026-08-15T12:00:00Z',
        'expires_at': null,
        'product_id': 'prod_free_1',
        'product_name': 'Free Course',
        'days_remaining': null,
        'active': false,
      };

      final access = AccessModel.fromJson(json);

      expect(access.id, 'acc_456');
      expect(access.status, 'revoked');
      expect(access.active, false);
      expect(access.revokedAt, '2026-08-15T12:00:00Z');
    });
  });
}
