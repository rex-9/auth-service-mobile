export 'http_status.dart';
export 'enums.dart';

import 'app.constants.dart';
import 'locale.constants.dart';
import 'analytics.constants.dart';

class Constants {
  Constants._(); // Private constructor - never instantiate

  // ===== APP =====
  static const app = AppConstants();

  // ===== LOCALE =====
  static const locale = LocaleConstants();

  // ===== ANALYTICS =====
  static const analytics = AnalyticsConstants();
}
