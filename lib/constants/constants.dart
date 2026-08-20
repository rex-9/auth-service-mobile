import 'app.constants.dart';
import 'locale.constants.dart';

export 'http_status.dart';
export 'enums.dart';
export 'json_keys.dart';
export 'log.constants.dart';
export 'analytics.constants.dart';
export 'app.constants.dart';
export 'locale.constants.dart';

class Constants {
  Constants._(); // Private constructor - never instantiate

  static const app = AppConstants();
  static const locale = LocaleConstants();
}
