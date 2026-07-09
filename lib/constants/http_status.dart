// lib/constants/http_status.dart
class HttpStatus {
  const HttpStatus._();

  // ===== 2xx SUCCESS =====
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // ===== 4xx CLIENT ERRORS =====
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  // ===== 5xx SERVER ERRORS =====
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}

// ===== HTTP STATUS MAP =====
class HttpStatusMap {
  const HttpStatusMap._();

  static Map<int, String> get messages => {
    HttpStatus.ok: 'OK',
    HttpStatus.created: 'Created',
    HttpStatus.accepted: 'Accepted',
    HttpStatus.noContent: 'No Content',
    HttpStatus.badRequest: 'Bad Request',
    HttpStatus.unauthorized: 'Unauthorized',
    HttpStatus.forbidden: 'Forbidden',
    HttpStatus.notFound: 'Not Found',
    HttpStatus.methodNotAllowed: 'Method Not Allowed',
    HttpStatus.conflict: 'Conflict',
    HttpStatus.unprocessableEntity: 'Unprocessable Entity',
    HttpStatus.tooManyRequests: 'Too Many Requests',
    HttpStatus.internalServerError: 'Internal Server Error',
    HttpStatus.notImplemented: 'Not Implemented',
    HttpStatus.badGateway: 'Bad Gateway',
    HttpStatus.serviceUnavailable: 'Service Unavailable',
    HttpStatus.gatewayTimeout: 'Gateway Timeout',
  };

  static String getMessage(int code) {
    return messages[code] ?? 'Unknown Status Code: $code';
  }

  static bool isSuccess(int code) => code >= 200 && code < 300;
  static bool isClientError(int code) => code >= 400 && code < 500;
  static bool isServerError(int code) => code >= 500 && code < 600;
  static bool isRedirect(int code) => code >= 300 && code < 400;
}
