// lib/services/api_service.dart
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:auth_service_mobile/constants/constants.dart';
import 'package:auth_service_mobile/controllers/controllers.dart';
import 'package:auth_service_mobile/design/design.dart';
import 'package:auth_service_mobile/routes/routes.dart';
import 'package:auth_service_mobile/models/responses/api.response.dart';

class ApiService extends GetConnect {
  static const String sessionReplacedError = 'Active session not found';
  bool _isLoadingShown = false;

  @override
  void onInit() {
    super.onInit();
    _setupHttpClient();
    _setupInterceptors();
  }

  void _setupHttpClient() {
    httpClient.baseUrl = ServerRoutes.baseUrl;
    httpClient.timeout = Design.timers.apiTimeout;
    httpClient.defaultContentType = 'application/json';
  }

  void _setupInterceptors() {
    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['X-Platform'] = 'mobile';
      final authController = Get.find<AuthController>();
      if (authController.authToken.value.isNotEmpty) {
        request.headers['Authorization'] =
            'Bearer ${authController.authToken.value}';
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      _handleSessionExpiry(request, response);
      return response;
    });
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    String? contentType,
    Decoder<T>? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    _showLoading();
    try {
      return await super.get(
        url,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
      );
    } finally {
      _hideLoading();
    }
  }

  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Decoder<T>? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Progress? uploadProgress,
  }) async {
    _showLoading();
    try {
      return await super.post(
        url,
        body,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
        uploadProgress: uploadProgress,
      );
    } finally {
      _hideLoading();
    }
  }

  @override
  Future<Response<T>> put<T>(
    String url,
    dynamic body, {
    String? contentType,
    Decoder<T>? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Progress? uploadProgress,
  }) async {
    _showLoading();
    try {
      return await super.put(
        url,
        body,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
        uploadProgress: uploadProgress,
      );
    } finally {
      _hideLoading();
    }
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    String? contentType,
    Decoder<T>? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    _showLoading();
    try {
      return await super.delete(
        url,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
      );
    } finally {
      _hideLoading();
    }
  }

  void _showLoading() {
    if (!_isLoadingShown && Get.context != null) {
      _isLoadingShown = true;
      AppLoading.showOverlay(Get.context!);
    }
  }

  void _hideLoading() {
    if (_isLoadingShown && Get.context != null) {
      _isLoadingShown = false;
      AppLoading.hideOverlay(Get.context!);
    }
  }

  // ===== RESPONSE HANDLING =====
  ApiResponse<T> parseResponse<T>(
    Response response,
    T? Function(Map<String, dynamic> data) fromJson,
  ) {
    final body = response.body as Map<String, dynamic>? ?? {};
    final status = body['status'] as Map<String, dynamic>? ?? {};
    final statusCode = status['code'] as int? ?? response.statusCode ?? 500;
    final data = body['data'] as Map<String, dynamic>?;


    if (response.hasError || !(status['success'] as bool? ?? false)) {
      // Optional: Log API errors to analytics
      // try {
      //   final analytics = Get.find<AnalyticsService>();
      //   analytics.logError(
      //     status['error'] as String? ??
      //         response.statusText ??
      //         'Unknown API error',
      //     context: response.url?.path ?? 'api_call',
      //   );
      // } catch (_) {
      //   // Analytics not initialized, ignore
      // }

      return ApiResponse.error(
        message:
            status['error'] as String? ??
            status['message'] as String? ??
            response.statusText ??
            HttpStatusMap.getMessage(statusCode),
        statusCode: statusCode,
        data: data != null ? fromJson(data) : null,
      );
    }

    return ApiResponse.success(
      message:
          status['message'] as String? ?? HttpStatusMap.getMessage(statusCode),
      statusCode: statusCode,
      data: data != null ? fromJson(data) : null,
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
