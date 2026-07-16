import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:meritbox_mobile/helpers/validator/validator.dart';

import '../../constants/constants.dart';

class FullnameValidator implements Validator {
  @override
  String? validate(input) {
    if (input.trim().length < 2) {
      return Constants.locale.enterFullName.tr;
    }
    return null;
  }
}
