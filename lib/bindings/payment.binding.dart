import 'package:get/get.dart';
import 'package:auth_service_mobile/controllers/controllers.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
