import 'package:rexone_mobile/constants/constants.dart';

class GoogleSignInCompleteRequest {
  final String password;
  final String challengeToken;

  const GoogleSignInCompleteRequest({
    required this.password,
    required this.challengeToken,
  });

  Map<String, dynamic> toJson() => {
    AuthKeys.password: password,
    AuthKeys.challengeToken: challengeToken,
  };
}
