class ApiResponse<T> {
  final int statusCode;
  final bool success;
  final String message;
  final String? error;
  final T? data;

  const ApiResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    this.error,
    this.data,
  });

  factory ApiResponse.success({
    required String message,
    required int statusCode,
    required T data,
  }) = SuccessApiResponse<T>;

  factory ApiResponse.error({
    required String message,
    required int statusCode,
    T? data,
  }) = ErrorApiResponse<T>;
}

class SuccessApiResponse<T> extends ApiResponse<T> {
  const SuccessApiResponse({
    required super.message,
    required super.statusCode,
    required super.data,
  }) : super(success: true, error: null);
}

class ErrorApiResponse<T> extends ApiResponse<T> {
  const ErrorApiResponse({
    required super.message,
    required super.statusCode,
    super.data,
  }) : super(success: false);
}
