// lib/models/log.model.dart
import 'package:rexone_mobile/constants/constants.dart';

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
        LogKeys.message: message,
        LogKeys.severity: severity,
        LogKeys.platform: platform,
        LogKeys.environment: environment,
        LogKeys.appVersion: appVersion,
        LogKeys.os: os,
        LogKeys.osVersion: osVersion,
        LogKeys.device: device,
        LogKeys.url: url,
        LogKeys.method: method,
        LogKeys.stackTrace: stackTrace,
        LogKeys.localStorageKeys: localStorageKeys,
        LogKeys.context: context,
      };
}
