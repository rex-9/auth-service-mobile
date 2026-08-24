import 'package:rexone_mobile/constants/constants.dart';

class SttModel {
  final String text;

  const SttModel({required this.text});

  factory SttModel.fromJson(Map<String, dynamic> json) {
    return SttModel(
      text: json[SpeechKeys.text]?.toString() ?? '',
    );
  }
}
