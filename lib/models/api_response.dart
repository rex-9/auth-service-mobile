// lib/models/api_response.dart
class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.success({
    required String message,
    required int statusCode,
    T? data,
  }) {
    return ApiResponse(
      success: true,
      statusCode: statusCode,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.error({
    required String message,
    required int statusCode,
    String? error,
  }) {
    return ApiResponse(
      success: false,
      statusCode: statusCode,
      message: message,
      data: null,
      error: error,
    );
  }
}
