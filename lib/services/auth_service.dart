import '../app_routes.dart';
import '../models/models.dart';
import 'api_service.dart';

/// Mirrors web `src/services/auth.service.ts`.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  Future<ApiResponse<ApiAuthResponse>> _wrap(
    Future<ApiResponse<Map<String, dynamic>>> Function() request,
  ) async {
    final response = await request();
    return ApiResponse(
      data: response.data == null
          ? null
          : ApiAuthResponse.fromJson(response.data!),
      error: response.error,
    );
  }

  Future<ApiResponse<ApiAuthResponse>> signInWithEmailOrUsername(
    String signinKey,
    String password,
  ) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.signInEmail,
        data: {
          'user': {'signin_key': signinKey, 'password': password},
        },
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> signInWithToken(String token) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.signInToken,
        data: {'token': token},
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> signInWithGoogle(String token) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.signInGoogle,
        data: {'token': token},
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> completeGoogleSignIn(
    String passcode,
    String challengeToken,
  ) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.signInGoogleComplete,
        data: {'passcode': passcode, 'challenge_token': challengeToken},
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> signUpWithEmail(
    String username,
    String email,
    String password,
    String passwordConfirmation,
  ) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.signUp,
        data: {
          'user': {
            'username': username,
            'email': email,
            'password': password,
            'password_confirmation': passwordConfirmation,
          },
        },
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> confirmEmailWithCode(
    String emailOrUsername,
    String confirmationCode,
  ) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.confirmCode,
        data: {
          'signin_key': emailOrUsername,
          'confirmation_code': confirmationCode,
        },
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> sendConfirmationEmail(
    String emailOrUsername,
  ) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.sendEmailCode,
        data: {'signin_key': emailOrUsername},
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> sendForgotPasswordMail(String email) {
    return _wrap(
      () => Api.post(
        AppRoutes.server.public.forgotPassword,
        data: {'email': email},
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> resetPassword(
    String token,
    String password,
    String passwordConfirmation,
  ) {
    return _wrap(
      () => Api.put(
        AppRoutes.server.public.resetPassword,
        data: {
          'user': {
            'reset_password_token': token,
            'password': password,
            'password_confirmation': passwordConfirmation,
          },
        },
      ),
    );
  }

  Future<ApiResponse<ApiAuthResponse>> signOut() {
    return _wrap(() => Api.delete(AppRoutes.server.protected.signOut));
  }
}

final authService = AuthService.instance;
