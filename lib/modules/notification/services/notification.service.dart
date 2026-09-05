// lib/modules/notification/services/notification.service.dart
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/api.service.dart';

class NotificationService extends GetxService {
  late final ApiService _api;

  @override
  void onInit() {
    super.onInit();
    _api = Get.find<ApiService>();
  }

  /// Fetch paginated notifications with optional filter ('all', 'unread', 'read')
  Future<PaginatedResponse<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
    String filter = NotificationConstants.filterAll,
  }) async {
    final query = <String, dynamic>{
      ApiKeys.page: page.toString(),
      ApiKeys.limit: limit.toString(),
    };

    if (filter != NotificationConstants.filterAll) {
      query[NotificationKeys.filter] = filter;
    }

    final response = await _api.get(
      ServerRoutes.notifications,
      query: query,
      showLoading: false,
    );

    return _api.parsePaginatedResponse<NotificationModel>(
      response,
      (item) => NotificationModel.fromJson(
        item is Map<String, dynamic>
            ? item
            : Map<String, dynamic>.from(item as Map),
      ),
    );
  }

  /// Fetch total unread notification count for badge
  Future<int> getUnreadCount() async {
    try {
      final response = await _api.get(
        ServerRoutes.unreadNotificationsCount,
        showLoading: false,
      );

      final res = _api.parseResponse<Map<String, dynamic>>(
        response,
        (data) => data is Map<String, dynamic>
            ? data
            : Map<String, dynamic>.from(data as Map),
      );

      if (res.success && res.data != null) {
        return (res.data![NotificationKeys.unreadCount] as num?)?.toInt() ?? 0;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  /// Mark single notification as read
  Future<ApiResponse<NotificationModel>> markAsRead(String id) async {
    final response = await _api.put(
      ServerRoutes.readNotification(id),
      {},
      showLoading: false,
    );

    return _api.parseResponse<NotificationModel>(
      response,
      (item) => NotificationModel.fromJson(
        item is Map<String, dynamic>
            ? item
            : Map<String, dynamic>.from(item as Map),
      ),
    );
  }

  /// Mark all user notifications as read
  Future<ApiResponse<Map<String, dynamic>>> markAllAsRead() async {
    final response = await _api.put(
      ServerRoutes.readAllNotifications,
      {},
      showLoading: false,
    );

    return _api.parseResponse<Map<String, dynamic>>(
      response,
      (item) => item is Map<String, dynamic>
          ? item
          : Map<String, dynamic>.from(item as Map),
    );
  }

  /// Delete an individual notification
  Future<ApiResponse<dynamic>> deleteNotification(String id) async {
    final response = await _api.delete(
      ServerRoutes.deleteNotification(id),
      showLoading: false,
    );

    return _api.parseResponse<dynamic>(response, (item) => item);
  }
}
