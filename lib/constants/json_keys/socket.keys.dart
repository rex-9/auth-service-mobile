/// Keys for WebSocket event messages.
class SocketKeys {
  const SocketKeys._();

  static const type = 'type';
  static const message = 'message';
  static const data = 'data';
  static const createdAt = 'created_at';

  static const command = 'command';
  static const identifier = 'identifier';
  static const channel = 'channel';
  static const subscribe = 'subscribe';
  static const unsubscribe = 'unsubscribe';
  static const notification = 'notification';
  static const notificationChannel = 'NotificationChannel';
}
