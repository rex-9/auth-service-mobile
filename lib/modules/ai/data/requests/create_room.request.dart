import 'package:rexone_mobile/constants/constants.dart';

class CreateRoomRequest {
  final String title;

  const CreateRoomRequest({required this.title});

  Map<String, dynamic> toJson() => {
    AiKeys.title: title,
  };
}
