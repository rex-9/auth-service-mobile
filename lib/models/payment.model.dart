// lib/models/payment.model.dart
import 'package:rexone_mobile/constants/constants.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final int priceUnitAmount;
  final String currency;
  final String? cycle;
  final String periodLabel;
  final bool recurring;
  final bool active;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.priceUnitAmount,
    required this.currency,
    this.cycle,
    required this.periodLabel,
    required this.recurring,
    required this.active,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      name: json[PaymentKeys.name]?.toString() ?? '',
      description: json[PaymentKeys.description]?.toString() ?? '',
      price: json[PaymentKeys.price]?.toString() ?? '\$0.00',
      priceUnitAmount: json[PaymentKeys.priceUnitAmount] is int
          ? json[PaymentKeys.priceUnitAmount] as int
          : int.tryParse(
                  json[PaymentKeys.priceUnitAmount]?.toString() ?? '0',
                ) ??
                0,
      currency: json[PaymentKeys.currency]?.toString() ?? 'usd',
      cycle: json[PaymentKeys.cycle]?.toString(),
      periodLabel: json[PaymentKeys.periodLabel]?.toString() ?? '',
      recurring: json[PaymentKeys.recurring] == true,
      active: json[PaymentKeys.active] != false,
    );
  }

  Map<String, dynamic> toJson() => {
    ApiKeys.id: id,
    PaymentKeys.name: name,
    PaymentKeys.description: description,
    PaymentKeys.price: price,
    PaymentKeys.priceUnitAmount: priceUnitAmount,
    PaymentKeys.currency: currency,
    PaymentKeys.cycle: cycle,
    PaymentKeys.periodLabel: periodLabel,
    PaymentKeys.recurring: recurring,
    PaymentKeys.active: active,
  };
}
