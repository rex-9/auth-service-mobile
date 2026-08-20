// lib/services/api.service.dart
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:rexone_mobile/config/config.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/models/responses/api.response.dart';
import 'package:rexone_mobile/models/pagination_model.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/helpers/api.helper.dart';
import 'package:rexone_mobile/services/storage.service.dart';

import '../modules/auth/auth.dart';
import '../modules/setting/setting.dart';

class ApiService extends GetConnect {
  static const String sessionReplacedError = 'Active session not found';

  @override
  void onInit() {
    super.onInit();
    _setupHttpClient();
    _setupInterceptors();
  }

  void _setupHttpClient() {
    httpClient.baseUrl = AppConfig.apiBaseUrl;
    httpClient.timeout = Design.timers.apiTimeout;
    httpClient.defaultContentType = AppConstants.contentTypeJson;
  }

  void _setupInterceptors() {
    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers[AppConstants.headerAccept] = AppConstants.contentTypeJson;
      request.headers[AppConstants.headerContentType] =
          AppConstants.contentTypeJson;
      request.headers[AppConstants.headerXPlatform] =
          AppConstants.platformMobile;
      String apiLocale = 'en';
      if (Get.isRegistered<SettingsController>()) {
        final code = Get.find<SettingsController>().localeCode.value;
        apiLocale = code.split('_').first.toLowerCase();
      } else if (Get.isRegistered<StorageService>()) {
        final code = Get.find<StorageService>().getLocaleCode() ?? 'en_US';
        apiLocale = code.split('_').first.toLowerCase();
      }
      request.headers[AppConstants.headerXLocale] = apiLocale;
      request.headers[AppConstants.headerAcceptLanguage] = apiLocale;
      String token = '';
      if (Get.isRegistered<AuthController>()) {
        token = Get.find<AuthController>().authToken.value;
      }
      if (token.isEmpty && Get.isRegistered<StorageService>()) {
        token = Get.find<StorageService>().getToken() ?? '';
      }
      if (token.isNotEmpty) {
        request.headers[AppConstants.headerAuthorization] =
            '${AppConstants.bearerPrefix}$token';
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      _handleSessionExpiry(request, response);
      return response;
    });
  }

  Future<Response<T>> _withLoading<T>(
    Future<Response<T>> Function() fn,
    bool showLoading,
  ) async {
    if (showLoading) _showLoading();
    try {
      return await fn();
    } finally {
      if (showLoading) _hideLoading();
    }
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    String? contentType,
    Decoder<T>? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool showLoading = true,
  }) async {
    return _withLoading(
      () => super.get(
        url,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
      ),
      showLoading,
    );
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
    bool showLoading = true,
  }) async {
    return _withLoading(
      () => super.post(
        url,
        body,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
        uploadProgress: uploadProgress,
      ),
      showLoading,
    );
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
    bool showLoading = true,
  }) async {
    return _withLoading(
      () => super.put(
        url,
        body,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
        uploadProgress: uploadProgress,
      ),
      showLoading,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    String? contentType,
    Decoder<T>? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool showLoading = true,
  }) async {
    return _withLoading(
      () => super.delete(
        url,
        contentType: contentType,
        decoder: decoder,
        headers: headers,
        query: query,
      ),
      showLoading,
    );
  }

  void _showLoading() => AppLoading.show();
  void _hideLoading() => AppLoading.hide();

  // ===== RESPONSE HANDLING =====
  ApiResponse<T> parseResponse<T>(
    Response response,
    T? Function(dynamic data) fromJson,
  ) {
    final body = response.body is Map
        ? Map<String, dynamic>.from(response.body as Map)
        : <String, dynamic>{};
    final status = body[JsonKeys.status] is Map
        ? Map<String, dynamic>.from(body[JsonKeys.status] as Map)
        : <String, dynamic>{};
    final statusCode =
        status[JsonKeys.code] as int? ?? response.statusCode ?? 500;
    final data = body[JsonKeys.data];

    if (response.hasError || !(status[JsonKeys.success] as bool? ?? false)) {
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
            status[JsonKeys.error] as String? ??
            status[JsonKeys.message] as String? ??
            response.statusText ??
            HttpStatusMap.getMessage(statusCode),
        statusCode: statusCode,
        data: data != null ? fromJson(data) : null,
      );
    }

    return ApiResponse.success(
      message:
          status[JsonKeys.message] as String? ??
          HttpStatusMap.getMessage(statusCode),
      statusCode: statusCode,
      data: data != null ? fromJson(data) : null,
    );
  }

  PaginatedResponse<T> parsePaginatedResponse<T>(
    Response response,
    T Function(dynamic data) fromJson,
  ) {
    final body = response.body is Map
        ? Map<String, dynamic>.from(response.body as Map)
        : <String, dynamic>{};
    final status = body[JsonKeys.status] is Map
        ? Map<String, dynamic>.from(body[JsonKeys.status] as Map)
        : <String, dynamic>{};
    final statusCode =
        status[JsonKeys.code] as int? ?? response.statusCode ?? 500;
    final data = body[JsonKeys.data];
    final meta = body[JsonKeys.meta];

    final isSuccess = status[JsonKeys.success] as bool? ?? false;
    final msg =
        status[JsonKeys.message] as String? ??
        status[JsonKeys.error] as String? ??
        response.statusText ??
        HttpStatusMap.getMessage(statusCode);

    final List<T> records = ApiHelper.parseList(data, fromJson);

    PaginationMeta? pagination;
    if (meta is Map && meta[JsonKeys.pagination] is Map) {
      pagination = PaginationMeta.fromJson(
        Map<String, dynamic>.from(meta[JsonKeys.pagination] as Map),
      );
    }

    return PaginatedResponse<T>(
      records: records,
      pagination: pagination,
      message: msg,
      statusCode: statusCode,
      success: isSuccess && !response.hasError,
    );
  }

  // ===== PRIVATE HELPERS =====

  void _handleSessionExpiry(Request request, Response response) {
    if (response.statusCode == HttpStatus.unauthorized) {
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        final serverError = _bodyError(response.body);
        final isSessionReplaced = serverError == sessionReplacedError;
        final isAuthRoute =
            request.url.path.contains(ServerRoutes.signIn) ||
            request.url.path.contains(ServerRoutes.signUp) ||
            request.url.path.contains(ServerRoutes.peekUser);

        if (!isAuthRoute &&
            (authController.isLoggedIn.value ||
                authController.authToken.value.isNotEmpty)) {
          authController.handleSessionExpired(replaced: isSessionReplaced);
        }
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
