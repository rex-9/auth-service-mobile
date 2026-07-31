import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth_service_mobile/design/design.dart';
import 'package:auth_service_mobile/models/models.dart';
import 'package:auth_service_mobile/routes/routes.dart';
import 'package:auth_service_mobile/services/services.dart';

class PaymentController extends GetxController {
  final PaymentService _payment = Get.find<PaymentService>();

  final plans = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isSubscribing = false.obs;
  final error = RxnString();
  final selectedPlanId = RxnString();

  ProductModel? get selectedPlan {
    final id = selectedPlanId.value;
    if (id == null) return null;
    return plans.firstWhereOrNull((plan) => plan.id == id);
  }

  void selectPlan(String id) => selectedPlanId.value = id;

  @override
  void onReady() {
    super.onReady();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    isLoading.value = true;
    error.value = null;

    final result = await _payment.fetchProducts();

    if (result.success && result.data != null) {
      plans.assignAll(result.data!.products);
      if (plans.isEmpty) {
        selectedPlanId.value = null;
      }
    } else {
      error.value = result.message;
      plans.clear();
      selectedPlanId.value = null;
    }

    isLoading.value = false;
  }

  Future<void> subscribe(BuildContext context) async {
    final plan = selectedPlan;
    if (plan == null || isSubscribing.value) return;

    isSubscribing.value = true;
    try {
      final result = await _payment.createCheckoutSession(plan.id);
      if (!context.mounted) return;

      if (result.success &&
          result.data != null &&
          result.data!.checkoutUrl.isNotEmpty) {
        AppRoutes.toCheckout(checkoutUrl: result.data!.checkoutUrl);
      } else {
        AppSnackbar.error(result.message);
      }
    } finally {
      isSubscribing.value = false;
    }
  }
}
