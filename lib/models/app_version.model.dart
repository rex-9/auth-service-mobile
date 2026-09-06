import 'package:rexone_mobile/constants/constants.dart';

class AppVersionModel {
  final String id;
  final String number;
  final String? title;
  final String? description;
  final String? status;
  final DateTime? releasedAt;
  final bool updateRequired;
  final bool mustUpdate;
  final bool skipPremium;
  final String? storeUrl;

  AppVersionModel({
    required this.id,
    required this.number,
    this.title,
    this.description,
    this.status,
    this.releasedAt,
    this.updateRequired = false,
    this.mustUpdate = false,
    this.skipPremium = false,
    this.storeUrl,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      number: json[AppVersionKeys.number]?.toString() ?? '',
      title: json[AppVersionKeys.title] as String?,
      description: json[AppVersionKeys.description] as String?,
      status: json[AppVersionKeys.status] as String?,
      releasedAt: json[AppVersionKeys.releasedAt] != null
          ? DateTime.tryParse(json[AppVersionKeys.releasedAt].toString())
          : null,
      updateRequired: json[AppVersionKeys.updateRequired] == true,
      mustUpdate: json[AppVersionKeys.mustUpdate] == true,
      skipPremium: json[AppVersionKeys.skipPremium] == true,
      storeUrl: json[AppVersionKeys.storeUrl] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      AppVersionKeys.number: number,
      if (title != null) AppVersionKeys.title: title,
      if (description != null) AppVersionKeys.description: description,
      if (status != null) AppVersionKeys.status: status,
      if (releasedAt != null)
        AppVersionKeys.releasedAt: releasedAt!.toIso8601String(),
      AppVersionKeys.updateRequired: updateRequired,
      AppVersionKeys.mustUpdate: mustUpdate,
      AppVersionKeys.skipPremium: skipPremium,
      if (storeUrl != null) AppVersionKeys.storeUrl: storeUrl,
    };
  }
}
