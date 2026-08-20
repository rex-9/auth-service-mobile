// lib/modules/auth/services/auth.service.dart
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/services.dart';

class AuthService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  // 1. Check if user exists
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
  Future<ApiResponse<SignInResponse>> signIn(
    String signinKey,
    String password,
  ) async {
    final response = await _api.post(ServerRoutes.signIn, {
      AuthKeys.user: {AuthKeys.signinKey: signinKey, AuthKeys.password: password},
    });
    return _api.parseResponse<SignInResponse>(
      response,
      (data) => SignInResponse.fromJson(data),
    );
  }

  // 3. Sign in with token (from email confirmation)
  Future<ApiResponse<AuthResponse>> signInWithToken(String token) async {
    final response = await _api.post(ServerRoutes.signInWithToken, {
      AuthKeys.token: token,
    });
    return _api.parseResponse<AuthResponse>(
      response,
      (data) => AuthResponse.fromJson(data),
    );
  }

  // 4. Sign in with Google
  Future<ApiResponse<GoogleResponse>> signInWithGoogle(String idToken) async {
    final response = await _api.post(ServerRoutes.signInWithGoogle, {
      AuthKeys.token: idToken,
    });
    return _api.parseResponse<GoogleResponse>(
      response,
      (data) => GoogleResponse.fromJson(data),
    );
  }

  // 4b. Complete Google sign in (new Google account sets a passcode)
  Future<ApiResponse<AuthResponse>> googleSignInComplete(
    String passcode,
    String challengeToken,
  ) async {
    final response = await _api.post(ServerRoutes.signInGoogleComplete, {
      AuthKeys.password: passcode,
      AuthKeys.challengeToken: challengeToken,
    });
    return _api.parseResponse<AuthResponse>(
      response,
      (data) => AuthResponse.fromJson(data),
    );
  }

  // 5. Sign up (register new user)
  Future<ApiResponse<UserModel>> signUp({
    required String username,
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post(ServerRoutes.signUp, {
      AuthKeys.user: {
        AuthKeys.username: username,
        AuthKeys.name: name,
        AuthKeys.email: email,
        AuthKeys.password: password,
        AuthKeys.passwordConfirmation: passwordConfirmation,
      },
    });
    return _api.parseResponse<UserModel>(
      response,
      (data) => UserModel.fromJson(data),
    );
  }

  // 6. Send confirmation code (for email verification)
  Future<ApiResponse<void>> sendConfirmationOTPCode(String signinKey) async {
    final response = await _api.post(ServerRoutes.sendConfirmationCode, {
      AuthKeys.signinKey: signinKey,
    });
    return _api.parseResponse<void>(response, (data) {});
  }

  // 7. Confirm email with code
  Future<ApiResponse<AuthResponse>> confirmOTPCode(
    String signinKey,
    String confirmationCode,
  ) async {
    final response = await _api.post(ServerRoutes.confirmCode, {
      AuthKeys.signinKey: signinKey,
      AuthKeys.confirmationCode: confirmationCode,
    });
    return _api.parseResponse<AuthResponse>(
      response,
      (data) => AuthResponse.fromJson(data),
    );
  }

  // 8. Forgot password - send reset instructions
  Future<ApiResponse<void>> forgotPasscode(String email) async {
    final response = await _api.post(ServerRoutes.forgotPassword, {
      AuthKeys.email: email,
    });
    return _api.parseResponse<void>(response, (data) {});
  }

  // 9. Get current user
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await _api.get(ServerRoutes.currentUser);
    return _api.parseResponse<UserModel>(
      response,
      (data) => UserModel.fromJson(data),
    );
  }

  // 10. Sign out
  Future<ApiResponse<void>> signOut() async {
    final response = await _api.delete(ServerRoutes.signOut);
    return _api.parseResponse<void>(response, (data) {});
  }
}
