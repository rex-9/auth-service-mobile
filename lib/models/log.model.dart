// lib/models/log.model.dart

class LogModel {
  final String message;
  final String severity;
  final String platform;
  final String environment;
  final String appVersion;
  final String os;
  final String osVersion;
  final String device;
  final String url;
  final String method;
  final List<String> stackTrace;
  final List<String> localStorageKeys;
  final Map<String, dynamic> context;

  LogModel({
    required this.message,
    this.severity = 'error',
    required this.platform,
    required this.environment,
    required this.appVersion,
    required this.os,
    required this.osVersion,
    required this.device,
    required this.url,
    this.method = 'APP_EVENT',
    this.stackTrace = const [],
    this.localStorageKeys = const [],
    this.context = const {},
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'severity': severity,
        'platform': platform,
        'environment': environment,
        'app_version': appVersion,
        'os': os,
        'os_version': osVersion,
        'device': device,
        'url': url,
        'method': method,
        'stack_trace': stackTrace,
        'local_storage_keys': localStorageKeys,
        'context': context,
      };
}
