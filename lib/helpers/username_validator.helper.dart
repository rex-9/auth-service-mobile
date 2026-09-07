import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';

class FullnameValidator {
  const FullnameValidator._();

  static final _forbiddenPattern = RegExp(r'[<>:;?]');

  static String? error(String name) {
    final trimmed = name.trim();
    if (trimmed.length < AppConstants.minNameLength) {
      return AppLocales.auth.signUpInfo.enterFullName.tr;
    }
    if (trimmed.length > AppConstants.maxNameLength) {
      return AppLocales.auth.signUpInfo.fullNameMaxLength.tr;
    }
    if (_forbiddenPattern.hasMatch(trimmed)) {
      return AppLocales.auth.signUpInfo.fullNameForbiddenChars.tr;
    }
    return null;
  }
}

class UsernameValidator {
  const UsernameValidator._();

  static final pattern = RegExp(r'^[a-z0-9_]+$');

  static String? error(String username) {
    final value = username.trim().toLowerCase();
    if (value.length < AppConstants.minUsernameLength) {
      return AppLocales.auth.signUpInfo.usernameMinLength.tr;
    }
    if (value.length > AppConstants.maxUsernameLength) {
      return AppLocales.auth.signUpInfo.usernameMaxLength.tr;
    }
    if (!pattern.hasMatch(value)) {
      return AppLocales.auth.signUpInfo.usernameCharset.tr;
    }
    return null;
  }
}
