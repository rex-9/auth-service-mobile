// lib/modules/ai/controllers/ai.controller.dart
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/design.dart';
import 'package:rexone_mobile/services/services.dart';

import '../ai.dart';

class AiController extends GetxController with WidgetsBindingObserver {
  final AiService _ai = Get.find<AiService>();
  late final SocketService _socket;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _ttsPlayer = AudioPlayer();

  final RxList<AiMessageModel> messages = <AiMessageModel>[].obs;
  final RxList<AiRoomModel> rooms = <AiRoomModel>[].obs;

  final RxnString currentRoomId = RxnString();
  final RxString currentRoomTitle = 'AI Assistant'.obs;

  final RxBool isProcessing = false.obs;
  final RxBool isRecording = false.obs;
  final RxDouble voiceLevel = 0.0.obs;
  final RxnString activeTtsMessageId = RxnString();
  final RxBool isTtsLoading = false.obs;

  bool _isSubmitting = false;
  bool _isStartingListen = false;
  bool _isTearingDownSpeech = false;
  bool _speechSubscribed = false;
  int _listenEpoch = 0;
  StreamSubscription<Amplitude>? _amplitudeSub;
  StreamSubscription<Uint8List>? _pcmSub;
  StreamSubscription<bool>? _connSub;
  StreamSubscription<PlayerState>? _ttsStateSub;
  String _committedText = '';
  String _partialText = '';
  String _textBeforeListen = '';
  final BytesBuilder _pcmBuffer = BytesBuilder(copy: false);

