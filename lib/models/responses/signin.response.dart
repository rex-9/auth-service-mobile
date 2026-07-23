// models/responses/sign_in_response.dart
import 'package:auth_service_mobile/models/models.dart';

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
    user: json['user'] != null
        ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
        : null,
    token: json['token'] as String?,
    otpSent: json['otp_sent'] as bool? ?? false,
    remainingAttempts: json['remaining_attempts'] as int?,
    cooldownRemaining: json['cooldown_remaining'] as int?,
  );
}
