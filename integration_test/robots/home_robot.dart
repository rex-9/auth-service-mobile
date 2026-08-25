import 'package:patrol_finders/patrol_finders.dart';
import 'package:rexone_mobile/design/components/app_button.dart';
import 'package:rexone_mobile/modules/home/pages/home.page.dart';

class HomeRobot {
  const HomeRobot(this.$);

  final PatrolTester $;

  Future<void> verifyIsVisible() async {
    await $(HomePage).waitUntilVisible();
  }

  Future<void> tapSignOut() async {
    await $(AppButton).containing('Sign Out').tap();
  }
}
