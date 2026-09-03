// lib/models/user.model.dart
import 'package:rexone_mobile/constants/constants.dart';

class UserModel {
  final String id;
  final String email;
  final String? username;
  final String? name;
  final String? provider;
  final String? photo;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    this.name,
    this.provider,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      email: json[AuthKeys.email] ?? '',
      username: json[AuthKeys.username],
      name: json[AuthKeys.name],
      provider: json[AuthKeys.provider],
      photo: json[AuthKeys.avatarUrl] ?? json[AuthKeys.photo],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      AuthKeys.email: email,
      AuthKeys.username: username,
      AuthKeys.name: name,
      AuthKeys.provider: provider,
      AuthKeys.avatarUrl: photo,
    };
  }
}
