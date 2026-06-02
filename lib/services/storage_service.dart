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

  void clearAll() => _box.erase();
}
