import 'package:rexone_mobile/constants/constants.dart';

class PeekUserResponse {
  final bool userExists;
  final bool confirmed;

  PeekUserResponse({required this.userExists, required this.confirmed});

  factory PeekUserResponse.fromJson(Map<String, dynamic> json) {
    return PeekUserResponse(
      userExists: json[AuthKeys.userExists] as bool? ?? false,
      confirmed: json[AuthKeys.confirmed] as bool? ?? false,
    );
  }
}
