// lib/main.dart
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rexone_mobile/config/config.dart';
import 'package:rexone_mobile/controllers/controllers.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/services.dart';
import 'package:upgrader/upgrader.dart';
import 'bindings/initial_binding.dart';
import 'locales/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Telemetry & Error Listeners ("It works on my machine" killer)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    LogService.reportFlutterError(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    LogService.reportPlatformError(error, stack);
    return true;
  };

  await dotenv.load(fileName: AppConfig.appEnv);
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('⚠️ Firebase initializeApp skipped or failed: $e');
  }
  await GetStorage.init();
  InitialBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = Get.find<AnalyticsService>();

    // DEBUG: Test ENV...
    // print('APP_NAME: ${AppConfig.appName}');
    // print('APP_VERSION: ${AppConfig.appVersion}');
    // print('API_BASE_URL: ${AppConfig.apiBaseUrl}');
    // print('GOOGLE_CLIENT_ID: ${AppConfig.googleServerClientId}');
    // print('ONE_SIGNAL_APP_ID: ${AppConfig.oneSignalAppId}');
    // print('APP_STORE_APP_ID: ${AppConfig.appStoreAppId}');
    // print('APP_STORE_BUNDLE_ID: ${AppConfig.appStoreBundleId}');

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
          navigatorObservers: [analytics.observer],
          builder: (context, child) {
            return UpgradeAlert(
              upgrader: Upgrader(
                debugLogging: AppConfig.appEnv == '.env.dev',
                debugDisplayAlways: false,
                durationUntilAlertAgain: const Duration(days: 3),
              ),
              dialogStyle: UpgradeDialogStyle.material,
              child: AppLoading.builder(context, child),
            );
          },
        ),
      ),
    );
  }
}
