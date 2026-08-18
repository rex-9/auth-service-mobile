// lib/services/socket.service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/config/config.dart';

class SocketMessage {
  final String type;
  final String? message;
  final Map<String, dynamic>? data;
  final String? createdAt;

  SocketMessage({required this.type, this.message, this.data, this.createdAt});

  factory SocketMessage.fromJson(Map<String, dynamic> json) {
    return SocketMessage(
      type: json['type']?.toString() ?? '',
      message: json['message']?.toString(),
      data: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'])
          : null,
      createdAt: json['created_at']?.toString(),
    );
  }
}

class SocketService extends GetxService with WidgetsBindingObserver {
  WebSocket? _ws;
  String? _token;
  bool _isConnecting = false;
  final RxBool isConnected = false.obs;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  Timer? _reconnectTimer;
  bool _isInBackground = false;

  final StreamController<SocketMessage> _streamController =
      StreamController<SocketMessage>.broadcast();

  Stream<SocketMessage> get stream => _streamController.stream;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    _streamController.close();
    super.onClose();
  }

  // ============================================================
  // APP LIFECYCLE — pause/resume reconnects around background events
  // (e.g. Stripe checkout, Google auth, in-app browser)
  // ============================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // App went to background — set flag so any _handleDone that fires
        // after this point (OS kills TCP asynchronously) won't schedule a
        // reconnect that times out while the browser is in the foreground.
        _isInBackground = true;
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
        debugPrint('🔌 [SocketService] App backgrounded — reconnects paused');

      case AppLifecycleState.resumed:
        _isInBackground = false;
        if (_token != null && !isConnected.value && !_isConnecting) {
          debugPrint('🔌 [SocketService] App resumed — reconnecting...');
          _reconnectAttempts = 0;
          connect(_token);
        }

      default:
        break;
    }
  }

  // ============================================================
  // CONNECTION MANAGEMENT
  // ============================================================

  void connect(String? token) async {
    if (_isConnecting) {
      debugPrint('🔌 [SocketService] Connection already in progress');
      return;
    }

    if (token == null || token.trim().isEmpty) {
      debugPrint('🔌 [SocketService] No token provided, skipping WebSocket');
      disconnect();
      return;
    }

    final cleanToken = token.replaceAll('"', '').trim();
    if (_ws != null && isConnected.value && _token == cleanToken) {
      return;
    }

    _cleanup();
    _token = cleanToken;
    _isConnecting = true;

    final wsUrl = '${AppConfig.wsBaseUrl}/cable?token=$_token';

    debugPrint('🔌 [SocketService] Connecting to WebSocket: $wsUrl');

    try {
      _ws = await WebSocket.connect(wsUrl).timeout(const Duration(seconds: 10));

      _isConnecting = false;
      isConnected.value = true;
      _reconnectAttempts = 0;
      debugPrint('🔌 [SocketService] WebSocket connected successfully');

      // Subscribe to NotificationChannel immediately upon opening
      _subscribe('NotificationChannel');

      _ws!.listen(
        _handleMessage,
        onDone: _handleDone,
        onError: _handleError,
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('🔌 [SocketService] WebSocket connection error: $e');
      _isConnecting = false;
      isConnected.value = false;
      _scheduleReconnect();
    }
  }

  void disconnect() {
    _token = null;
    _isConnecting = false;
    _reconnectAttempts = 0;
    _cleanup();
  }

  void _cleanup() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    if (_ws != null) {
      try {
        _ws!.close();
      } catch (_) {}
      _ws = null;
    }

    isConnected.value = false;
  }

  // ============================================================
  // PROTOCOL & MESSAGE HANDLING
  // ============================================================

  void _subscribe(String channel) {
    final message = {
      'command': 'subscribe',
      'identifier': jsonEncode({'channel': channel}),
    };
    send(message);
  }

  void send(Map<String, dynamic> data) {
    if (_ws != null && isConnected.value) {
      try {
        _ws!.add(jsonEncode(data));
      } catch (e) {
        debugPrint('📨 [SocketService] Failed to send message: $e');
      }
    } else {
      debugPrint('📨 [SocketService] Cannot send, socket is not connected');
    }
  }

  void _handleMessage(dynamic raw) {
    try {
      final Map<String, dynamic> data = jsonDecode(raw.toString());
      final frameType = data['type']?.toString();

      // Welcome message
      if (frameType == 'welcome') {
        debugPrint('👋 [SocketService] Action Cable welcome');
        return;
      }

      // Ping keepalive — silent
      if (frameType == 'ping') {
        return;
      }

      // Subscription confirmation
      if (frameType == 'confirm_subscription') {
        debugPrint(
          '✅ [SocketService] Subscription confirmed: ${data['identifier']}',
        );
        return;
      }

      // Reject (bad token / auth failure)
      if (frameType == 'reject_subscription') {
        debugPrint(
          '🚫 [SocketService] Subscription REJECTED: ${data['identifier']}',
        );
        return;
      }

      // Action Cable channel broadcast wrapper: { type: null, message: { type, message, data, created_at } }
      if (data['message'] != null && data['message'] is Map) {
        final payload = Map<String, dynamic>.from(data['message']);
        final msgType = payload['type']?.toString() ?? '?';
        final msgText = payload['message']?.toString() ?? '';
        final msgData = payload['data'];
        debugPrint(
          '📨 [SocketService] Broadcast received'
          ' | type=$msgType'
          ' | message="$msgText"'
          ' | data=$msgData',
        );
        final socketMsg = SocketMessage.fromJson(payload);
        _notifyListeners(socketMsg);
        return;
      }

      // Unknown frame — log it so we can debug
      debugPrint(
        '⚠️ [SocketService] Unhandled frame type=$frameType | raw=$raw',
      );
    } catch (e) {
      debugPrint('⚠️ [SocketService] JSON parse error: $e | raw=$raw');
    }
  }

  void _handleDone() {
    debugPrint('🔌 [SocketService] WebSocket connection closed');
    isConnected.value = false;
    _isConnecting = false;
    if (_token != null) {
      _scheduleReconnect();
    }
  }

  void _handleError(dynamic error) {
    debugPrint('❌ [SocketService] WebSocket runtime error: $error');
  }

  void _scheduleReconnect() {
    if (_isInBackground) {
      // WebSocket closed while app is backgrounded (e.g. Stripe checkout open).
      // Don't try to reconnect — didChangeAppLifecycleState(resumed) will do it.
      debugPrint(
        '🔄 [SocketService] Skipping reconnect — app is in background',
      );
      return;
    }
    if (_reconnectAttempts < _maxReconnectAttempts && _token != null) {
      _reconnectAttempts++;
      final delay = Duration(seconds: 2 * _reconnectAttempts);
      debugPrint(
        '🔄 [SocketService] Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)...',
      );

      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(delay, () {
        if (_token != null && !_isInBackground) {
          connect(_token);
        }
      });
    } else {
      debugPrint('❌ [SocketService] Max reconnect attempts reached');
      _isConnecting = false;
    }
  }

  // ============================================================
  // BROADCAST
  // ============================================================

  /// Broadcasts [msg] to all [stream] subscribers.
  /// [SocketController] is the single subscriber for the app lifetime.
  void _notifyListeners(SocketMessage msg) {
    _streamController.add(msg);
  }
}
