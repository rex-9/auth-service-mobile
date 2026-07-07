import 'package:get/get.dart';

import '../../models/api_response.dart';
import '../../routes/server_routes.dart';
import '../api_service.dart';
import 'auth_service.dart';

class AuthServiceImpl extends GetxService implements AuthService {
  final ApiService _api = Get.find();

  @override
  Future<ApiResponse<bool>> peekUser(String email) async {
    final response = await _api.get(
      ServerRoutes.peekUser,
      query: {'email': email},
    );
    return _api.parseResponse<bool>(
      response,
      (data) => data['user_exists'] as bool,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> signIn(
    String signinKey,
    String password,
  ) async {
    final response = await _api.post(ServerRoutes.signIn, {
      'user': {'signin_key': signinKey, 'password': password},
    });
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> signInWithToken(
    String token,
  ) async {
    final response = await _api.post(ServerRoutes.signInWithToken, {
      'token': token,
    });
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> signInWithGoogle(
    String idToken,
  ) async {
    final response = await _api.post(ServerRoutes.signInWithGoogle, {
      'token': idToken,
    });
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> googleSignInComplete(
    String passcode,
    String challengeToken,
  ) async {
    final response = await _api.post(ServerRoutes.signInGoogleComplete, {
      'passcode': passcode,
      'challenge_token': challengeToken,
    });
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> signUp({
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
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<void>> sendConfirmationCode(String signinKey) async {
    final response = await _api.post(ServerRoutes.sendConfirmationCode, {
      'signin_key': signinKey,
    });
    return _api.parseResponse<void>(response, (_) {});
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> confirmCode(
    String signinKey,
    String confirmationCode,
  ) async {
    final response = await _api.post(ServerRoutes.confirmCode, {
      'signin_key': signinKey,
      'confirmation_code': confirmationCode,
    });
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<void>> forgotPassword(String email) async {
    final response = await _api.post(ServerRoutes.forgotPassword, {
      'email': email,
    });
    return _api.parseResponse<void>(response, (_) {});
  }

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

  @override
  Future<ApiResponse<Map<String, dynamic>>> getCurrentUser() async {
    final response = await _api.get(ServerRoutes.currentUser);
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data['user'] as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<void>> signOut() async {
    final response = await _api.delete(ServerRoutes.signOut);
    return _api.parseResponse<void>(response, (_) {});
  }
}
