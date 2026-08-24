// lib/modules/auth/responses/signin.response.dart
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/models/models.dart';

class SignInResponse {
  final UserModel? user;
  final String? token;
  final bool otpSent;
  final int? remainingAttempts;
  final int? cooldownRemaining;

  SignInResponse({
    this.user,
    this.token,
    this.otpSent = false,
    this.remainingAttempts,
    this.cooldownRemaining,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
    user: json[AuthKeys.user] is Map
        ? UserModel.fromJson(
            Map<String, dynamic>.from(json[AuthKeys.user] as Map),
          )
        : null,
    token: json[AuthKeys.token]?.toString(),
    otpSent: json[AuthKeys.otpSent] as bool? ?? false,
    remainingAttempts: json[AuthKeys.remainingAttempts] as int?,
    cooldownRemaining: json[AuthKeys.cooldownRemaining] as int?,
  );
}
