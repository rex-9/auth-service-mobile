/// Mirrors web `src/models/user.model.ts` (`IUser`).
class User {
  const User({
    required this.username,
    required this.email,
    this.name,
    this.provider,
    this.bio,
    this.profilePicUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String username;
  final String email;
  final String? name;
  final String? provider;
  final String? bio;
  final String? profilePicUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      provider: json['provider'] as String?,
      bio: json['bio'] as String?,
      profilePicUrl: json['profile_pic_url'] as String?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'provider': provider,
      'bio': bio,
      'profile_pic_url': profilePicUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
