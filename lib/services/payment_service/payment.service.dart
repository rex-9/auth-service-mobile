import 'package:get/get.dart';
import 'package:auth_service_mobile/models/models.dart';

abstract class PaymentService extends GetxService {
  Future<ApiResponse<ProductsResponse>> fetchProducts();

  Future<ApiResponse<CheckoutSessionResponse>> createCheckoutSession(
    String productId,
  );
}
