import 'package:rexone_mobile/constants/constants.dart';

class AiChatRequest {
  final String message;
  final String? roomId;

  const AiChatRequest({required this.message, this.roomId});

  Map<String, dynamic> toJson() => {
    ApiKeys.message: message,
    if (roomId != null && roomId!.isNotEmpty) AiKeys.roomId: roomId,
  };
}
