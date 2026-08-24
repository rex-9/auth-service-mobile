import 'dart:typed_data';

class BinaryResponse {
  final int statusCode;
  final bool success;
  final Uint8List? bytes;
  final String? error;

  const BinaryResponse({
    required this.statusCode,
    required this.success,
    this.bytes,
    this.error,
  });

  factory BinaryResponse.success({
    required int statusCode,
    required Uint8List bytes,
  }) {
    return BinaryResponse(
      statusCode: statusCode,
      success: true,
      bytes: bytes,
    );
  }

  factory BinaryResponse.error({
    required int statusCode,
    required String error,
  }) {
    return BinaryResponse(
      statusCode: statusCode,
      success: false,
      error: error,
    );
  }
}
