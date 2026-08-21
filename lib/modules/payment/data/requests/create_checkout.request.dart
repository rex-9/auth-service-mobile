import 'package:rexone_mobile/constants/constants.dart';

class CreateCheckoutRequest {
  final String productId;
  final String? successUrl;
  final String? cancelUrl;

  const CreateCheckoutRequest({
    required this.productId,
    this.successUrl,
    this.cancelUrl,
  });

  Map<String, dynamic> toJson() => {
    PaymentKeys.productId: productId,
    PaymentKeys.successUrl: ?successUrl,
    PaymentKeys.cancelUrl: ?cancelUrl,
  };
}
