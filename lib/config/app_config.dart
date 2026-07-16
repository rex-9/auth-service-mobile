// lib/config/app_config.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meritbox_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  // ===== ENVIRONMENT VARIABLES =====
  static String get appEnv =>
      String.fromEnvironment(Constants.app.envKey, defaultValue: '.env.dev');
  static String get appName => dotenv.env[Constants.app.nameKey] ?? 'Meritbox';
  static String get appVersion =>
      dotenv.env[Constants.app.versionKey] ?? '1.0.0';
  static String get apiBaseUrl =>
      dotenv.env[Constants.app.apiBaseUrlKey] ?? 'api base url not found';
  static String get googleServerClientId =>
      dotenv.env[Constants.app.googleServerClientIdKey] ??
      'google server client id not found';
}
