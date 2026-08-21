// lib/models/responses/auth/google.response.dart
import 'package:rexone_mobile/constants/constants.dart';
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
    passwordRequired: json[AuthKeys.passwordRequired] as bool? ?? false,
    challengeToken: json[AuthKeys.challengeToken] as String?,
    user: json[AuthKeys.user] is Map
        ? UserModel.fromJson(
            Map<String, dynamic>.from(json[AuthKeys.user] as Map),
          )
        : null,
    token: json[AuthKeys.token]?.toString(),
  );
}
