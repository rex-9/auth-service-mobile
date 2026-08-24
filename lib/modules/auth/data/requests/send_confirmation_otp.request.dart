import 'package:rexone_mobile/constants/constants.dart';

class SendConfirmationOtpRequest {
  final String signinKey;

  const SendConfirmationOtpRequest({required this.signinKey});

  Map<String, dynamic> toJson() => {
    AuthKeys.signinKey: signinKey,
  };
}
