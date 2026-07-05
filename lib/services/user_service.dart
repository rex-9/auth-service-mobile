import '../app_routes.dart';
import '../models/models.dart';
import 'api_service.dart';

/// Mirrors web `src/services/user.service.ts`.
class UserService {
  UserService._();

  static final UserService instance = UserService._();

  Future<ApiResponse<ApiAuthResponse>> peekUser(String email) async {
    final response = await Api.get(
      AppRoutes.server.protected.peekUser,
      params: {'email': email},
    );
    return ApiResponse(
      data: response.data == null
          ? null
          : ApiAuthResponse.fromJson(response.data!),
      error: response.error,
    );
  }

  Future<ApiResponse<ApiAuthResponse>> getCurrentUser() async {
    final response = await Api.get(AppRoutes.server.protected.getCurrentUser);
    return ApiResponse(
      data: response.data == null
          ? null
          : ApiAuthResponse.fromJson(response.data!),
      error: response.error,
    );
  }
}

final userService = UserService.instance;
