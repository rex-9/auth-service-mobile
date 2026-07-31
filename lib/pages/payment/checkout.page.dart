import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:auth_service_mobile/constants/constants.dart';
import 'package:auth_service_mobile/design/design.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final WebViewController _controller;
  late final String _checkoutUrl;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _checkoutUrl = args['checkout_url'] as String? ?? '';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      );

    if (_checkoutUrl.isNotEmpty) {
      _controller.loadRequest(Uri.parse(_checkoutUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: Constants.locale.checkout.tr,
      showBackButton: true,
      padding: EdgeInsets.zero,
      child: _checkoutUrl.isEmpty
          ? Center(
              child: Text(
                Constants.locale.checkError.tr,
                style: context.typo.bodyMedium.copyWith(
                  color: context.colors.error,
                ),
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
    );
  }
}
