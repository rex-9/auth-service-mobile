// models/responses/google_response.dart
import 'package:auth_service_mobile/models/models.dart';

class GoogleResponse {
  final bool passwordRequired;
  final String? challengeToken;
  final UserModel? user;
  final String? token;

  GoogleResponse({
    required this.passwordRequired,
    this.challengeToken,
    this.user,
    this.token,
  });

  factory GoogleResponse.fromJson(Map<String, dynamic> json) => GoogleResponse(
    passwordRequired: json['password_required'] as bool? ?? false,
    challengeToken: json['challenge_token'] as String?,
    user: json['user'] != null
        ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
        : null,
    token: json['token'] as String?,
  );
}
