
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/helpers/helpers.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/api.service.dart';

class VersionService extends GetxService {
  late final ApiService _api;

  @override
  void onInit() {
    super.onInit();
    _api = Get.find<ApiService>();
  }

  Future<ApiResponse<VersionModel>> getCurrent(String version) async {
    final response = await _api.get(
      ServerRoutes.currentVersion,
      query: {VersionKeys.version: version},
      showLoading: false,
    );
    return _api.parseResponse<VersionModel>(response, (data) {
      final record = data is Map && data[VersionKeys.version] is Map
          ? data[VersionKeys.version]
          : data;
      return ApiHelper.parseRecord<VersionModel>(
        record,
        VersionModel.fromJson,
      );
    });
  }

  Future<ApiResponse<UserVersionModel>> reportUserVersion({
    required String version,
    required int versionCode,
  }) async {
    final response = await _api.post(
      ServerRoutes.userVersion,
      {
        VersionKeys.userVersion: {
          VersionKeys.version: version,
          VersionKeys.versionCode: versionCode,
        },
      },
      showLoading: false,
    );
    return _api.parseResponse<UserVersionModel>(response, (data) {
      final record = data is Map && data[VersionKeys.userVersion] is Map
          ? data[VersionKeys.userVersion]
          : data;
      return ApiHelper.parseRecord<UserVersionModel>(
        record,
        UserVersionModel.fromJson,
      );
    });
  }
}