  // UI controllers — owned here so no StatefulWidget is needed in AiPage.
  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _socket = Get.find<SocketService>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
    loadRooms();
    loadHistory();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if (isRecording.value || _speechSubscribed) {
        unawaited(stopListening());
      }
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_teardownSpeech(restoreText: false));
    unawaited(_recorder.dispose());
    unawaited(_stopTtsPlayback());
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
  Future<void> onSocketEvent(
    EWsEventType eventType,
    String? roomId, {
    String? messageId,
  }) async {
    switch (eventType) {
      case EWsEventType.ttsReady:
        if (roomId == null || roomId.isEmpty || roomId == currentRoomId.value) {
          await loadHistory(currentRoomId.value ?? roomId);
        }
        _clearTtsQueue(messageId);
      case EWsEventType.ttsFailed:
        _clearTtsQueue(messageId);
      case EWsEventType.aiResponseReady:
      case EWsEventType.aiResponseFailed:
        if (roomId == null || roomId.isEmpty || roomId == currentRoomId.value) {
          await loadHistory(currentRoomId.value);
        }
      default:
        return;
    }
  }

  void _clearTtsQueue(String? messageId) {
    if (messageId != null && activeTtsMessageId.value != messageId) return;
    isTtsLoading.value = false;
    if (!_ttsPlayer.playing) {
      activeTtsMessageId.value = null;
    }
  }

  /// Called by [SocketController] for SpeechLiveChannel partial/final/error.
  ///
  /// Partials are fragments: each one is appended to the in-progress phrase.
  /// A final discards that phrase and commits only the final text.
  void onSpeechEvent(SocketMessage event, ESpeechEventType eventType) {
    switch (eventType) {
      case ESpeechEventType.partial:
        _partialText = _mergePartial(_partialText, event.message ?? '');
        _setInputText(_joinSpeech(_committedText, _partialText));
      case ESpeechEventType.finalPhrase:
        _committedText = _joinSpeech(_committedText, event.message ?? '');
        _partialText = '';
        _setInputText(_committedText);
      case ESpeechEventType.error:
        unawaited(stopListening());
      case ESpeechEventType.unknown:
        break;
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
    if (isRecording.value || activeTtsMessageId.value != null) return;
    final text = textController.text.trim();
    if (text.isEmpty) return;
    textController.clear();
    sendMessage(text);
    scrollToBottom();
  }

  // ============================================================
  // LIVE SPEECH
  // ============================================================
  Future<void> toggleListening() async {
    if (isRecording.value || _speechSubscribed || _isStartingListen) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  Future<void> startListening() async {
    if (isRecording.value ||
        isProcessing.value ||
        _isStartingListen ||
        activeTtsMessageId.value != null) {
      return;
    }

    if (!_socket.isConnected.value) {
      AppSnackbar.error(Constants.locale.aiTranscriptionFailed.tr);
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

    _isStartingListen = true;
    final epoch = ++_listenEpoch;
    try {
      _textBeforeListen = textController.text;
      _committedText = textController.text;
      _partialText = '';

      final subscribed = await _socket.subscribe(SpeechKeys.channel);
      if (epoch != _listenEpoch) {
        if (subscribed) {
          _socket.perform(SpeechKeys.channel, SpeechKeys.stop);
          _socket.unsubscribe(SpeechKeys.channel);
        }
        return;
      }
      if (!subscribed) {
        AppSnackbar.error(Constants.locale.aiTranscriptionFailed.tr);
        return;
      }
      _speechSubscribed = true;

      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: AppConstants.speechSampleRate,
          numChannels: AppConstants.speechNumChannels,
          streamBufferSize: AppConstants.speechChunkBytes,
        ),
      );
      if (epoch != _listenEpoch) {
        try {
          if (await _recorder.isRecording()) {
            await _recorder.stop();
          }
        } catch (_) {}
        return;
      }

      isRecording.value = true;
      voiceLevel.value = 0;

      _pcmSub = stream.listen(
        _onPcmChunk,
        onError: (Object e) {
          debugPrint('🤖 [AiController] PCM stream error: $e');
          unawaited(stopListening());
        },
      );

      await _amplitudeSub?.cancel();
      _amplitudeSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amplitude) {
        voiceLevel.value = _normalizeAmplitude(amplitude.current);
      });

      await _connSub?.cancel();
      _connSub = _socket.isConnected.listen((connected) {
        if (!connected && (isRecording.value || _speechSubscribed)) {
          unawaited(stopListening());
        }
      });
    } catch (e) {
      debugPrint('🤖 [AiController] Error starting live listen: $e');
      AppSnackbar.error(Constants.locale.aiStartRecordingFailed.tr);
      await _teardownSpeech(restoreText: true);
    } finally {
      _isStartingListen = false;
    }
  }

  Future<void> stopListening() async {
    if (!isRecording.value && !_speechSubscribed && !_isStartingListen) {
      return;
    }
    await _teardownSpeech(restoreText: false);
  }

  Future<void> cancelListening() async {
    if (!isRecording.value && !_speechSubscribed && !_isStartingListen) {
      return;
    }
    await _teardownSpeech(restoreText: true);
  }

  void _onPcmChunk(Uint8List chunk) {
    _pcmBuffer.add(chunk);
    if (_pcmBuffer.length >= AppConstants.speechChunkBytes) {
      _flushPcm();
    }
  }

  void _flushPcm() {
    if (_pcmBuffer.isEmpty || !_speechSubscribed) return;
    final bytes = _pcmBuffer.takeBytes();
    if (bytes.isEmpty) return;
    _socket.perform(SpeechKeys.channel, SpeechKeys.audio, {
      SpeechKeys.chunk: base64Encode(bytes),
    });
  }

  Future<void> _teardownSpeech({required bool restoreText}) async {
    if (_isTearingDownSpeech) return;
    _isTearingDownSpeech = true;
    _listenEpoch++;
    try {
      await _pcmSub?.cancel();
      _pcmSub = null;
      await _amplitudeSub?.cancel();
      _amplitudeSub = null;
      await _connSub?.cancel();
      _connSub = null;

      if (_pcmBuffer.isNotEmpty) {
        _flushPcm();
      }
      _pcmBuffer.clear();

      try {
        if (await _recorder.isRecording()) {
          await _recorder.stop();
        }
      } catch (_) {}

      if (_speechSubscribed) {
        _socket.perform(SpeechKeys.channel, SpeechKeys.stop);
        _socket.unsubscribe(SpeechKeys.channel);
        _speechSubscribed = false;
      }

      isRecording.value = false;
      voiceLevel.value = 0;

      if (restoreText) {
        _setInputText(_textBeforeListen);
      }
      _committedText = textController.text;
      _partialText = '';
    } finally {
      _isTearingDownSpeech = false;
    }
  }

  String _joinSpeech(String committed, String incoming) {
    final next = incoming.trim();
    if (next.isEmpty) return committed;
    if (committed.isEmpty) return next;
    if (committed.endsWith(' ') || committed.endsWith('\n')) {
      return '$committed$next';
    }
    return '$committed $next';
  }

  /// Fragment partials are appended. A longer/shorter revision of the same
  /// phrase (typical Azure growing partial) replaces the in-progress text.
  String _mergePartial(String current, String incoming) {
    final next = incoming.trim();
    if (next.isEmpty) return current;
    if (current.isEmpty) return next;
    final currentLower = current.toLowerCase();
    final nextLower = next.toLowerCase();
    if (nextLower.startsWith(currentLower) || currentLower.startsWith(nextLower)) {
      return next;
    }
    return _joinSpeech(current, next);
  }

  void _setInputText(String text) {
    textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
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

  // ============================================================
  // TEXT-TO-SPEECH
  // ============================================================
  Future<void> speakMessage(AiMessageModel msg) async {
    if (activeTtsMessageId.value == msg.id && _ttsPlayer.playing) {
      await _stopTtsPlayback();
      return;
    }

    await _stopTtsPlayback();

    final audioUrl = msg.audioUrl;
    if (audioUrl != null) {
      activeTtsMessageId.value = msg.id;
      try {
        await _playTtsUrl(audioUrl);
      } catch (e) {
        debugPrint('🤖 [AiController] Error playing TTS: $e');
        AppSnackbar.error(Constants.locale.aiTtsFailed.tr);
        activeTtsMessageId.value = null;
      }
      return;
    }

    if (msg.content.trim().isEmpty) {
      AppSnackbar.error(Constants.locale.aiTtsEmpty.tr);
      return;
    }

    activeTtsMessageId.value = msg.id;
    isTtsLoading.value = true;

    try {
      final response = await _ai.textToSpeech(msg.id);
      if (!response.success) {
        AppSnackbar.error(response.error ?? response.message);
        activeTtsMessageId.value = null;
        isTtsLoading.value = false;
        return;
      }

      if (activeTtsMessageId.value != msg.id) {
        isTtsLoading.value = false;
        return;
      }

      if (response.message.isNotEmpty) {
        AppSnackbar.info(response.message);
      }
    } catch (e) {
      debugPrint('🤖 [AiController] Error queueing TTS: $e');
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

  Future<void> _playTtsUrl(String url) async {
    await _ttsPlayer.setUrl(url);
    _ttsStateSub?.cancel();
    _ttsStateSub = _ttsPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        unawaited(_stopTtsPlayback());
      }
    });
    await _ttsPlayer.play();
  }
}
