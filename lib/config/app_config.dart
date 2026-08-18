// lib/config/app_config.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rexone_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  // ===== ENVIRONMENT VARIABLES =====
  /// Raw env key injected at build time via --dart-define (e.g. ".env.dev").
  String get appEnv =>
      String.fromEnvironment(Constants.app.envKey, defaultValue: '.env.dev');

  /// Canonical environment name expected by the backend: development | staging | production.
  String get environment => switch (appEnv) {
    '.env.dev' => 'development',
    '.env.uat' => 'staging',
    '.env.prod' => 'production',
    _ => 'development',
  };
  String get appName => dotenv.env[Constants.app.nameKey] ?? 'Rexone';
  String get appVersion => dotenv.env[Constants.app.versionKey] ?? '1.0.0';
  String get apiBaseUrl =>
      dotenv.env[Constants.app.apiBaseUrlKey] ?? 'api base url not found';
  String get wsBaseUrl {
    final api = apiBaseUrl;
    if (api.startsWith('https://')) {
      return api.replaceFirst('https://', 'wss://');
    } else if (api.startsWith('http://')) {
      return api.replaceFirst('http://', 'ws://');
    }
    return 'ws://$api';
  }

  String get googleServerClientId =>
      dotenv.env[Constants.app.googleServerClientIdKey] ??
      'google server client id not found';
}
