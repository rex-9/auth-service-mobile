// lib/config/app_config.dart

import 'package:meritbox_mobile/constants/constants.dart';

class AppConfig {
  const AppConfig();

  String get apiBaseUrl => String.fromEnvironment(Constants.app.apiBaseUrlKey);

  String get googleServerClientId =>
      String.fromEnvironment(Constants.app.googleServerClientIdKey);
}
