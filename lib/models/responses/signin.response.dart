// models/responses/sign_in_response.dart
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
    user: json['user'] is Map
        ? UserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map))
        : null,
    token: json['token']?.toString(),
    otpSent: json['otp_sent'] as bool? ?? false,
    remainingAttempts: json['remaining_attempts'] as int?,
    cooldownRemaining: json['cooldown_remaining'] as int?,
  );
}
