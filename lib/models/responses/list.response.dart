class ListResponse<T> {
  final List<T> items;

  const ListResponse({required this.items});

  factory ListResponse.fromJson(
    dynamic json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    final raw = _extractList(json);

    return ListResponse(
      items: raw
          .whereType<Map<String, dynamic>>()
          .map(fromJsonT)
          .toList(),
    );
  }

  static List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is List) return nested;

      final items = data['items'];
      if (items is List) return items;
    }

    return const [];
  }
}
