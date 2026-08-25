import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:rexone_mobile/design/components/app_button.dart';

class SignInRobot {
  const SignInRobot(this.$);

  final PatrolTester $;

  Future<void> enterPasscode(String passcode) async {
    await $(EditableText).enterText(passcode);
  }

  Future<void> tapSignIn() async {
    await $(AppButton).containing('Sign In').tap();
  }

  Future<void> tapForgotPasscode() async {
    await $(AppButton).containing('Forgot passcode?').tap();
  }
}
