import 'package:get/get.dart';
import '../services/services.dart';
import '../controllers/controllers.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ===== Services =====

    // Storage (no dependencies)
    Get.put(StorageService(), permanent: true);

    // API Service (interface + implementation)
    Get.put<ApiService>(ApiService(), permanent: true);

    // Auth Service (depends on ApiService)
    // if we have the mulitple implementations of the same service, we can use the tag to differentiate between them
    Get.put<AuthService>(AuthServiceImpl(), permanent: true);

    // Firebase Google Analytics Service
    Get.put<AnalyticsService>(AnalyticsService(), permanent: true);

    // Push Notification Service (no dependencies, initialized first)
    Get.put<PushNotiService>(PushNotiService(), permanent: true);

    // Payment Service (depends on ApiService)
    Get.put<PaymentService>(PaymentServiceImpl(), permanent: true);

    // ===== Controllers =====

    // Settings: theme + locale (depends on StorageService)
    Get.put(SettingsController(), permanent: true);

    // Auth Controller (depends on AuthService and StorageService)
    Get.put(AuthController(), permanent: true);
  }
}
