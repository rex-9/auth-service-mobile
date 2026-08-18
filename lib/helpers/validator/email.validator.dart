import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/helpers/validator/validator.dart';

class EmailValidator implements Validator<String> {
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  String? validate(String input) {
    final email = input.trim();
    if (email.isEmpty) return Constants.locale.invalidEmail.tr;
    if (!emailRegex.hasMatch(email)) {
      return Constants.locale.invalidEmail.tr;
    }
    return null;
  }
}
