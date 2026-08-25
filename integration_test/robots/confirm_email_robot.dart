import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:rexone_mobile/design/components/app_button.dart';

class ConfirmEmailRobot {
  const ConfirmEmailRobot(this.$);

  final PatrolTester $;

  Future<void> enterOtp(String otp) async {
    await $(EditableText).enterText(otp);
  }

  Future<void> tapConfirm() async {
    await $(AppButton).containing('Confirm code').tap();
  }

  Future<void> verifyIsVisible() async {
    await $(EditableText).waitUntilVisible();
  }
}
