// lib/config/app.config.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rexone_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  // ===== ENVIRONMENT VARIABLES =====
  /// Raw env key injected at build time via --dart-define (e.g. ".env.dev").
  static String get appEnv =>
      String.fromEnvironment(Constants.app.envKey, defaultValue: '.env.dev');

  /// Canonical environment name expected by the backend: development | staging | production.
  static String get environment => switch (appEnv) {
    '.env.dev' => 'development',
    '.env.uat' => 'staging',
    '.env.prod' => 'production',
    _ => 'development',
  };
  static String get appName => dotenv.env[Constants.app.nameKey] ?? 'Rexone';
  static String get appVersion =>
      dotenv.env[Constants.app.versionKey] ?? '1.0.0';
  static String get apiBaseUrl =>
      dotenv.env[Constants.app.apiBaseUrlKey] ?? 'api base url not found';
  static String get wsBaseUrl {
    final api = apiBaseUrl;
    if (api.startsWith('https://')) {
      return api.replaceFirst('https://', 'wss://');
    } else if (api.startsWith('http://')) {
      return api.replaceFirst('http://', 'ws://');
    }
    return 'ws://$api';
  }

  static String get googleServerClientId =>
      dotenv.env[Constants.app.googleServerClientIdKey] ??
      'google server client id not found';

  static String get oneSignalAppId =>
      dotenv.env[Constants.app.oneSignalAppIdKey] ??
      'one signal app id not found';

  static String get androidAppId =>
      dotenv.env[Constants.app.androidAppIdKey] ?? 'com.rexone.mobile';

  static String get iosAppId =>
      dotenv.env[Constants.app.iosAppIdKey] ?? 'com.rexone.mobile';
}
