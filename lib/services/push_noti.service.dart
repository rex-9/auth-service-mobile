import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth_service_mobile/services/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:auth_service_mobile/config/config.dart';
import 'package:auth_service_mobile/models/models.dart';

class PushNotiService extends GetxService {
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  @override
  void onInit() {
    super.onInit();
    _initOneSignal();
    _setupListeners();
  }

  void _initOneSignal() {
    // Initialize OneSignal without requesting permission
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(AppConfig.oneSignalAppId);
    debugPrint('✅ OneSignal initialized');
  }

  void _setupListeners() {
    // Track notification clicks
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      _analytics.logPushOpened(data ?? {});
    });
  }

  // Request notification permission (call after onboarding/signin)
  Future<void> requestPermission() async {
    try {
      await OneSignal.Notifications.requestPermission(true);
      debugPrint('✅ Push permission requested');
    } catch (e) {
      debugPrint('❌ Failed to request permission:===> $e');
    }
  }

  // Sync user data with OneSignal (call after auth)
  Future<void> syncUser(UserModel user) async {
    try {
      OneSignal.login(user.id);
      await OneSignal.User.addEmail(user.email);
      // 2 ok, 4 not ok probably max 3 tags for free plan
      OneSignal.User.addTags({'username': user.username ?? ''});
      debugPrint('✅ OneSignal synced for user:===> ${user.email}');
    } catch (e) {
      debugPrint('❌ Failed to sync OneSignal:===> $e');
    }
  }

  // Clear user data (call on logout)
  Future<void> clearUser() async {
    try {
      OneSignal.logout();
      debugPrint('✅ OneSignal user cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear OneSignal:===> $e');
    }
  }
}
