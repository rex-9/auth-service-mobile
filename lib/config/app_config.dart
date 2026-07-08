// lib/config/app_config.dart

import 'package:meritbox_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  String get apiBaseUrlKey =>
      String.fromEnvironment(Constants.app.apiBaseUrlKey);

  String get googleServerClientIdKey =>
      String.fromEnvironment(Constants.app.googleServerClientIdKey);
}
