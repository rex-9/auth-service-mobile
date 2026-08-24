import 'package:rexone_mobile/constants/constants.dart';

class SignUpRequest {
  final String username;
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignUpRequest({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    AuthKeys.user: {
      AuthKeys.username: username,
      AuthKeys.name: name,
      AuthKeys.email: email,
      AuthKeys.password: password,
      AuthKeys.passwordConfirmation: passwordConfirmation,
    },
  };
}
