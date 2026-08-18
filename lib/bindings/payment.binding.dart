import 'package:get/get.dart';
import 'package:rexone_mobile/controllers/controllers.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
