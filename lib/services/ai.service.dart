// lib/services/ai.service.dart
import 'package:get/get.dart';
import 'package:rexone_mobile/helpers/helpers.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/api.service.dart';

class AiService extends GetxService {
  late final ApiService _api;

  @override
  void onInit() {
    super.onInit();
    _api = Get.find<ApiService>();
  }

  // ============================================================
  // CHAT
  // ============================================================
  Future<ApiResponse<Map<String, dynamic>>> chat(
    String message, {
    String? roomId,
  }) async {
    final response = await _api.post(
      ServerRoutes.aiChat,
      {
        'message': message,
        if (roomId != null && roomId.isNotEmpty) 'room_id': roomId,
      },
      showLoading: false,
    );
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data is Map ? Map<String, dynamic>.from(data) : {},
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================
  Future<ApiResponse<Map<String, dynamic>>> getHistory({
    String? roomId,
  }) async {
    final query = <String, dynamic>{};
    if (roomId != null && roomId.isNotEmpty) query['room_id'] = roomId;
    final response = await _api.get(ServerRoutes.aiHistory, query: query);
    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (data) => data is Map ? Map<String, dynamic>.from(data) : {},
    );
  }

  Future<ApiResponse<dynamic>> clearHistory({String? roomId}) async {
    final query = <String, dynamic>{};
    if (roomId != null && roomId.isNotEmpty) query['room_id'] = roomId;
    final response = await _api.delete(ServerRoutes.aiClear, query: query);
    return _api.parseResponse(response, (data) => data);
  }

  // ============================================================
  // ROOMS
  // ============================================================
  Future<ApiResponse<List<AiRoomModel>>> getRooms() async {
    final response = await _api.get(ServerRoutes.aiRooms);
    return _api.parseResponse<List<AiRoomModel>>(
      response,
      (data) => ApiHelper.parseList(data, AiRoomModel.fromJson),
    );
  }

  Future<ApiResponse<AiRoomModel>> createRoom(String title) async {
    final response = await _api.post(ServerRoutes.aiRooms, {'title': title});
    return _api.parseResponse<AiRoomModel>(response, (data) {
      final record = data is Map && data['room'] is Map ? data['room'] : data;
      return ApiHelper.parseRecord<AiRoomModel>(record, AiRoomModel.fromJson)
          ?? AiRoomModel.fromJson(const {});
    });
  }

  Future<ApiResponse<dynamic>> deleteRoom(String roomId) async {
    final response = await _api.delete(ServerRoutes.aiDeleteRoom(roomId));
    return _api.parseResponse(response, (data) => data);
  }
}
