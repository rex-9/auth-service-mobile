class CheckoutSessionResponse {
  final String checkoutUrl;
  final String sessionId;

  const CheckoutSessionResponse({
    required this.checkoutUrl,
    required this.sessionId,
  });

  factory CheckoutSessionResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionResponse(
      checkoutUrl: json['checkout_url'] as String? ?? '',
      sessionId: json['session_id'] as String? ?? '',
    );
  }
}
