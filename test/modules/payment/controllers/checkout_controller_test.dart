// test/modules/payment/controllers/checkout_controller_test.dart
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/modules/payment/controllers/checkout.controller.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class FakePlatformWebViewController extends PlatformWebViewController {
  FakePlatformWebViewController(super.params) : super.implementation();

  Uri? loadedUri;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(PlatformNavigationDelegate handler) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    loadedUri = params.uri;
  }
}

class FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  FakePlatformNavigationDelegate(super.params) : super.implementation();

  NavigationRequestCallback? navigationCallback;

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {}

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}

  @override
  Future<void> setOnWebResourceError(WebResourceErrorCallback onWebResourceError) async {}

  @override
  Future<void> setOnNavigationRequest(NavigationRequestCallback onNavigationRequest) async {
    navigationCallback = onNavigationRequest;
  }
}

class FakeWebViewPlatform extends WebViewPlatform {
  FakePlatformWebViewController? lastController;
  FakePlatformNavigationDelegate? lastDelegate;

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    lastController = FakePlatformWebViewController(params);
    return lastController!;
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    lastDelegate = FakePlatformNavigationDelegate(params);
    return lastDelegate!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeWebViewPlatform fakePlatform;

  setUp(() {
    Get.testMode = true;
    fakePlatform = FakeWebViewPlatform();
    WebViewPlatform.instance = fakePlatform;
  });

  tearDown(() {
    Get.reset();
  });

  group('CheckoutController', () {
    test('initializes with default isLoading true and loads url argument', () {
      Get.routing.args = {'url': 'https://checkout.stripe.com/pay/cs_test_123'};
      final controller = Get.put(CheckoutController());

      expect(controller.isLoading.value, isTrue);
      expect(fakePlatform.lastController?.loadedUri?.toString(),
          equals('https://checkout.stripe.com/pay/cs_test_123'));
    });

    test('navigation delegate prevents navigation to localhost success URL', () {
      Get.routing.args = {'url': 'https://checkout.stripe.com/pay/cs_test_123'};
      Get.put(CheckoutController());

      final callback = fakePlatform.lastDelegate?.navigationCallback;
      expect(callback, isNotNull);

      final decision = callback!(NavigationRequest(
        url: 'http://localhost:4000/payment/success',
        isMainFrame: true,
      ));

      expect(decision, equals(NavigationDecision.prevent));
    });

    test('navigation delegate allows normal checkout navigation', () {
      Get.routing.args = {'url': 'https://checkout.stripe.com/pay/cs_test_123'};
      Get.put(CheckoutController());

      final callback = fakePlatform.lastDelegate?.navigationCallback;
      expect(callback, isNotNull);

      final decision = callback!(NavigationRequest(
        url: 'https://checkout.stripe.com/3d-secure',
        isMainFrame: true,
      ));

      expect(decision, equals(NavigationDecision.navigate));
    });
  });
}
