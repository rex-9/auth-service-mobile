/// Mirrors web `src/AppConfig.tsx`.
///
/// Values can be overridden at build time with
/// `flutter run --dart-define=SERVER_BASE_URL=https://api.example.com`.
class AppConfig {
  AppConfig._();

  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue:
        '1026550055658-skeaoo2ipej0ntv2i5vtj3s7isgdhqg4.apps.googleusercontent.com',
  );

  static const String serverBaseUrl = String.fromEnvironment(
    'SERVER_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
