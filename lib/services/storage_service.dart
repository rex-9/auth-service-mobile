// lib/services/storage_service.dart
import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  void setToken(String token) => _box.write('auth_token', token);
  String? getToken() => _box.read('auth_token');

  void setUserEmail(String email) => _box.write('user_email', email);
  String? getUserEmail() => _box.read('user_email');

  void setUserData(Map<String, dynamic> user) => _box.write('user_data', user);
  Map<String, dynamic>? getUserData() => _box.read('user_data');

  // Settings (mirrors web themeAtom "auto"|"day"|"night" and i18n language)
  void setThemeName(String name) => _box.write('theme', name);
  String? getThemeName() => _box.read('theme');

  void setLocaleCode(String code) => _box.write('locale', code);
  String? getLocaleCode() => _box.read('locale');

  // Per-email passcode retry state (mirrors the web localStorage key)
  String _retryKey(String email) =>
      'passcode-retry:${email.trim().toLowerCase()}';

  void setPasscodeRetry(String email, Map<String, dynamic> state) =>
      _box.write(_retryKey(email), state);

  Map<String, dynamic>? getPasscodeRetry(String email) {
    final raw = _box.read(_retryKey(email));
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }

  /// Clears session data only (keeps theme/locale settings).
  void clearSession() {
    _box.remove('auth_token');
    _box.remove('user_email');
    _box.remove('user_data');
  }

  void clearAll() => _box.erase();
}
