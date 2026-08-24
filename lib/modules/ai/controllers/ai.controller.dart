// lib/modules/ai/controllers/ai.controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';

import '../ai.dart';

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
    if (eventType != EWsEventType.aiResponseReady &&
        eventType != EWsEventType.aiResponseFailed) {
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
      final result = await _ai.getHistory(roomId: roomId);
      if (result.success) {
        if (result.records.isEmpty) {
          messages.assignAll([
            AiMessageModel(
              id: 'welcome',
              role: EChatRole.assistant.name,
              content:
                  "Hello! I'm your AI assistant. How can I help you today?",
              createdAt: DateTime.now().toIso8601String(),
            ),
          ]);
        } else {
          // Derive room context from the message data itself
          final rId = result.records.first.roomId;
          if (rId != null && rId.isNotEmpty) {
            currentRoomId.value = rId;
          }
          messages.assignAll(result.records);
        }

        isProcessing.value = result.records.any((m) => m.isProcessing);
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
      role: EChatRole.user.name,
      content: clean,
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.removeWhere((m) => m.id == 'welcome');
    messages.add(optimisticMessage);
    isProcessing.value = true;

    try {
      final response = await _ai.chat(
        AiChatRequest(message: clean, roomId: currentRoomId.value),
      );
      if (response.success && response.data != null) {
        final rId = response.data![AiKeys.roomId]?.toString();
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
      if (response.success) {
        rooms.assignAll(response.records);
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
      final response = await _ai.createRoom(CreateRoomRequest(title: title));
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
}
