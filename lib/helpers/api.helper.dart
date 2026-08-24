// lib/helpers/api.helper.dart
//
// Centralised Rails JSONAPI response parser.
// Only [parseRecord] and [parseList] are public — [_flattenRecord] is an
// implementation detail.
import 'package:rexone_mobile/constants/constants.dart';

class ApiHelper {
  const ApiHelper._();

  // ============================================================
  // PUBLIC API
  // ============================================================

  /// Parses a single Rails record from an API [data] value.
  ///
  /// ```dart
  /// ApiHelper.parseRecord(data, UserModel.fromJson)   // → UserModel?
  /// ```
  static T? parseRecord<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data is! Map) return null;
    return fromJson(_flattenRecord(data));
  }

  /// Parses a list of Rails records from an API [data] value.
  /// Handles a direct JSON array or a map containing a `"data"` key.
  ///
  /// ```dart
  /// ApiHelper.parseList(data, ProductModel.fromJson)  // → List<ProductModel>
  /// ```
  static List<T> parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final items = data is List
        ? data
        : data is Map
            ? data[ApiKeys.data]
            : null;
    if (items is! List) return const [];
    return items.whereType<Map>().map((item) => fromJson(_flattenRecord(item))).toList();
  }

  // ============================================================
  // PRIVATE
  // ============================================================

  /// Merges a JSONAPI `attributes` hash into the root map and ensures `id`
  /// is present as a String. Falls back to the raw map when no `attributes`
  /// key is present (plain JSON objects).
  static Map<String, dynamic> _flattenRecord(Map item) {
    final map = <String, dynamic>{};
    if (item[ApiKeys.attributes] is Map) {
      map.addAll(Map<String, dynamic>.from(item[ApiKeys.attributes] as Map));
    } else {
      map.addAll(Map<String, dynamic>.from(item));
    }
    if (item[ApiKeys.id] != null) map[ApiKeys.id] = item[ApiKeys.id].toString();
    return map;
  }
}
