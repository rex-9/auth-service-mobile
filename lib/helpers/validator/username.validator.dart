import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:auth_service_mobile/helpers/validator/validator.dart';

import '../../constants/constants.dart';

class UsernameValidator implements Validator {
  static final _usernameRegex = RegExp(r'^[a-z0-9_]+$');

  @override
  String? validate(input) {
    if (input.length < 3) {
      return Constants.locale.usernameMinLength.tr;
    }
    if (!_usernameRegex.hasMatch(input)) {
      return Constants.locale.usernameCharset.tr;
    }
    return null; // valid
  }
}
