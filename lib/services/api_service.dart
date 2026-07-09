// lib/services/api_service.dart
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/routes/routes.dart';
import 'package:meritbox_mobile/models/api_response.dart';

// #TODO: API impl
class ApiService extends GetConnect {
  static const String sessionReplacedError = 'Active session not found';

  // ===== LIFECYCLE =====
  @override
  void onInit() {
    super.onInit();
    _setupHttpClient();
    _setupInterceptors();
  }

  // ===== SETUP =====
  void _setupHttpClient() {
    httpClient.baseUrl = ServerRoutes.baseUrl;
    httpClient.timeout = Design.timers.apiTimeout;
    httpClient.defaultContentType = 'application/json';
  }

  void _setupInterceptors() {
    // Request interceptor: Add auth token + platform
    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['X-Platform'] = 'mobile';
      final authController = Get.find<AuthController>();
      if (authController.authToken.value.isNotEmpty) {
        request.headers['Authorization'] =
            'Bearer ${authController.authToken.value}';
      }
      return request;
    });

    // Response interceptor: Handle session expiry
    httpClient.addResponseModifier((request, response) {
      _handleSessionExpiry(request, response);
      return response;
    });
  }

  // ===== RESPONSE HANDLING =====
  ApiResponse<T> parseResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    final statusCode =
        response.body?['status']?['code'] ??
        response.statusCode ??
        HttpStatus.internalServerError;

    if (response.hasError) {
      T? errorData;
      try {
        final data = response.body?['data'];
        if (data != null) errorData = fromJson(data);
      } catch (_) {
        // Error payload doesn't match expected shape; ignore.
      }

      return ApiResponse.error(
        message:
            response.body?['status']?['error'] ??
            response.statusText ??
            HttpStatusMap.getMessage(statusCode),
        statusCode: statusCode,
        data: errorData,
      );
    }

    final body = response.body;
    return ApiResponse.success(
      message:
          body['status']['message'] ?? HttpStatusMap.getMessage(statusCode),
      data: body['data'] != null ? fromJson(body['data']) : null,
      statusCode: statusCode,
    );
  }

  // ===== PRIVATE HELPERS =====
  void _handleSessionExpiry(Request request, Response response) {
    if (response.statusCode == HttpStatus.unauthorized) {
      final authController = Get.find<AuthController>();
      final serverError = _bodyError(response.body);
      final isSessionReplaced = serverError == sessionReplacedError;
      final isSessionValidation = request.url.path.contains(
        ServerRoutes.currentUser,
      );

      if (authController.isLoggedIn.value &&
          (isSessionReplaced || isSessionValidation)) {
        authController.handleSessionExpired(replaced: isSessionReplaced);
      }
    }
  }

  String? _bodyError(dynamic body) {
    if (body is Map) {
      final status = body['status'];
      if (status is Map) return status['error'] as String?;
    }
    return null;
  }
}
