import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/design/design.dart';

import '../controllers/splash.controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      backgroundColor: context.colors.background,
      child: const Center(
        child: AppLoading(type: LoadingType.pulse, size: LoadingSize.xlarge),
      ),
    );
  }
}
