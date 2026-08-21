import 'package:rexone_mobile/constants/constants.dart';

class SignInRequest {
  final String signinKey;
  final String password;

  const SignInRequest({required this.signinKey, required this.password});

  Map<String, dynamic> toJson() => {
    AuthKeys.user: {
      AuthKeys.signinKey: signinKey,
      AuthKeys.password: password,
    },
  };
}
