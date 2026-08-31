import 'package:rexone_mobile/constants/constants.dart';

class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {
    AuthKeys.email: email,
  };
}


