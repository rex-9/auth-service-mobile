// Auth flow tests: translations completeness, settings persistence,
// and app boot / auth page smoke tests.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:meritbox_mobile/bindings/initial_binding.dart';
import 'package:meritbox_mobile/controllers/settings_controller.dart';
import 'package:meritbox_mobile/locales/app_translations.dart';
import 'package:meritbox_mobile/main.dart';

/// get_storage resolves its file location through path_provider, which has
/// no platform implementation under `flutter test` — point it at a temp dir.
class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);
  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('meritbox_test');
    PathProviderPlatform.instance = _FakePathProvider(dir.path);
    await GetStorage.init();
  });

  setUp(() async {
    await GetStorage().erase();
    Get.reset();
    InitialBinding().dependencies();
  });

  group('AppTranslations', () {
    test('all locales define the same keys', () {
      final translations = AppTranslations().keys;
      final enKeys = translations['en_US']!.keys.toSet();

      for (final locale in AppTranslations.supportedLocales.keys) {
        expect(
          translations[locale]!.keys.toSet(),
          enKeys,
          reason: '$locale should define the same keys as en_US',
        );
      }
    });

    test('parameterized keys keep their placeholders in every locale', () {
      final translations = AppTranslations().keys;
      const paramKeys = {
        'signin_subtitle': '@email',
        'verify_email_subtitle': '@email',
        'attempts_remaining': '@left',
        'cooldown_message': '@seconds',
        'try_again_in': '@seconds',
        'resend_code_in': '@seconds',
        'google_too_many_attempts': '@seconds',
      };

      for (final locale in AppTranslations.supportedLocales.keys) {
        paramKeys.forEach((key, placeholder) {
          expect(
            translations[locale]![key],
            contains(placeholder),
            reason: '$locale.$key should contain $placeholder',
          );
        });
      }
    });
  });

  group('SettingsController', () {
    testWidgets('cycles theme auto -> day -> night and persists', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      final settings = Get.find<SettingsController>();

      expect(settings.themeName.value, 'auto');
      expect(settings.themeMode, ThemeMode.system);

      settings.cycleTheme();
      expect(settings.themeName.value, 'day');
      expect(settings.themeMode, ThemeMode.light);

      settings.cycleTheme();
      expect(settings.themeName.value, 'night');
      expect(settings.themeMode, ThemeMode.dark);

      settings.cycleTheme();
      expect(settings.themeName.value, 'auto');
    });

    testWidgets('changes and persists locale', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      final settings = Get.find<SettingsController>();

      expect(settings.localeCode.value, 'en_US');
      settings.changeLocale('my_MM');
      await tester.pumpAndSettle();
      expect(settings.locale, const Locale('my', 'MM'));

      // A fresh controller reads the persisted value back.
      final reloaded = SettingsController();
      reloaded.onInit();
      expect(reloaded.localeCode.value, 'my_MM');
    });
  });

  group('App smoke tests', () {
    testWidgets('boots to the auth page when signed out', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      expect(find.text('✨ Welcome to Meritbox ✨'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('rejects an invalid email inline', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'not-an-email');
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(
        find.text(
          'Please enter a valid email address. (e.g. example@domain.com)',
        ),
        findsOneWidget,
      );
    });

    testWidgets('switching locale translates the auth page', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      Get.find<SettingsController>().changeLocale('es_ES');
      await tester.pumpAndSettle();

      expect(find.text('✨ Bienvenido a Meritbox ✨'), findsOneWidget);
      expect(find.text('Continuar con Google'), findsOneWidget);
    });
  });
}
