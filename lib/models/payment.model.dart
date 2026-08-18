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

class SubscriptionModel {
  final String id;
  final String status;
  final String productId;
  final String? currentPeriodStart;
  final String? currentPeriodEnd;
  final String? startedAt;
  final String? endedAt;
  final String? canceledAt;
  final bool active;
  final bool canceled;
  final bool scheduledForCancellation;
  final String? productName;
  final String? price;
  final String? periodLabel;

  SubscriptionModel({
    required this.id,
    required this.status,
    required this.productId,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.startedAt,
    this.endedAt,
    this.canceledAt,
    required this.active,
    required this.canceled,
    required this.scheduledForCancellation,
    this.productName,
    this.price,
    this.periodLabel,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString() ?? '';
    final canceledAt = json['canceled_at']?.toString();
    final endedAt = json['ended_at']?.toString();
    final active = json['active'] == true || status == 'active';
    final scheduled = canceledAt != null && endedAt == null && active;

    return SubscriptionModel(
      id: json['id']?.toString() ?? '',
      status: status,
      productId: json['product_id']?.toString() ?? '',
      currentPeriodStart: json['current_period_start']?.toString(),
      currentPeriodEnd: json['current_period_end']?.toString(),
      startedAt: json['started_at']?.toString(),
      endedAt: endedAt,
      canceledAt: canceledAt,
      active: active,
      canceled: json['canceled'] == true || status == 'canceled',
      scheduledForCancellation:
          json['scheduled_for_cancellation'] == true || scheduled,
      productName: json['product_name']?.toString(),
      price: json['price']?.toString(),
      periodLabel: json['period_label']?.toString(),
    );
  }

  bool get isActive => active;
  bool get isCanceled => canceled;
  bool get isScheduledForCancellation => scheduledForCancellation;
}

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
