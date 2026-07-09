// lib/models/user_model.dart
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
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      name: json['name'],
      provider: json['provider'],
      photo: json['profile_pic_url'] ?? json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'provider': provider,
      'profile_pic_url': photo,
    };
  }
}

enum PeekedUserStatus {
  error, // API call failed
  exists, // User exists in database
  notExists, // User does not exist
}
