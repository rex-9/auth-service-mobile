// test/modules/profile/controllers/profile_controller_test.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/locales/app_translations.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/modules/auth/auth.dart';
import 'package:rexone_mobile/modules/profile/profile.dart';
import 'package:rexone_mobile/services/analytics.service.dart';
import 'package:rexone_mobile/services/media.service.dart';
import 'package:rexone_mobile/services/permission.service.dart';
import 'package:rexone_mobile/services/push_noti.service.dart';
import 'package:rexone_mobile/services/socket.service.dart';
import 'package:rexone_mobile/services/storage.service.dart';
import '../../../mocks/test_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeProfileService fakeProfile;
  late FakeStorageService fakeStorage;
  late FakePermissionService fakePermissions;
  late FakeMediaService fakeMedia;
  late FakeAuthService fakeAuth;
  late FakeAnalyticsService fakeAnalytics;
  late FakePushNotiService fakePush;
  late FakeSocketService fakeSocket;

  setUpAll(() {
    Get.addTranslations(AppTranslations().keys);
    Get.locale = const Locale('en');
  });

  setUp(() {
    Get.testMode = true;
    fakeProfile = FakeProfileService();
    fakeStorage = FakeStorageService();
    fakePermissions = FakePermissionService();
    fakeMedia = FakeMediaService();
    fakeAuth = FakeAuthService();
    fakeAnalytics = FakeAnalyticsService();
    fakePush = FakePushNotiService();
    fakeSocket = FakeSocketService();

    Get.put<ProfileService>(fakeProfile);
    Get.put<StorageService>(fakeStorage);
    Get.put<PermissionService>(fakePermissions);
    Get.put<MediaService>(fakeMedia);
    Get.put<AuthService>(fakeAuth);
    Get.put<AnalyticsService>(fakeAnalytics);
    Get.put<PushNotiService>(fakePush);
    Get.put<SocketService>(fakeSocket);
  });

  tearDown(() {
    Get.reset();
  });

  group('ProfileController - Initialization', () {
    test('populates form fields and photoUrl from cached storage user', () {
      final cachedUser = UserModel(
        id: 'usr_abc',
        name: 'Jane Doe',
        username: 'janedoe',
        email: 'jane@example.com',
        photo: 'https://garage.example.com/jane.png',
      );
      fakeStorage.setUserData(cachedUser);

      final controller = Get.put(ProfileController());

      expect(controller.nameController.text, equals('Jane Doe'));
      expect(controller.usernameController.text, equals('janedoe'));
      expect(controller.emailController.text, equals('jane@example.com'));
      expect(controller.photoUrl.value, equals('https://garage.example.com/jane.png'));
    });

    test('initializes with empty text when storage has no cached user', () {
      final controller = Get.put(ProfileController());

      expect(controller.nameController.text, isEmpty);
      expect(controller.usernameController.text, isEmpty);
      expect(controller.emailController.text, isEmpty);
      expect(controller.photoUrl.value, isNull);
    });
  });

  group('ProfileController - Validation Guardrails', () {
    test('aborts save if full name is invalid', () async {
      fakeStorage.setUserData(UserModel(id: 'u1', name: 'Valid Name', username: 'valid_user', email: 'u1@example.com'));
      final controller = Get.put(ProfileController());

      // Too short
      controller.nameController.text = 'A';
      controller.usernameController.text = 'valid_user';

      await controller.save();

      expect(fakeProfile.lastUpdateRequest, isNull);

      // Forbidden characters
      controller.nameController.text = 'Invalid<Name>';
      await controller.save();

      expect(fakeProfile.lastUpdateRequest, isNull);
    });

    test('aborts save if username is invalid', () async {
      fakeStorage.setUserData(UserModel(id: 'u1', name: 'Valid Name', username: 'valid_user', email: 'u1@example.com'));
      final controller = Get.put(ProfileController());

      // Too short
      controller.nameController.text = 'Valid Name';
      controller.usernameController.text = 'ab';

      await controller.save();

      expect(fakeProfile.lastUpdateRequest, isNull);

      // Invalid characters
      controller.usernameController.text = 'invalid-user!';
      await controller.save();

      expect(fakeProfile.lastUpdateRequest, isNull);
    });
  });

  group('ProfileController - Save Flow', () {
    test('saves successfully and updates storage, AuthController, and photoUrl', () async {
      final initialUser = UserModel(
        id: 'u1',
        name: 'Initial Name',
        username: 'initial_user',
        email: 'user@example.com',
        photo: 'https://garage.example.com/initial.png',
      );
      fakeStorage.setUserData(initialUser);

      final authController = Get.put(AuthController());
      authController.currentUser.value = initialUser;

      final controller = Get.put(ProfileController());
      controller.nameController.text = 'Updated Name';
      controller.usernameController.text = 'updated_user';

      fakeProfile.updateResponse = ApiResponse.success(
        message: 'Updated',
        statusCode: 200,
        data: UserModel(
          id: 'u1',
          name: 'Updated Name',
          username: 'updated_user',
          email: 'user@example.com',
          photo: 'https://garage.example.com/new_avatar.png',
        ),
      );

      await controller.save();

      expect(fakeProfile.lastUpdateRequest?.name, equals('Updated Name'));
      expect(fakeProfile.lastUpdateRequest?.username, equals('updated_user'));
      expect(controller.photoUrl.value, equals('https://garage.example.com/new_avatar.png'));
      expect(fakeStorage.getUserData()?.name, equals('Updated Name'));
      expect(authController.currentUser.value?.name, equals('Updated Name'));
    });

    test('uploads image if pickedImagePath is set before updating profile', () async {
      final initialUser = UserModel(
        id: 'u1',
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      );
      fakeStorage.setUserData(initialUser);

      final controller = Get.put(ProfileController());
      controller.nameController.text = 'John Doe';
      controller.usernameController.text = 'johndoe';
      controller.pickedImagePath.value = '/tmp/fake_photo.jpg';

      await controller.save();

      expect(fakeMedia.lastUploadedFilePath, equals('/tmp/fake_photo.jpg'));
      expect(fakeMedia.lastUploadedType, equals(AssetKeys.typeAvatar));
      expect(fakeMedia.lastUploadedAssetableType, equals(AssetKeys.assetableUser));
      expect(fakeMedia.lastUploadedAssetableId, equals('u1'));
      expect(fakeProfile.lastUpdateRequest, isNotNull);
    });

    test('aborts profile update if image upload fails', () async {
      final initialUser = UserModel(
        id: 'u1',
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      );
      fakeStorage.setUserData(initialUser);

      final controller = Get.put(ProfileController());
      controller.nameController.text = 'John Doe';
      controller.usernameController.text = 'johndoe';
      controller.pickedImagePath.value = '/tmp/bad_photo.jpg';

      fakeMedia.uploadResponse = ApiResponse.error(
        message: 'Upload failed',
        statusCode: 400,
      );

      await controller.save();

      expect(fakeMedia.lastUploadedFilePath, equals('/tmp/bad_photo.jpg'));
      expect(fakeProfile.lastUpdateRequest, isNull);
    });

    test('handles profile update failure without caching or desyncing state', () async {
      final initialUser = UserModel(
        id: 'u1',
        name: 'Original Name',
        username: 'original_user',
        email: 'original@example.com',
      );
      fakeStorage.setUserData(initialUser);

      final controller = Get.put(ProfileController());
      controller.nameController.text = 'New Name';
      controller.usernameController.text = 'new_user';

      fakeProfile.updateResponse = ApiResponse.error(
        message: 'Update rejected',
        statusCode: 422,
      );

      await controller.save();

      expect(fakeStorage.getUserData()?.name, equals('Original Name'));
    });
  });

  group('ProfileController - Camera Permission', () {
    test('pickFromCamera does not proceed if camera permission denied', () async {
      fakePermissions.ensureCameraResult = false;
      final controller = Get.put(ProfileController());

      await controller.pickFromCamera();

      expect(controller.pickedImagePath.value, isNull);
    });
  });
}
