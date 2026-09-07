// test/services/permission_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rexone_mobile/services/permission.service.dart';
import '../mocks/test_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePermissionService fakePermissions;

  setUp(() {
    Get.testMode = true;
    fakePermissions = FakePermissionService();
    Get.put<PermissionService>(fakePermissions);
  });

  tearDown(() {
    Get.reset();
  });

  group('PermissionService Contract & Fake Implementation', () {
    test('isAllowed returns granted status', () async {
      fakePermissions.allowedResult = true;
      final result = await fakePermissions.isAllowed(Permission.camera);
      expect(result, isTrue);

      fakePermissions.allowedResult = false;
      final deniedResult = await fakePermissions.isAllowed(Permission.camera);
      expect(deniedResult, isFalse);
    });

    test('request delegates to permission handler logic', () async {
      fakePermissions.allowedResult = true;
      expect(await fakePermissions.request(Permission.microphone), isTrue);

      fakePermissions.allowedResult = false;
      expect(await fakePermissions.request(Permission.microphone), isFalse);
    });

    test('ensure returns true when permission is allowed', () async {
      fakePermissions.allowedResult = true;
      final result = await fakePermissions.ensure(
        Permission.camera,
        title: 'Camera',
        message: 'Need camera',
      );
      expect(result, isTrue);
      expect(fakePermissions.promptSettingsCalled, isFalse);
    });

    test('ensureCamera checks camera permission', () async {
      fakePermissions.ensureCameraResult = true;
      expect(await fakePermissions.ensureCamera(), isTrue);

      fakePermissions.ensureCameraResult = false;
      expect(await fakePermissions.ensureCamera(), isFalse);
    });

    test('requestMicrophone delegates to microphone permission', () async {
      fakePermissions.requestMicResult = true;
      expect(await fakePermissions.requestMicrophone(), isTrue);

      fakePermissions.requestMicResult = false;
      expect(await fakePermissions.requestMicrophone(), isFalse);
    });

    test('promptPhotosIfDenied prompts when denied', () async {
      fakePermissions.allowedResult = false;
      await fakePermissions.promptPhotosIfDenied();
      expect(fakePermissions.promptPhotosCalled, isTrue);
    });

    test('promptPhotosIfDenied does not prompt when allowed', () async {
      fakePermissions.allowedResult = true;
      await fakePermissions.promptPhotosIfDenied();
      expect(fakePermissions.promptPhotosCalled, isFalse);
    });
  });
}
