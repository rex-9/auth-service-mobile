// lib/controllers/ai.controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/enums.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/services/services.dart';

class AiController extends GetxController {
  final AiService _ai = Get.find<AiService>();

  final RxList<AiMessageModel> messages = <AiMessageModel>[].obs;
  final RxList<AiRoomModel> rooms = <AiRoomModel>[].obs;

  final RxnString currentRoomId = RxnString();
  final RxString currentRoomTitle = 'AI Assistant'.obs;

  final RxBool isProcessing = false.obs;
  bool _isSubmitting = false;

  // UI controllers — owned here so no StatefulWidget is needed in AiPage.
  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
    loadRooms();
    loadHistory();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ============================================================
  // SOCKET EVENT HANDLER (called by SocketController)
  // ============================================================

  /// Called by [SocketController] when an AI-related notification arrives.
  /// Reloads history only if the event belongs to the current room.
  Future<void> onSocketEvent(EWsEventType eventType, String? roomId) async {
    if (eventType != EWsEventType.aiResponseReady && eventType != EWsEventType.aiResponseFailed) {
      return;
    }
    if (roomId == null || roomId.isEmpty || roomId == currentRoomId.value) {
      await loadHistory(currentRoomId.value);
    }
  }

  // ============================================================
  // HISTORY & MESSAGES
  // ============================================================
  Future<void> loadHistory([String? roomId]) async {
    try {
      final response = await _ai.getHistory(roomId: roomId);
      if (response.success && response.data != null) {
        final data = response.data!;
        final rawMessages = data['messages'] as List? ?? [];
        final processing = data['processing'] == true;
        final roomTitle = data['room_title']?.toString();
        final rId = data['room_id']?.toString();

        if (rId != null && rId.isNotEmpty) {
          currentRoomId.value = rId;
        }
        if (roomTitle != null && roomTitle.isNotEmpty) {
          currentRoomTitle.value = roomTitle;
        }

        final parsed = _parseMessages(rawMessages);

        if (parsed.isEmpty) {
          messages.assignAll([
            AiMessageModel(
              id: 'welcome',
              role: 'assistant',
              content:
                  "Hello! I'm your AI assistant. How can I help you today?",
              createdAt: DateTime.now().toIso8601String(),
            ),
          ]);
        } else {
          messages.assignAll(parsed);
        }

        isProcessing.value = processing;
      }
    } catch (e) {
      debugPrint('🤖 [AiController] Error loading history: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty || _isSubmitting || isProcessing.value) return;

    _isSubmitting = true;

    // Optimistic user message
    final optimisticMessage = AiMessageModel(
      id: 'optimistic_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      content: clean,
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.removeWhere((m) => m.id == 'welcome');
    messages.add(optimisticMessage);
    isProcessing.value = true;

    try {
      final response = await _ai.chat(clean, roomId: currentRoomId.value);
      if (response.success && response.data != null) {
        final rId = response.data!['room_id']?.toString();
        if (rId != null && rId.isNotEmpty) {
          currentRoomId.value = rId;
        }
      } else {
        AppSnackbar.error(response.error ?? 'Failed to send message');
        isProcessing.value = false;
      }
    } catch (e) {
      AppSnackbar.error('Failed to get AI response');
      isProcessing.value = false;
    } finally {
      _isSubmitting = false;
    }
  }

  // ============================================================
  // ROOM MANAGEMENT
  // ============================================================
  Future<void> loadRooms() async {
    try {
      final response = await _ai.getRooms();
      if (response.success && response.data != null) {
        rooms.assignAll(response.data!);
      }
    } catch (e) {
      debugPrint('🤖 [AiController] Error loading rooms: $e');
    }
  }

  void selectRoom(AiRoomModel room) {
    currentRoomId.value = room.id;
    currentRoomTitle.value = room.title;
    loadHistory(room.id);
  }

  Future<void> createNewRoom([String title = 'New Chat']) async {
    try {
      final response = await _ai.createRoom(title);
      if (response.success && response.data != null) {
        final newRoom = response.data!;
        rooms.insert(0, newRoom);
        selectRoom(newRoom);
      }
    } catch (e) {
      debugPrint('🤖 [AiController] Error creating room: $e');
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      final response = await _ai.deleteRoom(roomId);
      if (response.success) {
        rooms.removeWhere((r) => r.id == roomId);
        if (currentRoomId.value == roomId) {
          currentRoomId.value = null;
          currentRoomTitle.value = 'AI Assistant';
          loadHistory();
        }
      }
    } catch (e) {
      debugPrint('🤖 [AiController] Error deleting room: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      final response = await _ai.clearHistory(roomId: currentRoomId.value);
      if (response.success) {
        loadHistory(currentRoomId.value);
        AppSnackbar.success('Chat history cleared');
      }
    } catch (e) {
      AppSnackbar.error('Failed to clear history');
    }
  }

  // ============================================================
  // UI HELPERS
  // ============================================================
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Design.timers.short,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void handleSend() {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    textController.clear();
    sendMessage(text);
    scrollToBottom();
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================
  List<AiMessageModel> _parseMessages(dynamic raw) {
    if (raw is! List) return [];
    final List<AiMessageModel> list = [];
    for (final item in raw) {
      if (item is Map) {
        final Map<String, dynamic> map = {};
        if (item['attributes'] is Map) {
          map.addAll(Map<String, dynamic>.from(item['attributes'] as Map));
        } else {
          map.addAll(Map<String, dynamic>.from(item));
        }
        if (item['id'] != null) {
          map['id'] = item['id'].toString();
        }
        list.add(AiMessageModel.fromJson(map));
      }
    }
    return list;
  }
}
