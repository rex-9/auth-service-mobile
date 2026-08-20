// lib/constants/analytics_constants.dart

class AnalyticsConstants {
  const AnalyticsConstants._();

  // ===== EVENT NAMES =====
  static const String eventSignUp = 'sign_up';
  static const String eventSignIn = 'sign_in';
  static const String eventSignOut = 'sign_out';
  static const String eventPasswordReset = 'password_reset_requested';
  static const String eventOnboardingStarted = 'onboarding_started';
  static const String eventOnboardingCompleted = 'onboarding_completed';
  static const String eventEmailVerified = 'email_verified';
  static const String eventAppOpen = 'app_open';
  static const String eventAppBackground = 'app_background';
  static const String eventAppError = 'app_error';
  static const String eventPushReceived = 'push_received';
  static const String eventPushOpened = 'push_opened';
  static const String eventPerformance = 'performance';

  // ===== PARAMETER NAMES =====
  static const String paramMethod = 'method';
  static const String paramError = 'error';
  static const String paramContext = 'context';
  static const String paramMetric = 'metric';
  static const String paramValue = 'value';

  // ===== PARAMETER VALUES =====
  static const String methodEmail = 'email';
  static const String methodGoogle = 'google';
  static const String methodApple = 'apple';
}
