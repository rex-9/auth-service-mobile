/// Mirrors web `src/models/api.model.ts`.
class ApiResponse<T> {
  const ApiResponse({this.data, this.error});

  final T? data;
  final String? error;
}

class ApiAuthStatus {
  const ApiAuthStatus({
    required this.code,
    required this.success,
    required this.message,
    this.error,
  });

  final int code;
  final bool success;
  final String message;
  final String? error;

  factory ApiAuthStatus.fromJson(Map<String, dynamic> json) {
    return ApiAuthStatus(
      code: json['code'] is int ? json['code'] as int : -1,
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      error: json['error'] as String?,
    );
  }
}

/// The `{ status: {...}, data: {...} }` envelope every auth endpoint returns.
class ApiAuthResponse {
  const ApiAuthResponse({this.status, this.data});

  final ApiAuthStatus? status;
  final Map<String, dynamic>? data;

  factory ApiAuthResponse.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'];
    final rawData = json['data'];
    return ApiAuthResponse(
      status: rawStatus is Map<String, dynamic>
          ? ApiAuthStatus.fromJson(rawStatus)
          : null,
      data: rawData is Map<String, dynamic> ? rawData : null,
    );
  }
}
