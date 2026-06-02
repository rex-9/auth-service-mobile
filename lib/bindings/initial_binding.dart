// lib/bindings/initial_binding.dart
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Storage (no dependencies)
    Get.put(StorageService());

    // API Core (depends on nothing)
    Get.put(ApiService());

    // Auth Service (depends on ApiService)
    Get.put(AuthService());

    // Auth Controller (depends on AuthService and StorageService)
    Get.put(AuthController());
  }
}
