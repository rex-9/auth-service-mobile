import 'package:get/get.dart';
import 'package:rexone_mobile/models/models.dart';

abstract class PaymentService extends GetxService {
  Future<ApiResponse<ProductsResponse>> fetchProducts();

  Future<ApiResponse<CheckoutSessionResponse>> createCheckoutSession(
    String productId,
  );
}
