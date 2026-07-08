// lib/design/app_spacing.dart

class AppSpacing {
  const AppSpacing();

  // Base unit: 4px
  double get xs => 4.0; // 4px
  double get sm => 8.0; // 8px
  double get md => 12.0; // 12px
  double get lg => 16.0; // 16px
  double get xl => 20.0; // 20px
  double get xxl => 24.0; // 24px
  double get xxxl => 32.0; // 32px

  // Screen padding
  double get screenPadding => 20.0;
  double get screenPaddingSmall => 16.0;

  // Card padding
  double get cardPadding => 16.0;
  double get cardPaddingSmall => 12.0;

  // Button padding
  double get buttonVertical => 12.0;
  double get buttonHorizontal => 24.0;
  double get buttonHeight => 48.0;
  double get buttonSmallHeight => 40.0;

  // Input padding
  double get inputVertical => 14.0;
  double get inputHorizontal => 16.0;

  // Border radius
  double get radiusSmall => 8.0;
  double get radiusMedium => 12.0;
  double get radiusLarge => 16.0;
  double get radiusXLarge => 24.0;

  // Icon sizes
  double get iconSmall => 16.0;
  double get iconMedium => 20.0;
  double get iconLarge => 24.0;
  double get iconXLarge => 32.0;
}
