// test/helpers/username_validator_test.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/helpers/username_validator.helper.dart';
import 'package:rexone_mobile/locales/app_translations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    Get.addTranslations(AppTranslations().keys);
    Get.locale = const Locale('en');
  });

  group('FullnameValidator', () {
    test('returns null for valid names', () {
      expect(FullnameValidator.error('John Doe'), isNull);
      expect(FullnameValidator.error('Al'), isNull);
      expect(FullnameValidator.error('A' * 50), isNull);
      expect(FullnameValidator.error('  Valid Name  '), isNull);
    });

    test('returns error when name is shorter than minNameLength', () {
      expect(
        FullnameValidator.error(''),
        equals(AppLocales.auth.signUpInfo.enterFullName.tr),
      );
      expect(
        FullnameValidator.error('   '),
        equals(AppLocales.auth.signUpInfo.enterFullName.tr),
      );
      expect(
        FullnameValidator.error('A'),
        equals(AppLocales.auth.signUpInfo.enterFullName.tr),
      );
    });

    test('returns error when name exceeds maxNameLength (50)', () {
      final longName = 'A' * 51;
      expect(
        FullnameValidator.error(longName),
        equals(AppLocales.auth.signUpInfo.fullNameMaxLength.tr),
      );
    });

    test('returns error when name contains forbidden characters (<, >, :, ;, ?)', () {
      for (final char in ['<', '>', ':', ';', '?']) {
        final invalidName = 'User${char}Name';
        expect(
          FullnameValidator.error(invalidName),
          equals(AppLocales.auth.signUpInfo.fullNameForbiddenChars.tr),
          reason: 'Character "$char" should be rejected',
        );
      }
    });
  });

  group('UsernameValidator', () {
    test('returns null for valid usernames', () {
      expect(UsernameValidator.error('john_doe'), isNull);
      expect(UsernameValidator.error('user123'), isNull);
      expect(UsernameValidator.error('abc'), isNull);
      expect(UsernameValidator.error('a' * 30), isNull);
      expect(UsernameValidator.error('  John_Doe  '), isNull);
    });

    test('returns error when username is shorter than minUsernameLength (3)', () {
      expect(
        UsernameValidator.error(''),
        equals(AppLocales.auth.signUpInfo.usernameMinLength.tr),
      );
      expect(
        UsernameValidator.error('   '),
        equals(AppLocales.auth.signUpInfo.usernameMinLength.tr),
      );
      expect(
        UsernameValidator.error('ab'),
        equals(AppLocales.auth.signUpInfo.usernameMinLength.tr),
      );
    });

    test('returns error when username exceeds maxUsernameLength (30)', () {
      final longUsername = 'a' * 31;
      expect(
        UsernameValidator.error(longUsername),
        equals(AppLocales.auth.signUpInfo.usernameMaxLength.tr),
      );
    });

    test('returns error when username contains invalid characters', () {
      final invalidUsernames = [
        'john-doe',
        'john space',
        'john@doe',
        'john.doe',
        'john#doe',
        'user!',
      ];

      for (final u in invalidUsernames) {
        expect(
          UsernameValidator.error(u),
          equals(AppLocales.auth.signUpInfo.usernameCharset.tr),
          reason: 'Username "$u" should be rejected',
        );
      }
    });
  });
}
