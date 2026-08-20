// lib/services/storage_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.model.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  // ===== LIFECYCLE =====
  @override
  void onInit() {
    super.onInit();
    _box = GetStorage();
  }

  // ============================================================
  // AUTH SESSION
  // ============================================================
  void setToken(String token) => _box.write('auth_token', token);
  String? getToken() => _box.read('auth_token');

  void setUserEmail(String email) => _box.write('user_email', email);
  String? getUserEmail() => _box.read('user_email');

  void setUserData(UserModel user) => _box.write('user_data', user.toJson());

  UserModel? getUserData() {
    final data = _box.read('user_data');
    if (data == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  /// Clears session data only (keeps theme/locale settings).
  void clearSession() {
    _box.remove('auth_token');
    _box.remove('user_email');
    _box.remove('user_data');
  }

  // ============================================================
  // ROUTE STACK
  // ============================================================
  void saveRouteStack(List<String> routes) {
    _box.write('routes', routes);
  }

  List<String> getRouteStack() {
    final stack = _box.read('routes');
    return stack is List ? List<String>.from(stack) : [];
  }

  void clearRouteStack() {
    _box.remove('routes');
  }

  // ============================================================
  // SETTINGS (Theme & Locale)
  // ============================================================
  void setThemeName(String name) => _box.write('theme', name);
  String? getThemeName() => _box.read('theme');

  void setLocaleCode(String code) => _box.write('locale', code);
  String? getLocaleCode() => _box.read('locale');

  // ============================================================
  // UTILITY
  // ============================================================
  void clearAll() => _box.erase();
}
