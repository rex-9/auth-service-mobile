import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:meritbox_mobile/config/config.dart';
import 'package:meritbox_mobile/models/models.dart';

class PushNotiService extends GetxService {
  @override
  void onInit() {
    super.onInit();
    _initOneSignal();
  }

  void _initOneSignal() {
    // Initialize OneSignal without requesting permission
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(AppConfig.oneSignalAppId);
    print('✅ OneSignal initialized');
  }

  // Request notification permission (call after onboarding/signin)
  Future<void> requestPermission() async {
    try {
      await OneSignal.Notifications.requestPermission(true);
      print('✅ Push permission requested');
    } catch (e) {
      print('❌ Failed to request permission:===> $e');
    }
  }

  // Sync user data with OneSignal (call after auth)
  Future<void> syncUser(UserModel user) async {
    try {
      OneSignal.login(user.id);
      await OneSignal.User.addEmail(user.email);
      // 2 ok, 4 not ok probably max 3 tags for free plan
      OneSignal.User.addTags({'username': user.username ?? ''});
      print('✅ OneSignal synced for user:===> ${user.email}');
    } catch (e) {
      print('❌ Failed to sync OneSignal:===> $e');
    }
  }

  // Clear user data (call on logout)
  Future<void> clearUser() async {
    try {
      OneSignal.logout();
      print('✅ OneSignal user cleared');
    } catch (e) {
      print('❌ Failed to clear OneSignal:===> $e');
    }
  }
}
