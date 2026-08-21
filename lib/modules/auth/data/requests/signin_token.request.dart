import 'package:rexone_mobile/constants/constants.dart';

class SignInTokenRequest {
  final String token;

  const SignInTokenRequest({required this.token});

  Map<String, dynamic> toJson() => {
    AuthKeys.token: token,
  };
}
