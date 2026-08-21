import 'package:rexone_mobile/constants/constants.dart';

class SignInGoogleRequest {
  final String idToken;

  const SignInGoogleRequest({required this.idToken});

  Map<String, dynamic> toJson() => {
    AuthKeys.token: idToken,
  };
}
