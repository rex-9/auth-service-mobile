class PeekUserResponse {
  final bool userExists;
  final bool confirmed;

  PeekUserResponse({required this.userExists, required this.confirmed});

  factory PeekUserResponse.fromJson(Map<String, dynamic> json) {
    return PeekUserResponse(
      userExists: json['user_exists'] as bool? ?? false,
      confirmed: json['confirmed'] as bool? ?? false,
    );
  }
}
