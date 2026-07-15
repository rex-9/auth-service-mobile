// lib/services/auth_service_impl.dart
import 'package:get/get.dart';
import 'package:meritbox_mobile/models/models.dart';
import 'package:meritbox_mobile/routes/routes.dart';
import 'package:meritbox_mobile/services/services.dart';

class AuthServiceImpl extends GetxService implements AuthService {
  final ApiService _api = Get.find();

  // ===== LIFECYCLE =====

  // ===== AUTH METHODS =====

  // 1. Check if user exists
  @override
  Future<ApiResponse<PeekUserResponse>> peekUser(String email) async {
    final response = await _api.get(
      ServerRoutes.peekUser,
      query: {'email': email},
    );
    return _api.parseResponse<PeekUserResponse>(
      response,
      (data) => PeekUserResponse.fromJson(data),
    );
  }

  // 2. Sign in with email/username and password
  @override
  Future<ApiResponse<SignInResponse>> signIn(
    String signinKey,
    String password,
  ) async {
    final response = await _api.post(ServerRoutes.signIn, {
      'user': {'signin_key': signinKey, 'password': password},
    });
    return _api.parseResponse<SignInResponse>(
      response,
      (data) => SignInResponse.fromJson(data),
    );
  }

  // 3. Sign in with token (from email confirmation)
  @override
  Future<ApiResponse<AuthResponse>> signInWithToken(String token) async {
    final response = await _api.post(ServerRoutes.signInWithToken, {
      'token': token,
    });
    return _api.parseResponse<AuthResponse>(
      response,
      (data) => AuthResponse.fromJson(data),
    );
  }

  // 4. Sign in with Google
  @override
  Future<ApiResponse<GoogleResponse>> signInWithGoogle(String idToken) async {
    final response = await _api.post(ServerRoutes.signInWithGoogle, {
      'token': idToken,
    });
    return _api.parseResponse<GoogleResponse>(
      response,
      (data) => GoogleResponse.fromJson(data),
    );
  }

  // 4b. Complete Google sign in (new Google account sets a passcode)
  @override
  Future<ApiResponse<AuthResponse>> googleSignInComplete(
    String passcode,
    String challengeToken,
  ) async {
    final response = await _api.post(ServerRoutes.signInGoogleComplete, {
      'passcode': passcode,
      'challenge_token': challengeToken,
    });
    return _api.parseResponse<AuthResponse>(
      response,
      (data) => AuthResponse.fromJson(data),
    );
  }

  // 5. Sign up (register new user)
  @override
  Future<ApiResponse<AuthResponse>> signUp({
    required String username,
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post(ServerRoutes.signUp, {
      'user': {
        'username': username,
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    });
    return _api.parseResponse<AuthResponse>(
      response,
      (data) => AuthResponse.fromJson(data),
    );
  }

  // 6. Send confirmation code (for email verification)
  @override
  Future<ApiResponse<void>> sendConfirmationCode(String signinKey) async {
    final response = await _api.post(ServerRoutes.sendConfirmationCode, {
      'signin_key': signinKey,
    });
    return _api.parseResponse<void>(response, (_) {});
  }

  // 7. Confirm email with code
  @override
  Future<ApiResponse<AuthResponse>> confirmCode(
    String signinKey,
    String confirmationCode,
  ) async {
    final response = await _api.post(ServerRoutes.confirmCode, {
      'signin_key': signinKey,
      'confirmation_code': confirmationCode,
    });
    return _api.parseResponse<AuthResponse>(
      response,
      (data) => AuthResponse.fromJson(data),
    );
  }

  // 8. Forgot password - send reset instructions
  @override
  Future<ApiResponse<void>> forgotPassword(String email) async {
    final response = await _api.post(ServerRoutes.forgotPassword, {
      'email': email,
    });
    return _api.parseResponse<void>(response, (_) {});
  }

  // 9. Reset password
  @override
  Future<ApiResponse<void>> resetPassword({
    required String resetPasswordToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.put(ServerRoutes.resetPassword, {
      'user': {
        'reset_password_token': resetPasswordToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    });
    return _api.parseResponse<void>(response, (_) {});
  }

  // 10. Get current user
  @override
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await _api.get(ServerRoutes.currentUser);
    return _api.parseResponse<UserModel>(
      response,
      (data) => UserModel.fromJson(data),
    );
  }

  // 11. Sign out
  @override
  Future<ApiResponse<void>> signOut() async {
    final response = await _api.delete(ServerRoutes.signOut);
    return _api.parseResponse<void>(response, (_) {});
  }
}
