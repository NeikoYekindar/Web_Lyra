/// Base API response wrapper for consistent error handling
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final success = json['success'] ?? (json['status'] == 'success');

    return ApiResponse(
      success: success,
      data: success && fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message']?.toString() ?? json['detail']?.toString(),
      statusCode: json['status_code'] ?? json['statusCode'],
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data,
    'message': message,
    'status_code': statusCode,
    'errors': errors,
  };
}

/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasNext;
  final bool hasPrevious;

  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasNext,
    required this.hasPrevious,
  });

  int get totalPages => (total / pageSize).ceil();

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final items = (json['items'] as List? ?? json['data'] as List? ?? [])
        .map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList();

    return PaginatedResponse(
      items: items,
      page: json['page'] ?? json['current_page'] ?? 1,
      pageSize: json['page_size'] ?? json['per_page'] ?? items.length,
      total: json['total'] ?? json['total_items'] ?? items.length,
      hasNext: json['has_next'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items,
    'page': page,
    'page_size': pageSize,
    'total': total,
    'has_next': hasNext,
    'has_previous': hasPrevious,
  };
}
