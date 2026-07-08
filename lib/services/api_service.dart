// lib/services/api_service.dart
import 'package:get/get.dart';
import 'package:meritbox_mobile/design/design.dart';
import '../controllers/auth_controller.dart';
import '../routes/server_routes.dart';
import '../models/api_response.dart';

class ApiService extends GetConnect {
  static const String sessionReplacedError = 'Active session not found';

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ServerRoutes.baseUrl;
    httpClient.timeout = Design.timers.apiTimeout;
    httpClient.defaultContentType = 'application/json';

    // Add auth token + platform interceptor. X-Platform lets the backend
    // enforce one active session per platform (web vs mobile).
    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['X-Platform'] = 'mobile';
      final authController = Get.find<AuthController>();
      if (authController.authToken.value.isNotEmpty) {
        request.headers['Authorization'] =
            'Bearer ${authController.authToken.value}';
      }
      return request;
    });

    // Handle session-expiry 401s. A plain 401 can just be a wrong passcode,
    // so only sign out when the active session was replaced by a newer sign
    // in (or the session validation request itself fails), like the web.
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
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
      return response;
    });
  }

  String? _bodyError(dynamic body) {
    if (body is Map) {
      final status = body['status'];
      if (status is Map) return status['error'] as String?;
    }
    return null;
  }

  // Generic response parser
  ApiResponse<T> parseResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    if (response.hasError) {
      // Keep parsed data on errors too: 401/429 sign-in failures carry
      // retry metadata (remaining_attempts, retry_after) in data.
      T? errorData;
      try {
        final data = response.body?['data'];
        if (data != null) errorData = fromJson(data);
      } catch (_) {
        // Error payload does not match the expected shape; ignore.
      }
      return ApiResponse.error(
        message:
            response.body?['status']?['error'] ??
            response.statusText ??
            'Unknown error',
        statusCode:
            response.body?['status']?['code'] ?? response.statusCode ?? 500,
        data: errorData,
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
