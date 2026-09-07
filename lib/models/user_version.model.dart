import 'package:rexone_mobile/constants/constants.dart';

class UserVersionModel {
  final String id;
  final String? platform;
  final String number;
  final int? buildNumber;
  final DateTime? lastSeenAt;
  final String? versionId;

  UserVersionModel({
    required this.id,
    required this.number,
    this.platform,
    this.buildNumber,
    this.lastSeenAt,
    this.versionId,
  });

  factory UserVersionModel.fromJson(Map<String, dynamic> json) {
    return UserVersionModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      platform: json[VersionKeys.platform] as String?,
      number: json[VersionKeys.number]?.toString() ?? '',
      buildNumber: json[VersionKeys.buildNumber] is int
          ? json[VersionKeys.buildNumber] as int
          : int.tryParse(json[VersionKeys.buildNumber]?.toString() ?? ''),
      lastSeenAt: json[VersionKeys.lastSeenAt] != null
          ? DateTime.tryParse(json[VersionKeys.lastSeenAt].toString())
          : null,
      versionId: json[VersionKeys.versionId]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      if (platform != null) VersionKeys.platform: platform,
      VersionKeys.number: number,
      if (buildNumber != null) VersionKeys.buildNumber: buildNumber,
      if (lastSeenAt != null)
        VersionKeys.lastSeenAt: lastSeenAt!.toIso8601String(),
      if (versionId != null) VersionKeys.versionId: versionId,
    };
  }
}
