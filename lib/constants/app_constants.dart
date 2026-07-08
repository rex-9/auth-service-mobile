// lib/constants/app_constants.dart
class AppConstants {
  const AppConstants();

  // App Info
  String get appName => 'Meritbox';
  String get appVersion => '1.0.0';

  // Validation Rules
  int get minPasscodeLength => 6;
  int get maxPasscodeLength => 6;
  int get minUsernameLength => 3;
  int get maxUsernameLength => 20;
  int get minNameLength => 2;
  int get maxNameLength => 50;

  // Storage Keys
  String get storageKeyToken => 'auth_token';
  String get storageKeyUserEmail => 'user_email';
  String get storageKeyUserData => 'user_data';

  // Config Keys
  String get googleServerClientIdKey => "GOOGLE_SERVER_CLIENT_ID";
  String get apiBaseUrlKey => "API_BASE_URL";
}
