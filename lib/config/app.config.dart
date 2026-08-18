// lib/config/app_config.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rexone_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  // ===== ENVIRONMENT VARIABLES =====
  static String get appEnv =>
      String.fromEnvironment(Constants.app.envKey, defaultValue: '.env.dev');
  static String get appName =>
      dotenv.env[Constants.app.nameKey] ?? 'Auth Service';
  static String get appVersion =>
      dotenv.env[Constants.app.versionKey] ?? '1.0.0';
  static String get apiBaseUrl =>
      dotenv.env[Constants.app.apiBaseUrlKey] ?? 'api base url not found';
  static String get googleServerClientId =>
      dotenv.env[Constants.app.googleServerClientIdKey] ??
      'google server client id not found';
  static String get oneSignalAppId =>
      dotenv.env[Constants.app.oneSignalAppId] ?? 'one signal app id not found';
  static String get androidAppId =>
      dotenv.env[Constants.app.androidAppId] ?? 'app store bundle id not found';
  static String get iosAppId =>
      dotenv.env[Constants.app.iosAppId] ?? 'app store app id not found';
}
