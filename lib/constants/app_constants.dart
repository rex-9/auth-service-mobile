// lib/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'Meritbox';
  static const String appVersion = '1.0.0';

  // Validation Rules
  static const int minPasscodeLength = 6;
  static const int maxPasscodeLength = 6;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Timeouts
  static const int apiTimeoutSeconds = 30;
  static const int verificationCodeExpirySeconds = 600; // 10 minutes

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUserEmail = 'user_email';
  static const String storageKeyUserData = 'user_data';
}
