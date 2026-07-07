// lib/bindings/initial_binding.dart
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/auth_service/auth_service.dart';
import '../services/auth_service/auth_service_impl.dart';
import '../services/storage_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Storage (no dependencies)
    Get.put(StorageService());

    // Settings: theme + locale (depends on StorageService)
    Get.put(SettingsController());

    // API Core (depends on nothing)
    Get.put(ApiService());

    // Auth Service (depends on ApiService)
    Get.put<AuthService>(AuthServiceImpl());

    // Auth Controller (depends on AuthService and StorageService)
    Get.put(AuthController());
  }
}
