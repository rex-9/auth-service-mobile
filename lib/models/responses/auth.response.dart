import 'package:meritbox_mobile/models/user.model.dart';

class AuthResponse {
  final UserModel user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    token: json['token'] as String,
  );
}
