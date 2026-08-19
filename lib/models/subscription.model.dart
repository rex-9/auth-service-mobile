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
