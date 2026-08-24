import 'package:rexone_mobile/constants/constants.dart';

class TtsRequest {
  final String text;

  const TtsRequest({required this.text});

  Map<String, dynamic> toJson() => {
    SpeechKeys.text: text,
  };
}
