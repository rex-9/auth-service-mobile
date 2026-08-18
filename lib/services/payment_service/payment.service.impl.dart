import 'package:get/get.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/services.dart';

class PaymentServiceImpl extends PaymentService {
  final ApiService _api = Get.find();

  @override
  Future<ApiResponse<ProductsResponse>> fetchProducts() async {
    final response = await _api.get(ServerRoutes.getProducts);
    return _api.parseResponse<ProductsResponse>(
      response,
      (data) => ProductsResponse.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<CheckoutSessionResponse>> createCheckoutSession(
    String productId,
  ) async {
    final response = await _api.post(ServerRoutes.createCheckoutSession, {
      'product_id': productId,
    });
    return _api.parseResponse<CheckoutSessionResponse>(
      response,
      (data) => CheckoutSessionResponse.fromJson(data),
    );
  }
}
