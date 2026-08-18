// lib/models/ai.model.dart

class AiMessageModel {
  final String id;
  final String role; // "user" | "assistant"
  final String content;
  final String? status; // "queued" | "processing" | "completed" | "failed"
  final String createdAt;

  AiMessageModel({
    required this.id,
    required this.role,
    required this.content,
    this.status,
    required this.createdAt,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] is Map
        ? Map<String, dynamic>.from(json['metadata'])
        : null;

    return AiMessageModel(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      content: json['content']?.toString() ?? '',
      status: metadata?['status']?.toString() ?? json['status']?.toString(),
      createdAt: json['created_at']?.toString() ??
          DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'content': content,
        'status': status,
        'created_at': createdAt,
      };

  bool get isUser => role == 'user';
  bool get isFailed => status == 'failed';
  bool get isProcessing => status == 'queued' || status == 'processing';
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
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'New Chat',
      messageCount: json['message_count'] is int
          ? json['message_count']
          : int.tryParse(json['message_count']?.toString() ?? '0') ?? 0,
      lastMessage: json['last_message']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      processing: json['processing'] == true,
    );
  }
}
