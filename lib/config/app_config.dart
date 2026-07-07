// lib/config/app_config.dart

import 'package:meritbox_mobile/constants/constants.dart';

class AppConfig {
  static const apiBaseUrl = String.fromEnvironment(AppConstants.apiBaseUrl);

  static const googleServerClientId = String.fromEnvironment(
    AppConstants.googleServerClientId,
  );
}
