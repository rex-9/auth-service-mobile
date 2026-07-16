// lib/routes/app_routes.dart
import 'package:get/get.dart';
import 'package:meritbox_mobile/pages/pages.dart';
import 'package:meritbox_mobile/routes/route_guard.dart';

class AppRoutes {
  // ===== PUBLIC ROUTES (No Auth Required) =====
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String signinPasscode = '/signin-passcode';
  static const String signupPasscodeCreate = '/signup-passcode-create';
  static const String signupPasscodeConfirm = '/signup-passcode-confirm';
  static const String signupInfo = '/signup-info';
  static const String confirmEmail = '/confirm-email';
  static const String forgotPasscode = '/forgot-passcode';

  // ===== PROTECTED ROUTES (Auth Required) =====
  static const String home = '/home';
  static const String settings = '/settings';

  // ===== PUBLIC NAVIGATION =====
  static void toSplash() => Get.offAllNamed(splash);
  static void toAuth() => Get.offAllNamed(auth);
  static void toSignInPasscode() => Get.toNamed(signinPasscode);
  static void toSignUpPasscodeCreate() => Get.toNamed(signupPasscodeCreate);
  static void toSignUpPasscodeConfirm() => Get.toNamed(signupPasscodeConfirm);
  static void toSignUpInfo({
    required String email,
    required String passcode,
    required String confirmPasscode,
  }) {
    Get.toNamed(
      signupInfo,
      arguments: {
        'email': email,
        'passcode': passcode,
        'confirm_passcode': confirmPasscode,
      },
    );
  }

  static void toConfirmEmail({required String email}) {
    Get.toNamed(confirmEmail, arguments: {'email': email});
  }

  static void toForgotPasscode() => Get.toNamed(forgotPasscode);

  // ===== PROTECTED NAVIGATION =====
  static void toHome() => Get.offAllNamed(home);
  static void toSettings() => Get.toNamed(settings);

  static final pages = [
    // Public Pages
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: auth, page: () => AuthPage()),
    GetPage(name: signinPasscode, page: () => const SignInPasscodePage()),
    GetPage(
      name: signupPasscodeCreate,
      page: () => const SignUpPasscodeCreatePage(),
    ),
    GetPage(
      name: signupPasscodeConfirm,
      page: () => const SignUpPasscodeConfirmPage(),
    ),
    GetPage(name: signupInfo, page: () => const SignUpInfoPage()),
    GetPage(name: confirmEmail, page: () => const ConfirmEmailPage()),
    GetPage(name: forgotPasscode, page: () => const ForgotPasscodePage()),

    // Protected Pages
    GetPage(
      name: home,
      page: () => const HomePage(),
      middlewares: [RouteGuard()],
    ),
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
      middlewares: [RouteGuard()],
    ),
  ];
}
