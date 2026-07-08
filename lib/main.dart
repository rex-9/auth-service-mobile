// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meritbox_mobile/constants/constants.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/routes/app_routes.dart';
import 'bindings/initial_binding.dart';
import 'controllers/auth_controller.dart';
import 'controllers/settings_controller.dart';
import 'locales/app_translations.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  InitialBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settings) => ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => GetMaterialApp(
          title: Constants.app.name,
          theme: Design.theme.light,
          darkTheme: Design.theme.dark,
          themeMode: settings.themeMode,
          translations: AppTranslations(),
          locale: settings.locale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          getPages: AppRoutes.pages,
          home: Obx(() {
            final authController = Get.find<AuthController>();

            if (authController.isCheckingAuth.value) {
              return const SplashPage();
            }

            if (authController.isLoggedIn.value) {
              return const HomePage();
            }

            return const AuthPage();
          }),
        ),
      ),
    );
  }
}
