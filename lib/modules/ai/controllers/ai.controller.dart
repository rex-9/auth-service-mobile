// lib/modules/ai/controllers/ai.controller.dart
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';

import '../ai.dart';

class AiController extends GetxController {
  final AiService _ai = Get.find<AiService>();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _ttsPlayer = AudioPlayer();

  final RxList<AiMessageModel> messages = <AiMessageModel>[].obs;
  final RxList<AiRoomModel> rooms = <AiRoomModel>[].obs;

  final RxnString currentRoomId = RxnString();
  final RxString currentRoomTitle = 'AI Assistant'.obs;

  final RxBool isProcessing = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool isTranscribing = false.obs;
  final RxInt recordingSeconds = 0.obs;
  final RxDouble voiceLevel = 0.0.obs;
  final RxnString lastRecordingPath = RxnString();
  final RxnString activeTtsMessageId = RxnString();
  final RxBool isTtsLoading = false.obs;

  bool _isSubmitting = false;
  Timer? _recordingTimer;
  StreamSubscription<Amplitude>? _amplitudeSub;
  StreamSubscription<PlayerState>? _ttsStateSub;
  String? _activeRecordingPath;
  String? _cachedTtsMessageId;
  String? _cachedTtsFilePath;

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
    _recordingTimer?.cancel();
    _amplitudeSub?.cancel();
    if (isRecording.value) {
      unawaited(_recorder.stop());
    }
    unawaited(_recorder.dispose());
    unawaited(_stopTtsPlayback());
    unawaited(_clearTtsCache());
    unawaited(_ttsPlayer.dispose());
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
        AppSnackbar.error(
          response.error ?? Constants.locale.aiSendMessageFailed.tr,
        );
        isProcessing.value = false;
      }
    } catch (e) {
      AppSnackbar.error(Constants.locale.aiResponseFailed.tr);
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
        AppSnackbar.success(Constants.locale.aiHistoryCleared.tr);
      }
    } catch (e) {
      AppSnackbar.error(Constants.locale.aiClearHistoryFailed.tr);
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
    if (isTranscribing.value || activeTtsMessageId.value != null) return;
    final text = textController.text.trim();
    if (text.isEmpty) return;
    textController.clear();
    sendMessage(text);
    scrollToBottom();
  }

  // ============================================================
  // VOICE RECORDING
  // ============================================================
  String get formattedRecordingDuration {
    final minutes = recordingSeconds.value ~/ 60;
    final seconds = recordingSeconds.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> startRecording() async {
    if (isRecording.value ||
        isProcessing.value ||
        isTranscribing.value ||
        activeTtsMessageId.value != null) {
      return;
    }

    var permission = await Permission.microphone.status;
    if (!permission.isGranted) {
      permission = await Permission.microphone.request();
    }
    if (!permission.isGranted) {
      await _promptMicPermission();
      return;
    }

    if (!await _recorder.hasPermission()) {
      await _promptMicPermission();
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      _activeRecordingPath =
          '${dir.path}/ai_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _activeRecordingPath!,
      );

      recordingSeconds.value = 0;
      voiceLevel.value = 0;
      isRecording.value = true;

      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        recordingSeconds.value++;
      });

      await _amplitudeSub?.cancel();
      _amplitudeSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amplitude) {
        voiceLevel.value = _normalizeAmplitude(amplitude.current);
      });
    } catch (e) {
      debugPrint('🤖 [AiController] Error starting recording: $e');
      AppSnackbar.error(Constants.locale.aiStartRecordingFailed.tr);
      await _cleanupRecording(discardFile: true);
    }
  }

  Future<void> cancelRecording() async {
    if (!isRecording.value) return;
    await _cleanupRecording(discardFile: true);
  }

  Future<void> finishRecording() async {
    if (!isRecording.value || isTranscribing.value) return;

    String? savedPath;
    try {
      final path = await _recorder.stop();
      _recordingTimer?.cancel();
      await _amplitudeSub?.cancel();
      _amplitudeSub = null;

      savedPath = path ?? _activeRecordingPath;
      _activeRecordingPath = null;
      _resetRecordingUiState();

      if (savedPath == null || savedPath.isEmpty) {
        AppSnackbar.error(Constants.locale.aiSaveRecordingFailed.tr);
        return;
      }

      isTranscribing.value = true;
      final response = await _ai.speechToText(savedPath);

      if (response.success && response.data != null) {
        final text = response.data!.text.trim();
        if (text.isEmpty) {
          AppSnackbar.error(Constants.locale.aiTranscriptionEmpty.tr);
        } else {
          textController.text = text;
        }
      } else {
        AppSnackbar.error(
          response.error ?? Constants.locale.aiTranscriptionFailed.tr,
        );
      }
    } catch (e) {
      debugPrint('🤖 [AiController] Error finishing recording: $e');
      AppSnackbar.error(Constants.locale.aiTranscriptionFailed.tr);
    } finally {
      isTranscribing.value = false;
      if (savedPath != null) {
        await _deleteRecordingFile(savedPath);
      }
      lastRecordingPath.value = null;
    }
  }

  double _normalizeAmplitude(double db) {
    return ((db + 50) / 50).clamp(0.0, 1.0);
  }

  Future<void> _promptMicPermission() async {
    final context = Get.context;
    if (context == null || !context.mounted) return;

    final openSettings = await AppDialog.confirm(
      context: context,
      title: Constants.locale.micPermissionTitle.tr,
      message: Constants.locale.micPermissionMessage.tr,
      confirmLabel: Constants.locale.openSettings.tr,
    );

    if (openSettings) {
      await openAppSettings();
    }
  }

  void _resetRecordingUiState() {
    isRecording.value = false;
    recordingSeconds.value = 0;
    voiceLevel.value = 0;
  }

  Future<void> _cleanupRecording({required bool discardFile}) async {
    _recordingTimer?.cancel();
    await _amplitudeSub?.cancel();
    _amplitudeSub = null;

    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (_) {}

    if (discardFile && _activeRecordingPath != null) {
      await _deleteRecordingFile(_activeRecordingPath!);
    }

    _activeRecordingPath = null;
    _resetRecordingUiState();
  }

  Future<void> _deleteRecordingFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('🤖 [AiController] Error deleting recording file: $e');
    }
  }

  // ============================================================
  // TEXT-TO-SPEECH
  // ============================================================
  Future<void> speakMessage(AiMessageModel msg) async {
    final text = msg.content.trim();
    if (text.isEmpty) {
      AppSnackbar.error(Constants.locale.aiTtsEmpty.tr);
      return;
    }

    if (activeTtsMessageId.value == msg.id && _ttsPlayer.playing) {
      await _stopTtsPlayback();
      return;
    }

    await _stopTtsPlayback();

    if (_cachedTtsMessageId != null && _cachedTtsMessageId != msg.id) {
      await _clearTtsCache();
    }

    activeTtsMessageId.value = msg.id;

    if (_cachedTtsMessageId == msg.id && _cachedTtsFilePath != null) {
      final file = File(_cachedTtsFilePath!);
      if (await file.exists()) {
        await _playTtsFile(_cachedTtsFilePath!);
        return;
      }
      await _clearTtsCache();
    }

    isTtsLoading.value = true;

    try {
      final response = await _ai.textToSpeech(text);
      if (!response.success || response.bytes == null) {
        AppSnackbar.error(response.error ?? Constants.locale.aiTtsFailed.tr);
        activeTtsMessageId.value = null;
        isTtsLoading.value = false;
        return;
      }

      if (activeTtsMessageId.value != msg.id) {
        isTtsLoading.value = false;
        return;
      }

      isTtsLoading.value = false;
      await _cacheAndPlayTts(msg.id, response.bytes!);
    } catch (e) {
      debugPrint('🤖 [AiController] Error playing TTS: $e');
      AppSnackbar.error(Constants.locale.aiTtsFailed.tr);
      activeTtsMessageId.value = null;
      isTtsLoading.value = false;
    }
  }

  Future<void> stopSpeaking() async {
    await _stopTtsPlayback();
  }

  Future<void> _stopTtsPlayback() async {
    _ttsStateSub?.cancel();
    _ttsStateSub = null;
    await _ttsPlayer.stop();
    activeTtsMessageId.value = null;
    isTtsLoading.value = false;
  }

  Future<void> _clearTtsCache() async {
    if (_cachedTtsFilePath != null) {
      await _deleteRecordingFile(_cachedTtsFilePath!);
    }
    _cachedTtsMessageId = null;
    _cachedTtsFilePath = null;
  }

  Future<void> _cacheAndPlayTts(String messageId, Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/tts_$messageId.mp3';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    _cachedTtsMessageId = messageId;
    _cachedTtsFilePath = path;
    await _playTtsFile(path);
  }

  Future<void> _playTtsFile(String path) async {
    await _ttsPlayer.setFilePath(path);
    _ttsStateSub?.cancel();
    _ttsStateSub = _ttsPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        unawaited(_stopTtsPlayback());
      }
    });
    await _ttsPlayer.play();
  }
}
