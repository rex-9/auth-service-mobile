import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:rexone_mobile/design/components/app_button.dart';

class ForgotPasscodeRobot {
  const ForgotPasscodeRobot(this.$);

  final PatrolTester $;

  Future<void> enterEmail(String email) async {
    await $(TextField).enterText(email);
  }

  Future<void> tapSendReset() async {
    await $(AppButton).containing('Send').tap();
  }

  Future<void> tapSubmit() async {
    await tapSendReset();
  }
}
