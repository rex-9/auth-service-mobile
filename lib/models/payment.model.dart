// lib/models/payment.model.dart

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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '\$0.00',
      priceUnitAmount: json['price_unit_amount'] is int
          ? json['price_unit_amount']
          : int.tryParse(json['price_unit_amount']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? 'usd',
      cycle: json['cycle']?.toString(),
      periodLabel: json['period_label']?.toString() ?? '',
      recurring: json['recurring'] == true,
      active: json['active'] != false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'price_unit_amount': priceUnitAmount,
        'currency': currency,
        'cycle': cycle,
        'period_label': periodLabel,
        'recurring': recurring,
        'active': active,
      };
}


