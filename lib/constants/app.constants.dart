// lib/constants/app_constants.dart
import 'package:package_info_plus/package_info_plus.dart';

class AppConstants {
  const AppConstants();

  // ===== ENVIRONMENT KEYS =====
  String get envKey => 'APP_ENV';
  String get nameKey => 'APP_NAME';
  String get versionKey => 'APP_VERSION';
  String get apiBaseUrlKey => 'API_BASE_URL';
  String get googleServerClientIdKey => 'GOOGLE_SERVER_CLIENT_ID';
  String get oneSignalAppIdKey => 'ONE_SIGNAL_APP_ID';
  String get androidAppIdKey => 'ANDROID_APP_ID';
  String get iosAppIdKey => 'IOS_APP_ID';

  // ===== VERSIONS from pubspec.yaml (Runtime) =====
  Future<String> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String> getFullVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

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

  // HTTP Headers
  static const headerContentType = 'Content-Type';
  static const headerAccept = 'Accept';
  static const headerAuthorization = 'Authorization';
  static const headerXPlatform = 'X-Platform';
  static const headerXLocale = 'X-Locale';
  static const headerAcceptLanguage = 'Accept-Language';
  static const contentTypeJson = 'application/json';
  static const platformMobile = 'mobile';
  static const bearerPrefix = 'Bearer ';
}
