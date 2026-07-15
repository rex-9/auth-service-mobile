// lib/routes/server_routes.dart
class ServerRoutes {
  // Base URL - Change for production
  // For Android Emulator - use 10.0.2.2 to reach host machine
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Users Endpoints
  static const String peekUser = '/users/peek';
  static const String currentUser = '/users/current';

  // Sessions Endpoints
  static const String signIn = '/signin';
  static const String signInWithToken = '/signin/token';
  static const String signInWithGoogle = '/signin/google';
  static const String signInGoogleComplete = '/signin/google/complete';
  static const String signOut = '/signout';

  // Registration Endpoint
  static const String signUp = '/signup';

  // Confirmation Endpoints
  static const String sendConfirmationCode = '/confirmation/send_code';
  static const String confirmCode = '/confirmation/confirm_code';

  // Password Endpoints
  static const String forgotPassword = '/password/forgot';
  static const String resetPassword = '/password/reset';
}
