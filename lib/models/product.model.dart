class ProductModel {
  final String id;
  final String type;
  final String name;
  final String description;
  final int priceUnitAmount;
  final String currency;
  final String? cycle;
  final String stripeProductId;
  final String stripePriceId;
  final bool active;
  final String price;
  final String periodLabel;
  final bool recurring;
  final String? createdAt;
  final String? updatedAt;

  const ProductModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.priceUnitAmount,
    required this.currency,
    this.cycle,
    required this.stripeProductId,
    required this.stripePriceId,
    required this.active,
    required this.price,
    required this.periodLabel,
    required this.recurring,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>? ?? json;

    return ProductModel(
      id: json['id']?.toString() ?? attrs['id']?.toString() ?? '',
      type: json['type'] as String? ?? 'product',
      name: attrs['name'] as String? ?? '',
      description: attrs['description'] as String? ?? '',
      priceUnitAmount: attrs['price_unit_amount'] as int? ?? 0,
      currency: attrs['currency'] as String? ?? '',
      cycle: attrs['cycle'] as String?,
      stripeProductId: attrs['stripe_product_id'] as String? ?? '',
      stripePriceId: attrs['stripe_price_id'] as String? ?? '',
      active: attrs['active'] as bool? ?? false,
      price: attrs['price'] as String? ?? '',
      periodLabel: attrs['period_label'] as String? ?? '',
      recurring: attrs['recurring'] as bool? ?? false,
      createdAt: attrs['created_at'] as String?,
      updatedAt: attrs['updated_at'] as String?,
    );
  }
}
