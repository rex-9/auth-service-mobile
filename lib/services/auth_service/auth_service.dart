// lib/services/auth_service.dart
import '../../models/api_response.dart';

abstract class AuthService {
  Future<ApiResponse<bool>> peekUser(String email);

  Future<ApiResponse<Map<String, dynamic>>> signIn(
    String signinKey,
    String password,
  );

  Future<ApiResponse<Map<String, dynamic>>> signInWithToken(String token);

  Future<ApiResponse<Map<String, dynamic>>> signInWithGoogle(String idToken);

  Future<ApiResponse<Map<String, dynamic>>> googleSignInComplete(
    String passcode,
    String challengeToken,
  );

  Future<ApiResponse<Map<String, dynamic>>> signUp({
    required String username,
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResponse<void>> sendConfirmationCode(String signinKey);

  Future<ApiResponse<Map<String, dynamic>>> confirmCode(
    String signinKey,
    String confirmationCode,
  );

  Future<ApiResponse<void>> forgotPassword(String email);

  Future<ApiResponse<void>> resetPassword({
    required String resetPasswordToken,
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResponse<Map<String, dynamic>>> getCurrentUser();

  Future<ApiResponse<void>> signOut();
}
