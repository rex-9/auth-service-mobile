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
      currentPage: json[ApiKeys.currentPage] as int? ?? 1,
      totalPages: json[ApiKeys.totalPages] as int? ?? 1,
      totalCount: json[ApiKeys.totalCount] as int? ?? 0,
      limit: json[ApiKeys.limit] as int? ?? 10,
      nextPage: json[ApiKeys.nextPage] as int?,
      prevPage: json[ApiKeys.prevPage] as int?,
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
