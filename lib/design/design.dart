// Export Components, Constants and Extensions
export 'package:rexone_mobile/design/constants/constants.dart';
export 'package:rexone_mobile/design/extensions/extensions.dart';
export 'package:rexone_mobile/design/components/components.dart';

import 'package:rexone_mobile/design/elements/elements.dart';

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
