// Export Components and Extensions
export 'package:auth_service_mobile/design/extensions/extensions.dart';
export 'package:auth_service_mobile/design/components/components.dart';

import 'package:auth_service_mobile/design/elements/elements.dart';

class Design {
  Design._();

  static const colors = AppColors();
  static const typo = AppTypography();
  static const spacing = AppSpacing();
  static const styles = AppStyles();
  static const icons = AppIcons();
  static const media = AppMedia();
  static const timers = AppTimers();
  static const theme = AppTheme();
}
