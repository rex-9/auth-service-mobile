// lib/config/app_config.dart

import 'package:meritbox_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  // ===== APP INFO =====
  String get appName =>
      String.fromEnvironment(Constants.app.nameKey, defaultValue: 'Meritbox');
  String get appVersion =>
      String.fromEnvironment(Constants.app.versionKey, defaultValue: '1.0.0');

  // ===== ENVIRONMENT =====
  String get apiBaseUrlKey =>
      String.fromEnvironment(Constants.app.apiBaseUrlKey);

  String get googleServerClientIdKey =>
      String.fromEnvironment(Constants.app.googleServerClientIdKey);
}
