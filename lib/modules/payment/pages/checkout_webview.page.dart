// lib/modules/payment/pages/checkout_webview_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../payment.dart';

/// Full-screen in-app WebView for Stripe checkout.
///
/// Forces the light theme so the Stripe-hosted page (which is always white)
/// doesn't clash with a dark app theme.  Keeps Flutter in the foreground so
/// the WebSocket stays alive.  All state and platform logic lives in
/// [CheckoutController].
class CheckoutWebViewPage extends GetView<CheckoutController> {
  const CheckoutWebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Force light theme for the entire checkout subtree — Stripe's page is
    // always white and looks broken inside a dark-themed shell.
    return Theme(
      data: Design.theme.light,
      child: Builder(
        builder: (themeContext) {
          final colors = themeContext.colors;
          final typo = themeContext.typo;

          return Scaffold(
            backgroundColor: colors.background,
            appBar: AppBar(
              backgroundColor: colors.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text('Checkout', style: typo.labelLarge),
              leading: IconButton(
                icon: Icon(Design.icons.close, color: colors.textPrimary),
                onPressed: Get.back,
                tooltip: 'Close',
              ),
            ),
            body: Obx(
              () => Stack(
                children: [
                  WebViewWidget(controller: controller.webController),
                  if (controller.isLoading.value)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
