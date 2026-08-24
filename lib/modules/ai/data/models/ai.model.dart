// lib/modules/ai/data/models/ai.model.dart
import 'package:rexone_mobile/constants/constants.dart';

class AiMessageModel {
  final String id;
  final String role; // EChatRole.name // "user" | "assistant"
  final String content;
  final String? roomId;
  final String? status; // EAiMessageStatus.name //"queued" | "processing" | "completed" | "failed"
  final String createdAt;

  AiMessageModel({
    required this.id,
    required this.role,
    required this.content,
    this.roomId,
    this.status,
    required this.createdAt,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    final metadata = json[AiKeys.metadata] is Map
        ? Map<String, dynamic>.from(json[AiKeys.metadata] as Map)
        : null;

    return AiMessageModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      role: json[AiKeys.role]?.toString() ?? EChatRole.user.name,
      content: json[AiKeys.content]?.toString() ?? '',
      roomId: json[AiKeys.roomId]?.toString(),
      status:
          metadata?[AiKeys.status]?.toString() ??
          json[AiKeys.status]?.toString(),
      createdAt:
          json[AiKeys.createdAt]?.toString() ??
          DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
    ApiKeys.id: id,
    AiKeys.role: role,
    AiKeys.content: content,
    AiKeys.status: status,
    AiKeys.createdAt: createdAt,
  };

  bool get isUser => role == EChatRole.user.name;
  bool get isFailed => status == EAiMessageStatus.failed.name;
  bool get isProcessing =>
      status == EAiMessageStatus.queued.name ||
      status == EAiMessageStatus.processing.name;
}

class AiRoomModel {
  final String id;
  final String title;
  final int messageCount;
  final String? lastMessage;
  final String createdAt;
  final String updatedAt;
  final bool processing;

  AiRoomModel({
    required this.id,
    required this.title,
    required this.messageCount,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.processing,
  });

  factory AiRoomModel.fromJson(Map<String, dynamic> json) {
    return AiRoomModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      title: json[AiKeys.title]?.toString() ?? 'New Chat',
      messageCount: json[AiKeys.messageCount] is int
          ? json[AiKeys.messageCount] as int
          : int.tryParse(json[AiKeys.messageCount]?.toString() ?? '0') ?? 0,
      lastMessage: json[AiKeys.lastMessage]?.toString(),
      createdAt: json[AiKeys.createdAt]?.toString() ?? '',
      updatedAt: json[AiKeys.updatedAt]?.toString() ?? '',
      processing: json[AiKeys.processing] == true,
    );
  }
}
