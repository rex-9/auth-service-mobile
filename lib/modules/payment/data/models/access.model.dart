// lib/modules/payment/data/models/access.model.dart
import 'package:rexone_mobile/constants/constants.dart';

class AccessModel {
  final String id;
  final String status;
  final String? grantedAt;
  final String? expiresAt;
  final String? revokedAt;
  final String? expiredAt;
  final String productId;
  final String? productName;
  final int? daysRemaining;
  final bool active;

  AccessModel({
    required this.id,
    required this.status,
    this.grantedAt,
    this.expiresAt,
    this.revokedAt,
    this.expiredAt,
    required this.productId,
    this.productName,
    this.daysRemaining,
    required this.active,
  });

  factory AccessModel.fromJson(Map<String, dynamic> json) {
    return AccessModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      status: json[PaymentKeys.status]?.toString() ?? 'active',
      grantedAt: json[PaymentKeys.grantedAt]?.toString(),
      expiresAt: json[PaymentKeys.expiresAt]?.toString(),
      revokedAt: json[PaymentKeys.revokedAt]?.toString(),
      expiredAt: json[PaymentKeys.expiredAt]?.toString(),
      productId: json[PaymentKeys.productId]?.toString() ?? '',
      productName: json[PaymentKeys.productName]?.toString(),
      daysRemaining: json[PaymentKeys.daysRemaining] as int?,
      active: json[PaymentKeys.active] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    ApiKeys.id: id,
    PaymentKeys.status: status,
    PaymentKeys.grantedAt: grantedAt,
    PaymentKeys.expiresAt: expiresAt,
    PaymentKeys.revokedAt: revokedAt,
    PaymentKeys.expiredAt: expiredAt,
    PaymentKeys.productId: productId,
    PaymentKeys.productName: productName,
    PaymentKeys.daysRemaining: daysRemaining,
    PaymentKeys.active: active,
  };
}
