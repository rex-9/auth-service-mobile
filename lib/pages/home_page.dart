// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/controllers/controllers.dart';
import 'package:rexone_mobile/routes/app_routes.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: Constants.locale.home.tr,
      actions: [
        AppButton(
          type: ButtonType.icon,
          icon: Design.icons.settings,
          onPressed: () => AppRoutes.toSettings(),
          tooltip: Constants.locale.settings.tr,
        ),
      ],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Constants.locale.welcomeHome.tr,
              style: context.typo.headline1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Design.spacing.lg),
            Obx(
              () => Column(
                children: [
                  // User photo if available
                  if (controller.currentUser.value?.photo != null)
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        controller.currentUser.value!.photo!,
                      ),
                    ),
                  SizedBox(height: Design.spacing.md),
                  Text(
                    controller.currentUser.value?.name ??
                        controller.currentUser.value?.username ??
                        controller.currentUser.value?.email ??
                        Constants.locale.loading.tr,
                    style: context.typo.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Design.spacing.xs),
                  Text(
                    controller.currentUser.value?.email ??
                        Constants.locale.loading.tr,
                    style: context.typo.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
