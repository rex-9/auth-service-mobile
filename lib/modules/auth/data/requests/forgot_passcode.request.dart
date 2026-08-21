import 'package:rexone_mobile/constants/constants.dart';

class ForgotPasscodeRequest {
  final String email;

  const ForgotPasscodeRequest({required this.email});

  Map<String, dynamic> toJson() => {
    AuthKeys.email: email,
  };
}
