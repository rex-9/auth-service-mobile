// lib/services/api_service.dart
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/server_routes.dart';
import '../models/api_response.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ServerRoutes.baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = 'application/json';

    // Add auth token interceptor
    httpClient.addRequestModifier<dynamic>((request) async {
      final authController = Get.find<AuthController>();
      if (authController.authToken.value.isNotEmpty) {
        request.headers['Authorization'] =
            'Bearer ${authController.authToken.value}';
      }
      return request;
    });

    // Handle 401 responses
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        Get.find<AuthController>().signout();
      }
      return response;
    });
  }

  // Generic response parser
  ApiResponse<T> parseResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    if (response.hasError) {
      return ApiResponse.error(
        message:
            response.body?['status']?['error'] ??
            response.statusText ??
            'Unknown error',
        statusCode: response.statusCode ?? 500,
      );
    }

    final body = response.body;
    return ApiResponse.success(
      message: body['status']['message'],
      data: body['data'] != null ? fromJson(body['data']) : null,
      statusCode: body['status']['code'],
    );
  }
}
