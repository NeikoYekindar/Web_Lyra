/// Custom exceptions for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
    this.originalError,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException($statusCode): $message';
    }
    return 'ApiException: $message';
  }
}

class NetworkException extends ApiException {
  NetworkException({required super.message, super.originalError});

  factory NetworkException.noConnection() {
    return NetworkException(
      message: 'Không có kết nối mạng. Vui lòng kiểm tra internet của bạn.',
    );
  }

  factory NetworkException.timeout() {
    return NetworkException(
      message: 'Yêu cầu quá thời gian. Vui lòng thử lại.',
    );
  }
}

class AuthException extends ApiException {
  AuthException({required super.message, super.statusCode, super.errors});

  factory AuthException.unauthorized() {
    return AuthException(
      message: 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.',
      statusCode: 401,
    );
  }

  factory AuthException.forbidden() {
    return AuthException(
      message: 'Bạn không có quyền truy cập tài nguyên này.',
      statusCode: 403,
    );
  }
}

class ValidationException extends ApiException {
  ValidationException({required super.message, super.errors})
    : super(statusCode: 422);

  factory ValidationException.fromErrors(Map<String, dynamic> errors) {
    final messages = <String>[];
    errors.forEach((key, value) {
      if (value is List) {
        messages.addAll(value.map((e) => '$key: $e'));
      } else {
        messages.add('$key: $value');
      }
    });
    return ValidationException(message: messages.join(', '), errors: errors);
  }
}

class ServerException extends ApiException {
  ServerException({required super.message, super.statusCode});

  factory ServerException.internalError() {
    return ServerException(
      message: 'Lỗi máy chủ. Vui lòng thử lại sau.',
      statusCode: 500,
    );
  }

  factory ServerException.serviceUnavailable() {
    return ServerException(
      message: 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.',
      statusCode: 503,
    );
  }
}
