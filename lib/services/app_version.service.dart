import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';
import 'package:rexone_mobile/helpers/helpers.dart';
import 'package:rexone_mobile/models/models.dart';
import 'package:rexone_mobile/routes/routes.dart';
import 'package:rexone_mobile/services/api.service.dart';

class AppVersionService extends GetxService {
  late final ApiService _api;

  @override
  void onInit() {
    super.onInit();
    _api = Get.find<ApiService>();
  }

  Future<ApiResponse<AppVersionModel>> getCurrent(String appVersion) async {
    final response = await _api.get(
      ServerRoutes.currentAppVersion,
      query: {AppVersionKeys.appVersion: appVersion},
      showLoading: false,
    );
    return _api.parseResponse<AppVersionModel>(response, (data) {
      final record = data is Map && data[AppVersionKeys.appVersion] is Map
          ? data[AppVersionKeys.appVersion]
          : data;
      return ApiHelper.parseRecord<AppVersionModel>(
        record,
        AppVersionModel.fromJson,
      );
    });
  }
}
