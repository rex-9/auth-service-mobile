import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models/models.dart';

/// Mirrors web `src/services/api.service.ts`.
///
/// The web client wires an axios interceptor to (1) attach the bearer token,
/// (2) send the `X-Platform` header so the backend can enforce one active
/// session per platform, (3) toggle the global loading overlay, and
/// (4) sign the user out when the active session was replaced by a newer
/// sign in. The same hooks exist here and are wired up in `App`.
class Api {
  Api._();

  static const String platformHeaderValue = 'mobile';
  static const String sessionReplacedError = 'Active session not found';
  static const String sessionReplacedMessage =
      'Your session was replaced by a newer sign in on this platform.';
  static const Duration _timeout = Duration(seconds: 10);

  /// Set by [App]: reads the current auth token (mirrors the axios
  /// request interceptor reading `useAuth().token`).
  static String? Function()? tokenProvider;

  /// Set by [App]: toggles the global loading overlay.
  static void Function(bool isLoading)? onLoading;

  /// Set by [App]: invoked when the backend reports the active session was
  /// replaced by a newer sign in on this platform (401 + specific error).
  static void Function(String message)? onSessionReplaced;

  static http.Client httpClient = http.Client();

  static Uri _uri(String path, [Map<String, String>? params]) {
    final base = Uri.parse(AppConfig.serverBaseUrl);
    return base.replace(
      path: path,
      queryParameters: params == null || params.isEmpty ? null : params,
    );
  }

  static Map<String, String> _headers({bool json = true}) {
    final headers = <String, String>{
      'X-Platform': platformHeaderValue,
      'Accept': 'application/json',
    };
    if (json) headers['Content-Type'] = 'application/json';
    final token = tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<ApiResponse<Map<String, dynamic>>> _request(
    Future<http.Response> Function() send, {
    bool skipLoading = false,
  }) async {
    if (!skipLoading) onLoading?.call(true);
    try {
      final response = await send().timeout(_timeout);
      final body = _decodeBody(response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(data: body);
      }

      // Server responded with a status outside the 200 range.
      final serverError = _statusError(body);
      _handleSessionReplaced(response.statusCode, serverError);
      return ApiResponse(
        data: body,
        error: serverError ?? 'An error occurred',
      );
    } on TimeoutException {
      return const ApiResponse(
        error: 'Network error, please try again later',
      );
    } on SocketException {
      return const ApiResponse(
        error: 'Network error, please try again later',
      );
    } catch (_) {
      return const ApiResponse(
        error: 'An error occurred, please try again',
      );
    } finally {
      if (!skipLoading) onLoading?.call(false);
    }
  }

  static Map<String, dynamic>? _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static String? _statusError(Map<String, dynamic>? body) {
    final status = body?['status'];
    if (status is Map<String, dynamic>) {
      final error = status['error'];
      if (error is String && error.isNotEmpty) return error;
    }
    return null;
  }

  static void _handleSessionReplaced(int statusCode, String? serverError) {
    final token = tokenProvider?.call();
    if (statusCode == 401 &&
        token != null &&
        token.isNotEmpty &&
        serverError == sessionReplacedError) {
      onSessionReplaced?.call(sessionReplacedMessage);
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, String>? params,
    bool skipLoading = false,
  }) {
    return _request(
      () => httpClient.get(_uri(path, params), headers: _headers(json: false)),
      skipLoading: skipLoading,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> post(
    String path, {
    Object? data,
    bool skipLoading = false,
  }) {
    return _request(
      () => httpClient.post(
        _uri(path),
        headers: _headers(),
        body: data == null ? null : jsonEncode(data),
      ),
      skipLoading: skipLoading,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> put(
    String path, {
    Object? data,
    bool skipLoading = false,
  }) {
    return _request(
      () => httpClient.put(
        _uri(path),
        headers: _headers(),
        body: data == null ? null : jsonEncode(data),
      ),
      skipLoading: skipLoading,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> delete(
    String path, {
    bool skipLoading = false,
  }) {
    return _request(
      () => httpClient.delete(_uri(path), headers: _headers(json: false)),
      skipLoading: skipLoading,
    );
  }
}

/// Mirrors `apiHandler` in web `src/services/api.service.ts`.
Future<void> apiHandler(
  String operation,
  Future<ApiResponse<ApiAuthResponse>> Function() apiFunction,
  void Function(String message) setError,
  void Function(ApiAuthResponse response) onSuccess, [
  void Function()? onFailure,
]) async {
  try {
    final response = await apiFunction();
    final status = response.data?.status;
    if (status?.success == true) {
      setError('');
      onSuccess(response.data!);
    } else {
      setError(status?.error ?? 'An error occurred when $operation.');
      onFailure?.call();
    }
  } catch (error) {
    setError('An error occurred when $operation. error: $error');
    onFailure?.call();
  }
}
