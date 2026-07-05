import '../models/models.dart';
import '../services/services.dart';

/// Mirrors web `src/controllers/user.controller.ts`.
class UserController {
  UserController._();

  static final UserController instance = UserController._();

  Future<bool?> peekUser(
    String email,
    void Function(String message) setError,
  ) async {
    final response = await userService.peekUser(email);
    final userExists = response.data?.data?['user_exists'];
    if (userExists is! bool) {
      setError('Failed to peek user');
      return null;
    }
    return userExists;
  }

  Future<void> getCurrentUser(
    void Function(User? user) setCurrentUser,
  ) async {
    try {
      final response = await userService.getCurrentUser();
      final rawUser = response.data?.data?['user'];
      setCurrentUser(
        rawUser is Map<String, dynamic> ? User.fromJson(rawUser) : null,
      );
    } catch (_) {
      // Error fetching current user.
    }
  }
}

final userController = UserController.instance;
