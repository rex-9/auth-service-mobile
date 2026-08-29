import 'package:rexone_mobile/constants/constants.dart';

class TtsRequest {
  final String messageId;

  const TtsRequest({required this.messageId});

  Map<String, dynamic> toJson() => {
    AiKeys.messageId: messageId,
  };
}
