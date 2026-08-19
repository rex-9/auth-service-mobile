// lib/modules/payment/services/payment.service.dart
import 'package:get/get.dart';
import 'package:rexone_mobile/helpers/helpers.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/api.service.dart';

class PaymentService extends GetxService {
  late final ApiService _api;

  @override
  void onInit() {
    super.onInit();
    _api = Get.find<ApiService>();
  }

  // ============================================================
  // PRODUCTS
  // ============================================================
  Future<ApiResponse<List<ProductModel>>> getProducts() async {
    final response = await _api.get(ServerRoutes.paymentProducts);
    return _api.parseResponse<List<ProductModel>>(
      response,
      (data) => ApiHelper.parseList(data, ProductModel.fromJson),
    );
  }

  // ============================================================
  // SUBSCRIPTIONS
  // ============================================================
  Future<ApiResponse<List<SubscriptionModel>>> getSubscriptions() async {
    final response = await _api.get(ServerRoutes.paymentSubscriptions);
    return _api.parseResponse<List<SubscriptionModel>>(
      response,
      (data) => ApiHelper.parseList(data, SubscriptionModel.fromJson),
    );
  }

  Future<ApiResponse<dynamic>> cancelSubscription(String subscriptionId) async {
    final response = await _api.post(
      ServerRoutes.paymentSubscriptionCancel(subscriptionId),
      {},
    );
    return _api.parseResponse(response, (data) => data);
  }

  Future<ApiResponse<dynamic>> resumeSubscription(String subscriptionId) async {
    final response = await _api.post(
      ServerRoutes.paymentSubscriptionResume(subscriptionId),
      {},
    );
    return _api.parseResponse(response, (data) => data);
  }

  // ============================================================
  // TRANSACTIONS
  // ============================================================
  Future<ApiResponse<List<TransactionModel>>> getTransactions() async {
    final response = await _api.get(ServerRoutes.paymentTransactions);
    return _api.parseResponse<List<TransactionModel>>(
      response,
      (data) => ApiHelper.parseList(data, TransactionModel.fromJson),
    );
  }

  // ============================================================
  // CHECKOUT SESSION
  // ============================================================
  Future<ApiResponse<Map<String, dynamic>>> createCheckout(
    String productId, {
    String? successUrl,
    String? cancelUrl,
  }) async {
    final response = await _api.post(ServerRoutes.paymentSession, {
      'product_id': productId,
      'success_url': ?successUrl,
      'cancel_url': ?cancelUrl,
    });
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data is Map ? Map<String, dynamic>.from(data) : {},
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getSessionStatus(
    String sessionId,
  ) async {
    final response = await _api.get(
      ServerRoutes.paymentSessionStatus(sessionId),
    );
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data is Map ? Map<String, dynamic>.from(data) : {},
    );
  }
}
