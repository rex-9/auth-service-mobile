// lib/constants/socket_constants.dart

/// Centralized Action Cable and WebSocket protocol constants.
class SocketConstants {
  const SocketConstants._();

  // Action Cable Commands
  static const subscribe = 'subscribe';
  static const unsubscribe = 'unsubscribe';
  static const message = 'message';

  // Action Cable Channels
  static const notificationChannel = 'NotificationChannel';

  // Action Cable Message Types
  static const welcome = 'welcome';
  static const ping = 'ping';
  static const confirmSubscription = 'confirm_subscription';
  static const rejectSubscription = 'reject_subscription';

  // Protocol Keys
  static const command = 'command';
  static const identifier = 'identifier';
  static const channel = 'channel';
  static const type = 'type';
  static const data = 'data';
}
