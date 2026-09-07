import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rexone_mobile/config/config.dart';
import 'package:rexone_mobile/services/services.dart';

class HomeController extends GetxController {
  final VersionService _version = Get.find<VersionService>();

  @override
  void onInit() {
    super.onInit();
    if (Get.testMode) return;
    reportUserVersion();
  }

  Future<void> reportUserVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version.isNotEmpty
          ? info.version
          : AppConfig.appVersion;
      final versionCode = int.tryParse(info.buildNumber) ?? 0;
      await _version.reportUserVersion(
        version: version,
        versionCode: versionCode,
      );
    } catch (error) {
      debugPrint('Error: $error');
    }
  }
}
