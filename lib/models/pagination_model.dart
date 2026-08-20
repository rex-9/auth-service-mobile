import 'package:rexone_mobile/constants/constants.dart';

class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int limit;
  final int? nextPage;
  final int? prevPage;

  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.limit,
    this.nextPage,
    this.prevPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json[JsonKeys.currentPage] as int? ?? 1,
      totalPages: json[JsonKeys.totalPages] as int? ?? 1,
      totalCount: json[JsonKeys.totalCount] as int? ?? 0,
      limit: json[JsonKeys.limit] as int? ?? 10,
      nextPage: json[JsonKeys.nextPage] as int?,
      prevPage: json[JsonKeys.prevPage] as int?,
    );
  }

  bool get hasNextPage => nextPage != null;
  bool get hasPrevPage => prevPage != null;
}

class PaginatedResponse<T> {
  final List<T> records;
  final PaginationMeta? pagination;
  final String message;
  final int statusCode;
  final bool success;

  const PaginatedResponse({
    required this.records,
    this.pagination,
    required this.message,
    required this.statusCode,
    required this.success,
  });
}
