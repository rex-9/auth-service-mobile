// lib/constants/analytics_constants.dart

class AnalyticsConstants {
  const AnalyticsConstants();

  // ===== EVENT NAMES =====
  String get eventSignUp => 'sign_up';
  String get eventSignIn => 'sign_in';
  String get eventSignOut => 'sign_out';
  String get eventPasswordReset => 'password_reset_requested';
  String get eventOnboardingStarted => 'onboarding_started';
  String get eventOnboardingCompleted => 'onboarding_completed';
  String get eventEmailVerified => 'email_verified';
  String get eventAppOpen => 'app_open';
  String get eventAppBackground => 'app_background';
  String get eventAppError => 'app_error';
  String get eventPushReceived => 'push_received';
  String get eventPushOpened => 'push_opened';
  String get eventPerformance => 'performance';

  // ===== PARAMETER NAMES =====
  String get paramMethod => 'method';
  String get paramError => 'error';
  String get paramContext => 'context';
  String get paramMetric => 'metric';
  String get paramValue => 'value';

  // ===== PARAMETER VALUES =====
  String get methodEmail => 'email';
  String get methodGoogle => 'google';
  String get methodApple => 'apple';
}
