// lib/services/storage_service.dart
import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  // ============================================================
  // AUTH SESSION
  // ============================================================
  void setToken(String token) => _box.write('auth_token', token);
  String? getToken() => _box.read('auth_token');

  void setUserEmail(String email) => _box.write('user_email', email);
  String? getUserEmail() => _box.read('user_email');

  void setUserData(Map<String, dynamic> user) => _box.write('user_data', user);
  Map<String, dynamic>? getUserData() => _box.read('user_data');

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
  // PASSCODE RETRY (Per email)
  // ============================================================
  String retryKey(String email) =>
      'passcode-retry:${email.trim().toLowerCase()}';

  void setPasscodeRetry(String email, Map<String, dynamic> state) =>
      _box.write(retryKey(email), state);

  Map<String, dynamic>? getPasscodeRetry(String email) {
    final raw = _box.read(retryKey(email));
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }

  // ============================================================
  // UTILITY
  // ============================================================
  void clearAll() => _box.erase();
}
