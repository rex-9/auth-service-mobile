// models/responses/google_response.dart
import 'package:rexone_mobile/models/models.dart';

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
    user: json['user'] is Map
        ? UserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map))
        : null,
    token: json['token']?.toString(),
  );
}
