import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:rexone_mobile/design/components/app_button.dart';

class SignUpRobot {
  const SignUpRobot(this.$);

  final PatrolTester $;

  Future<void> enterPasscodeCreate(String passcode) async {
    await $(EditableText).at(0).enterText(passcode);
  }

  Future<void> enterPasscodeConfirm(String passcode) async {
    await $(EditableText).at(0).enterText(passcode);
  }

  Future<void> enterCreatePasscode(String passcode) async {
    await enterPasscodeCreate(passcode);
  }

  Future<void> enterConfirmPasscode(String passcode) async {
    await enterPasscodeConfirm(passcode);
  }

  Future<void> tapConfirmPasscode() async {
    await $(AppButton).containing('Confirm').tap();
  }

  Future<void> enterName(String name) async {
    await $(TextField).at(0).enterText(name);
  }

  Future<void> enterFullName(String name) async {
    await enterName(name);
  }

  Future<void> enterUsername(String username) async {
    await $(TextField).at(1).enterText(username);
  }

  Future<void> tapCreateAccount() async {
    await $(AppButton).containing('Create Account').tap();
  }
}
