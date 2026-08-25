import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:rexone_mobile/design/components/app_button.dart';

class SignInRobot {
  const SignInRobot(this.$);

  final PatrolTester $;

  Future<void> enterPassword(String password) async {
    await $(EditableText).enterText(password);
  }

  Future<void> tapSignIn() async {
    await $(AppButton).containing('Sign In').tap();
  }

  Future<void> tapForgotPassword() async {
    await $(AppButton).containing('Forgot passcode?').tap();
  }
}
