// test/models/asset_upload_response_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/models/responses/asset.response.dart';

void main() {
  group('StorageDetails', () {
    test('parses json with all fields', () {
      final json = {
        AssetKeys.storageKey: 'avatars/usr_123.jpg',
        AssetKeys.bytes: 2048,
        AssetKeys.format: 'jpg',
      };

      final details = StorageDetails.fromJson(json);

      expect(details.storageKey, equals('avatars/usr_123.jpg'));
      expect(details.bytes, equals(2048));
      expect(details.format, equals('jpg'));
    });

    test('handles missing or null fields gracefully', () {
      final details = StorageDetails.fromJson(const {});

      expect(details.storageKey, isEmpty);
      expect(details.bytes, equals(0));
      expect(details.format, isEmpty);
    });
  });

  group('AssetUploadResponse', () {
    test('parses full json response with asset and storageDetails', () {
      final json = {
        AssetKeys.asset: {
          ApiKeys.id: 'ast_999',
          AssetKeys.name: 'profile_pic.png',
          AssetKeys.url: 'https://garage.example.com/rexone/profile_pic.png',
          AssetKeys.type: AssetKeys.typeAvatar,
          AssetKeys.format: 'png',
          AssetKeys.sizeBytes: 4096,
          AssetKeys.source: AssetKeys.sourceUpload,
          AssetKeys.assetableType: AssetKeys.assetableUser,
          AssetKeys.assetableId: 'u_123',
        },
        AssetKeys.storageDetails: {
          AssetKeys.storageKey: 'uploads/ast_999.png',
          AssetKeys.bytes: 4096,
          AssetKeys.format: 'png',
        },
      };

      final response = AssetUploadResponse.fromJson(json);

      expect(response.asset.id, equals('ast_999'));
      expect(response.asset.name, equals('profile_pic.png'));
      expect(response.asset.url, equals('https://garage.example.com/rexone/profile_pic.png'));
      expect(response.asset.type, equals(AssetKeys.typeAvatar));
      expect(response.asset.source, equals(AssetKeys.sourceUpload));
      expect(response.asset.assetableType, equals(AssetKeys.assetableUser));
      expect(response.asset.assetableId, equals('u_123'));
      expect(response.storageDetails.storageKey, equals('uploads/ast_999.png'));
      expect(response.storageDetails.bytes, equals(4096));
      expect(response.storageDetails.format, equals('png'));
    });

    test('handles empty or non-map payload safely', () {
      final response = AssetUploadResponse.fromJson(const {});

      expect(response.asset.id, isEmpty);
      expect(response.storageDetails.storageKey, isEmpty);
      expect(response.storageDetails.bytes, equals(0));
      expect(response.storageDetails.format, isEmpty);
    });
  });
}
