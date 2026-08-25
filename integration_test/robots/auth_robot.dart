import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:rexone_mobile/design/components/app_button.dart';

class AuthRobot {
  const AuthRobot(this.$);

  final PatrolTester $;

  Future<void> enterEmail(String email) async {
    await $(TextField).enterText(email);
  }

  Future<void> tapContinue() async {
    await $(AppButton).containing('Continue').tap();
  }

  Future<void> tapGoogle() async {
    await $(AppButton).containing('Google').tap();
  }
}
