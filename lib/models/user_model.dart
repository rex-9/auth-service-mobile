// lib/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String? username;
  final String? name;
  final String? photo;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    this.name,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      name: json['name'],
      photo: json['photo'],
    );
  }
}

enum PeekedUserStatus {
  error, // API call failed
  exists, // User exists in database
  notExists, // User does not exist
}
