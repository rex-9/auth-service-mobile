import 'package:get/get.dart';
import 'package:auth_service_mobile/models/models.dart';
import 'package:auth_service_mobile/routes/routes.dart';
import 'package:auth_service_mobile/services/services.dart';

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
}
