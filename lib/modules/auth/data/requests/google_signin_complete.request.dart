import 'package:rexone_mobile/constants/constants.dart';

class GoogleSignInCompleteRequest {
  final String passcode;
  final String challengeToken;

  const GoogleSignInCompleteRequest({
    required this.passcode,
    required this.challengeToken,
  });

  Map<String, dynamic> toJson() => {
    AuthKeys.password: passcode,
    AuthKeys.challengeToken: challengeToken,
  };
}
