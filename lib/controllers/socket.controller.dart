// lib/controllers/socket.controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/design/components/components.dart';
import 'package:rexone_mobile/services/services.dart';
import '../modules/ai/ai.dart';
import '../modules/payment/payment.dart';

/// Single, permanent socket event router.
///
/// Subscribes to [SocketService.stream] once for the lifetime of the app.
/// All snackbar display and per-controller data refresh go here.
/// No other controller should call `socket.stream.listen`.
///
/// To add a new notification type: edit [_showSnackbar] and/or [_dispatch].
/// SpeechLiveChannel events are handled in [_handleSpeechEvent].
class SocketController extends GetxController {
  late final SocketService _socket;
  StreamSubscription<SocketMessage>? _sub;

  @override
  void onInit() {
    super.onInit();
    _socket = Get.find<SocketService>();
    _sub = _socket.stream.listen(_handleEvent);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  // ============================================================
  // ENTRY POINT
  // ============================================================

  Future<void> _handleEvent(SocketMessage event) async {
    if (event.channel == SpeechKeys.channel ||
        ((event.channel == null || event.channel!.isEmpty) &&
            _isSpeechPayload(event))) {
      _handleSpeechEvent(event);
      return;
    }

    if (event.type != SocketKeys.notification) return;

    final eventType = EWsEventType.fromString(
      event.data?[SocketKeys.type]?.toString() ?? '',
    );
    final message = event.message ?? '';

    debugPrint('🔔 [SocketController] type=$eventType | message="$message"');

    await _dispatch(event, eventType);
    _showSnackbar(eventType, message);
  }

  void _handleSpeechEvent(SocketMessage event) {
    final eventType = ESpeechEventType.fromString(
      event.data?[SocketKeys.type]?.toString() ?? '',
    );
    debugPrint(
      '🎤 [SocketController] speech=$eventType | message="${event.message}"',
    );

    if (Get.isRegistered<AiController>()) {
      Get.find<AiController>().onSpeechEvent(event, eventType);
    }

    if (eventType == ESpeechEventType.error) {
      final message = event.message ?? '';
      if (message.isNotEmpty) {
        AppSnackbar.error(message);
      }
    }
  }

  bool _isSpeechPayload(SocketMessage event) {
    final dataType = event.data?[SocketKeys.type]?.toString() ?? '';
    return dataType == SpeechKeys.partial ||
        dataType == SpeechKeys.finalPhrase ||
        dataType == SpeechKeys.error;
  }

  // ============================================================
  // SNACKBAR — single source of truth for all socket toasts
  // ============================================================

  void _showSnackbar(EWsEventType eventType, String message) {
    if (message.isEmpty) return;

    switch (eventType) {
      case EWsEventType.paymentSuccess:
      case EWsEventType.subscriptionCreated:
      case EWsEventType.welcome:
      case EWsEventType.aiResponseReady:
        AppSnackbar.success(message);
        break;

      case EWsEventType.paymentFailed:
      case EWsEventType.aiResponseFailed:
        AppSnackbar.error(message);
        break;

      // subscription_canceled / subscription_resumed:
      // PaymentController's HTTP response already shows the right snackbar
      // immediately on user action — skip here to avoid a duplicate.
      case EWsEventType.subscriptionCanceled:
      case EWsEventType.subscriptionResumed:
        break;
      default:
        AppSnackbar.info(message);
    }
  }

  // ============================================================
  // DISPATCH — per-controller data refresh / navigation
  // ============================================================

  Future<void> _dispatch(SocketMessage event, EWsEventType eventType) async {
    // --- Payment ---
    if (Get.isRegistered<PaymentController>()) {
      await Get.find<PaymentController>().onSocketEvent(
        eventType,
        event.message,
      );
    }

    // --- AI ---
    if (Get.isRegistered<AiController>()) {
      final roomId = event.data?[AiKeys.roomId]?.toString();
      await Get.find<AiController>().onSocketEvent(eventType, roomId);
    }
  }
}
