export 'http_status.dart';
export 'enums.dart';

import 'app.constants.dart';
import 'locale.constants.dart';

class Constants {
  Constants._(); // Private constructor - never instantiate

  // ===== COLORS =====
  static const app = AppConstants();

  // ===== TYPOGRAPHY =====
  static const locale = LocaleConstants();
}
