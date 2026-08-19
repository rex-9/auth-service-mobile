class TransactionModel {
  final String id;
  final String? productId;
  final int priceUnitAmount;
  final String currency;
  final bool paid;
  final String status;
  final String? productName;
  final String? createdAt;

  TransactionModel({
    required this.id,
    this.productId,
    required this.priceUnitAmount,
    required this.currency,
    required this.paid,
    required this.status,
    this.productName,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString(),
      priceUnitAmount: json['price_unit_amount'] is int
          ? json['price_unit_amount']
          : int.tryParse(json['price_unit_amount']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? 'usd',
      paid: json['paid'] == true || json['status'] == 'succeeded',
      status: json['status']?.toString() ?? '',
      productName: json['product_name']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
