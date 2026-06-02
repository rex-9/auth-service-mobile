// lib/routes/app_routes.dart
import 'package:get/get.dart';
import '../pages/auth_page.dart';
import '../pages/signin_passcode_page.dart';
import '../pages/signup_passcode_page.dart';
import '../pages/signup_info_page.dart';
import '../pages/splash_page.dart';
import '../pages/verify_email_page.dart';

class AppRoutes {
  // Client Routes (Navigation)
  static const String splash = '/splash';
  static const String auth = '/';
  static const String signinPasscode = '/signin-passcode';
  static const String signupPasscode = '/signup-passcode';
  static const String signupInfo = '/signup-info';
  static const String verifyEmail = '/verify-email';
  static const String home = '/home';

  // Navigation methods
  static void toSplash() => Get.offAllNamed(splash);
  static void toAuth() => Get.offAllNamed(auth);
  static void toSignInPasscode() => Get.toNamed(signinPasscode);
  static void toSignUpPasscode() => Get.toNamed(signupPasscode);
  static void toSignUpInfo({Map<String, dynamic>? arguments}) =>
      Get.toNamed(signupInfo, arguments: arguments);
  static void toVerifyEmail({Map<String, dynamic>? arguments}) =>
      Get.toNamed(verifyEmail, arguments: arguments);
  static void toHome() => Get.offAllNamed(home);

  static final pages = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: auth, page: () => const AuthPage()),
    GetPage(name: signinPasscode, page: () => const SignInPasscodePage()),
    GetPage(name: signupPasscode, page: () => const SignUpPasscodePage()),
    GetPage(name: signupInfo, page: () => const SignUpInfoPage()),
    GetPage(name: verifyEmail, page: () => const VerifyEmailPage()),
  ];
}
