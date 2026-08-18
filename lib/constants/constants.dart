export 'http_status.dart';
export 'enums.dart';

import 'analytics.constants.dart';
import 'app.constants.dart';
import 'locale.constants.dart';

class Constants {
  Constants._(); // Private constructor - never instantiate

  static const app = AppConstants();
  static const locale = LocaleConstants();
  static const analytics = AnalyticsConstants();
}
