// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meritbox_mobile/config/config.dart';
import 'package:meritbox_mobile/design/design.dart';
import 'package:meritbox_mobile/routes/routes.dart';
import 'package:meritbox_mobile/controllers/controllers.dart';
import 'bindings/initial_binding.dart';
import 'locales/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: AppConfig.appEnv);
  await GetStorage.init();
  InitialBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // DEBUG: Test ENV...
    // print('APP_NAME: ${AppConfig.appName}');
    // print('APP_VERSION: ${AppConfig.appVersion}');
    // print('API_BASE_URL: ${AppConfig.apiBaseUrl}');
    // print('GOOGLE_CLIENT_ID: ${AppConfig.googleServerClientId}');

    return GetBuilder<SettingsController>(
      builder: (settings) => ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => GetMaterialApp(
          title: AppConfig.appName,
          theme: Design.theme.light,
          darkTheme: Design.theme.dark,
          themeMode: settings.themeMode,
          translations: AppTranslations(),
          locale: settings.locale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          getPages: AppRoutes.pages,
        ),
      ),
    );
  }
}
