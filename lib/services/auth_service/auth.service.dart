// lib/services/auth_service.dart
import 'package:get/get.dart';
import 'package:rexone_mobile/models/models.dart';

/// Abstract interface for Auth Service
/// Allows swapping implementations (e.g., for testing)
abstract class AuthService extends GetxService {
  // 1. Check if user exists
  Future<ApiResponse<PeekUserResponse>> peekUser(String email);

  // 2. Sign in with email/username and password
  Future<ApiResponse<SignInResponse>> signIn(String signinKey, String password);

  // 3. Sign in with token (from email confirmation)
  Future<ApiResponse<AuthResponse>> signInWithToken(String token);

  // 4. Sign in with Google
  Future<ApiResponse<GoogleResponse>> signInWithGoogle(String idToken);

  // 4b. Complete Google sign in (new Google account sets a passcode)
  Future<ApiResponse<AuthResponse>> googleSignInComplete(
    String passcode,
    String challengeToken,
  );

  // 5. Sign up (register new user)
  Future<ApiResponse<UserModel>> signUp({
    required String username,
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  // 6. Send confirmation code (for email verification)
  Future<ApiResponse<void>> sendConfirmationCode(String signinKey);

  // 7. Confirm email with code
  Future<ApiResponse<AuthResponse>> confirmCode(
    String signinKey,
    String confirmationCode,
  );

  // 8. Forgot password - send reset instructions
  Future<ApiResponse<void>> forgotPasscode(String email);

  // 9. WEB: Reset password
  // Future<ApiResponse<void>> resetPasscode({
  //   required String resetPasswordToken,
  //   required String password,
  //   required String passwordConfirmation,
  // });

  // 10. Get current user
  Future<ApiResponse<UserModel>> getCurrentUser();

  // 11. Sign out
  Future<ApiResponse<void>> signOut();
}
