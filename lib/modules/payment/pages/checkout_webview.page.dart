// lib/modules/payment/pages/checkout_webview_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../payment.dart';

/// Full-screen in-app WebView for Stripe checkout.
///
/// Forces the light theme so the Stripe-hosted page (which is always white)
/// doesn't clash with a dark app theme. Keeps Flutter in the foreground so
/// the WebSocket stays alive.
class CheckoutWebViewPage extends GetView<CheckoutController> {
  const CheckoutWebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Design.theme.light,
      child: Builder(
        builder: (themeContext) {
          final colors = themeContext.colors;

          return AppPage(
            title: 'Checkout',
            showBackButton: false,
            padding: EdgeInsets.zero,
            backgroundColor: colors.background,
            actions: [
              AppButton(
                type: EButtonType.icon,
                icon: Design.icons.close,
                onPressed: Get.back,
              ),
            ],
            child: Obx(
              () => Stack(
                children: [
                  WebViewWidget(controller: controller.webController),
                  if (controller.isLoading.value)
                    const Center(child: AppLoading()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
