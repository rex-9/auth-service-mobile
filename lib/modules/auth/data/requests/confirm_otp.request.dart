import 'package:rexone_mobile/constants/constants.dart';

class ConfirmOtpRequest {
  final String signinKey;
  final String confirmationCode;

  const ConfirmOtpRequest({
    required this.signinKey,
    required this.confirmationCode,
  });

  Map<String, dynamic> toJson() => {
    AuthKeys.signinKey: signinKey,
    AuthKeys.confirmationCode: confirmationCode,
  };
}
