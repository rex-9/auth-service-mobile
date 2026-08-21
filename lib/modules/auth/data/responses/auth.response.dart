import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/models/user.model.dart';

class AuthResponse {
  final UserModel user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    user: UserModel.fromJson(json[AuthKeys.user] as Map<String, dynamic>),
    token: json[AuthKeys.token] as String,
  );
}
