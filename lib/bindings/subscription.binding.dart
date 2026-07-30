import 'package:get/get.dart';
import 'package:auth_service_mobile/controllers/controllers.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
  }
}
