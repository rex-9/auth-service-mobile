// test/modules/notification/controllers/notification_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/modules/notification/notification.dart';
import 'package:rexone_mobile/services/socket.service.dart';
import '../../../mocks/test_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeNotificationService fakeService;
  late NotificationController controller;

  setUp(() {
    Get.testMode = true;
    fakeService = FakeNotificationService();
    Get.put<NotificationService>(fakeService);
    controller = Get.put(NotificationController());
  });

  tearDown(() {
    Get.reset();
  });

  group('NotificationController - Fetch & Pagination', () {
    test('fetchUnreadCount sets unreadCount observable', () async {
      fakeService.unreadCount = 7;
      await controller.fetchUnreadCount();
      expect(controller.unreadCount.value, equals(7));
    });

    test('fetchNotifications populates notifications list and pagination', () async {
      final notifs = [
        NotificationModel(
          id: 'n_1',
          title: 'Title 1',
          message: 'Message 1',
          read: false,
          createdAt: DateTime.now(),
        ),
        NotificationModel(
          id: 'n_2',
          title: 'Title 2',
          message: 'Message 2',
          read: true,
          createdAt: DateTime.now(),
        ),
      ];

      fakeService.notificationsResponse = PaginatedResponse<NotificationModel>(
        records: notifs,
        message: 'OK',
        statusCode: 200,
        success: true,
        pagination: const PaginationMeta(
          currentPage: 1,
          totalPages: 2,
          totalCount: 2,
          limit: 20,
          nextPage: 2,
        ),
      );

      await controller.fetchNotifications();

      expect(controller.notifications.length, equals(2));
      expect(controller.notifications.first.id, equals('n_1'));
      expect(controller.hasMore.value, isTrue);
    });

    test('changeFilter switches filter and fetches notifications', () async {
      fakeService.notificationsResponse = const PaginatedResponse<NotificationModel>(
        records: [],
        message: 'OK',
        statusCode: 200,
        success: true,
      );

      await controller.changeFilter(NotificationConstants.filterUnread);

      expect(controller.currentFilter.value, equals(NotificationConstants.filterUnread));
    });
  });

  group('NotificationController - Read and Delete Operations', () {
    test('markAsRead updates item state and decrements unread count', () async {
      final notif = NotificationModel(
        id: 'n_unread_1',
        title: 'New',
        message: 'Msg',
        read: false,
        createdAt: DateTime.now(),
      );

      controller.notifications.assignAll([notif]);
      controller.unreadCount.value = 3;

      await controller.markAsRead(notif);

      expect(controller.notifications.first.read, isTrue);
      expect(controller.unreadCount.value, equals(2));
      expect(fakeService.markedReadIds, contains('n_unread_1'));
    });

    test('markAllAsRead marks all notifications as read and resets unread count to 0', () async {
      final notifs = [
        NotificationModel(
          id: 'n_1',
          title: '1',
          message: '1',
          read: false,
          createdAt: DateTime.now(),
        ),
        NotificationModel(
          id: 'n_2',
          title: '2',
          message: '2',
          read: false,
          createdAt: DateTime.now(),
        ),
      ];

      controller.notifications.assignAll(notifs);
      controller.unreadCount.value = 2;

      await controller.markAllAsRead();

      expect(controller.notifications.every((n) => n.read), isTrue);
      expect(controller.unreadCount.value, equals(0));
      expect(fakeService.markedAllRead, isTrue);
    });

    test('deleteNotification removes item and decrements unread count if unread', () async {
      final notif = NotificationModel(
        id: 'n_del',
        title: 'Delete me',
        message: 'Msg',
        read: false,
        createdAt: DateTime.now(),
      );

      controller.notifications.assignAll([notif]);
      controller.unreadCount.value = 1;

      await controller.deleteNotification(notif);

      expect(controller.notifications, isEmpty);
      expect(controller.unreadCount.value, equals(0));
      expect(fakeService.deletedIds, contains('n_del'));
    });

    test('onSocketNotification inserts incoming notification at top', () {
      final event = SocketMessage(
        type: SocketKeys.notification,
        data: {
          'id': 'socket_n_1',
          'title': 'Realtime Title',
          'message': 'Realtime Message',
          'read': false,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      fakeService.unreadCount = 10;
      controller.onSocketNotification(event);

      expect(controller.notifications.first.id, equals('socket_n_1'));
    });
  });
}
