import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../errors/api_exceptions.dart';
import '../models/api_response.dart';

/// Base API client with interceptors and error handling for FastAPI microservices
class ApiClient {
  final http.Client _httpClient;
  final List<RequestInterceptor> _requestInterceptors = [];
  final List<ResponseInterceptor> _responseInterceptors = [];

  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  ApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client() {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    // Add default interceptors
    addRequestInterceptor(AuthInterceptor(this));
    addRequestInterceptor(LoggingInterceptor());
    addResponseInterceptor(ErrorHandlerInterceptor());
  }

  void addRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.add(interceptor);
  }

  void addResponseInterceptor(ResponseInterceptor interceptor) {
    _responseInterceptors.add(interceptor);
  }

  // Token management
  Future<void> setTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;

  /// Automatically refresh token if expired
  Future<bool> _tryRefreshToken() async {
    // If already refreshing, wait for the current refresh to complete
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return _accessToken != null;
    }

    if (_refreshToken == null || _refreshToken!.isEmpty) {
      print('⚠️ Cannot refresh: no refresh token available');
      return false;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      print('🔄 Attempting to refresh access token...');

      final uri =
          _buildUri(ApiConfig.authServiceUrl, ApiConfig.refreshTokenEndpoint, {
            'role': 'normal',
            'access_token': _accessToken ?? '',
            'refresh_token': _refreshToken!,
          });

      final response = await _httpClient
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final newAccessToken = json['access_token']?.toString();
        final newRefreshToken = json['refresh_token']?.toString();

        if (newAccessToken != null && newRefreshToken != null) {
          await setTokens(newAccessToken, newRefreshToken);
          print('✅ Token refreshed successfully');
          _refreshCompleter?.complete(true);
          return true;
        }
      }

      print('❌ Token refresh failed: ${response.statusCode}');
      await clearTokens();
      _refreshCompleter?.complete(false);
      return false;
    } catch (e) {
      print('❌ Token refresh error: $e');
      await clearTokens();
      _refreshCompleter?.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String serviceUrl,
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool retry = true,
  }) async {
    final uri = _buildUri(serviceUrl, endpoint, queryParameters);
    final requestHeaders = await _buildHeaders(headers);

    try {
      // Apply request interceptors
      for (var interceptor in _requestInterceptors) {
        await interceptor.onRequest(uri, 'GET', requestHeaders, null);
      }

      final response = await _httpClient
          .get(uri, headers: requestHeaders)
          .timeout(ApiConfig.connectionTimeout);

      // Handle 401 Unauthorized - try to refresh token
      if (response.statusCode == 401 && retry) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          // Retry the request with new token
          return get<T>(
            serviceUrl,
            endpoint,
            queryParameters: queryParameters,
            headers: headers,
            fromJson: fromJson,
            retry: false, // Don't retry again
          );
        }
      }

      return await _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String serviceUrl,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool retry = true,
  }) async {
    final uri = _buildUri(serviceUrl, endpoint, queryParameters);
    final requestHeaders = await _buildHeaders(headers);
    final jsonBody = body != null ? jsonEncode(body) : null;

    try {
      // Apply request interceptors
      for (var interceptor in _requestInterceptors) {
        await interceptor.onRequest(uri, 'POST', requestHeaders, body);
      }

      final response = await _httpClient
          .post(uri, headers: requestHeaders, body: jsonBody)
          .timeout(ApiConfig.connectionTimeout);

      // Handle 401 Unauthorized - try to refresh token
      if (response.statusCode == 401 && retry) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          // Retry the request with new token
          return post<T>(
            serviceUrl,
            endpoint,
            body: body,
            queryParameters: queryParameters,
            headers: headers,
            fromJson: fromJson,
            retry: false, // Don't retry again
          );
        }
      }

      return await _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Multipart upload helper. Returns response body as decoded JSON on success.
  Future<ApiResponse<T>> postMultipart<T>(
    String serviceUrl,
    String endpoint, {
    required List<http.MultipartFile> files,
    Map<String, dynamic>? fields,
    Map<String, String>? headers,
    bool includeAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    final uri = _buildUri(serviceUrl, endpoint, null);
    final requestHeaders = await _buildHeaders(headers);
    // IMPORTANT: Do not set Content-Type manually for multipart.
    // http.MultipartRequest will set a boundary-based multipart/form-data content-type.
    // Setting application/json can break parsing and also triggers CORS preflight on web.
    requestHeaders.remove('Content-Type');
    if (!includeAuth) {
      requestHeaders.remove('Authorization');
    }

    assert(() {
      final safeHeaders = Map<String, String>.from(requestHeaders);
      if (safeHeaders.containsKey('Authorization')) {
        safeHeaders['Authorization'] = 'Bearer ***';
      }
      print('🌐 API Request: POST-MULTIPART $uri');
      print('📤 Multipart headers: $safeHeaders');
      if (fields != null) {
        print('📤 Multipart fields keys: ${fields.keys.toList()}');
      }
      if (files.isNotEmpty) {
        print('📤 Multipart files: ${files.map((f) => f.field).toList()}');
      }
      return true;
    }());

    try {
      for (var interceptor in _requestInterceptors) {
        await interceptor.onRequest(
          uri,
          'POST-MULTIPART',
          requestHeaders,
          null,
        );
      }

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(requestHeaders);

      if (fields != null) {
        fields.forEach((key, value) {
          if (value is String) {
            request.fields[key] = value;
          } else if (value is List<String>) {
            // Add repeated text parts using MultipartFile.fromString
            for (final v in value) {
              request.files.add(http.MultipartFile.fromString(key, v));
            }
          } else if (value != null) {
            request.fields[key] = value.toString();
          }
        });
      }

      for (final f in files) request.files.add(f);

      final streamed = await request.send().timeout(
        ApiConfig.connectionTimeout,
      );
      final resp = await http.Response.fromStream(streamed);

      return await _handleResponse<T>(resp, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String serviceUrl,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool retry = true,
  }) async {
    final uri = _buildUri(serviceUrl, endpoint, queryParameters);
    final requestHeaders = await _buildHeaders(headers);
    final jsonBody = body != null ? jsonEncode(body) : null;

    try {
      for (var interceptor in _requestInterceptors) {
        await interceptor.onRequest(uri, 'PUT', requestHeaders, body);
      }

      final response = await _httpClient
          .put(uri, headers: requestHeaders, body: jsonBody)
          .timeout(ApiConfig.connectionTimeout);

      // Handle 401 Unauthorized - try to refresh token
      if (response.statusCode == 401 && retry) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          return put<T>(
            serviceUrl,
            endpoint,
            body: body,
            queryParameters: queryParameters,
            headers: headers,
            fromJson: fromJson,
            retry: false,
          );
        }
      }

      return await _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic PATCH request
  Future<ApiResponse<T>> patch<T>(
    String serviceUrl,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool retry = true,
  }) async {
    final uri = _buildUri(serviceUrl, endpoint, queryParameters);
    final requestHeaders = await _buildHeaders(headers);
    final jsonBody = body != null ? jsonEncode(body) : null;

    try {
      for (var interceptor in _requestInterceptors) {
        await interceptor.onRequest(uri, 'PATCH', requestHeaders, body);
      }

      final response = await _httpClient
          .patch(uri, headers: requestHeaders, body: jsonBody)
          .timeout(ApiConfig.connectionTimeout);

      // Handle 401 Unauthorized - try to refresh token
      if (response.statusCode == 401 && retry) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          return patch<T>(
            serviceUrl,
            endpoint,
            body: body,
            queryParameters: queryParameters,
            headers: headers,
            fromJson: fromJson,
            retry: false,
          );
        }
      }

      return await _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String serviceUrl,
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool retry = true,
  }) async {
    final uri = _buildUri(serviceUrl, endpoint, queryParameters);
    final requestHeaders = await _buildHeaders(headers);

    try {
      for (var interceptor in _requestInterceptors) {
        await interceptor.onRequest(uri, 'DELETE', requestHeaders, null);
      }

      final response = await _httpClient
          .delete(uri, headers: requestHeaders)
          .timeout(ApiConfig.connectionTimeout);

      // Handle 401 Unauthorized - try to refresh token
      if (response.statusCode == 401 && retry) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          return delete<T>(
            serviceUrl,
            endpoint,
            queryParameters: queryParameters,
            headers: headers,
            fromJson: fromJson,
            retry: false,
          );
        }
      }

      return await _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Uri _buildUri(
    String baseUrl,
    String endpoint,
    Map<String, String>? queryParameters,
  ) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? headers,
  ) async {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_accessToken != null && _accessToken!.isNotEmpty) {
      defaultHeaders['Authorization'] = 'Bearer $_accessToken';
    }

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }

  Future<ApiResponse<T>> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) async {
    // Apply response interceptors
    for (var interceptor in _responseInterceptors) {
      await interceptor.onResponse(response);
    }

    final statusCode = response.statusCode;

    // Success responses (2xx)
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return ApiResponse<T>.success(null as T, statusCode: statusCode);
      }

      try {
        final json = jsonDecode(response.body);

        if (fromJson != null) {
          // Check if response is wrapped in standard format
          if (json is Map<String, dynamic> && json.containsKey('data')) {
            final data = fromJson(json['data']);
            return ApiResponse<T>.success(
              data,
              message: json['message'],
              statusCode: statusCode,
            );
          } else {
            // Direct data response
            final data = fromJson(json);
            return ApiResponse<T>.success(data, statusCode: statusCode);
          }
        }

        return ApiResponse<T>.success(json as T, statusCode: statusCode);
      } catch (e) {
        throw ApiException(
          message: 'Failed to parse response: $e',
          statusCode: statusCode,
        );
      }
    }

    // Error responses
    return _handleErrorResponse<T>(response);
  }

  ApiResponse<T> _handleErrorResponse<T>(http.Response response) {
    final statusCode = response.statusCode;
    String message = 'Request failed with status: $statusCode';
    Map<String, dynamic>? errors;

    try {
      final json = jsonDecode(response.body);
      if (json is Map<String, dynamic>) {
        message =
            json['message']?.toString() ??
            json['detail']?.toString() ??
            json['error']?.toString() ??
            message;
        errors = json['errors'] as Map<String, dynamic>?;
      }
    } catch (_) {
      message = response.body.isNotEmpty ? response.body : message;
    }

    switch (statusCode) {
      case 400:
        throw ApiException(
          message: message,
          statusCode: statusCode,
          errors: errors,
        );
      case 401:
        // Don't throw immediately - let retry with refresh token logic handle it
        throw AuthException(
          message: message.contains('token') ? message : 'Unauthorized',
        );
      case 403:
        throw AuthException.forbidden();
      case 422:
        throw ValidationException(message: message, errors: errors);
      case 500:
        throw ServerException.internalError();
      case 503:
        throw ServerException.serviceUnavailable();
      default:
        throw ApiException(
          message: message,
          statusCode: statusCode,
          errors: errors,
        );
    }
  }

  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is ApiException) {
      throw error;
    }

    if (error is SocketException) {
      throw NetworkException.noConnection();
    }

    if (error is TimeoutException) {
      throw NetworkException.timeout();
    }

    if (error is http.ClientException) {
      throw NetworkException(
        message: 'Network error: ${error.message}',
        originalError: error,
      );
    }

    throw ApiException(
      message: 'Unexpected error: ${error.toString()}',
      originalError: error,
    );
  }

  void dispose() {
    _httpClient.close();
  }
}

/// Request interceptor interface
abstract class RequestInterceptor {
  Future<void> onRequest(
    Uri uri,
    String method,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  );
}

/// Response interceptor interface
abstract class ResponseInterceptor {
  Future<void> onResponse(http.Response response);
}

/// Auth interceptor for adding tokens
class AuthInterceptor implements RequestInterceptor {
  final ApiClient client;

  AuthInterceptor(this.client);

  @override
  Future<void> onRequest(
    Uri uri,
    String method,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) async {
    // Token is already added in _buildHeaders
    // This can be used for token refresh logic
  }
}

/// Logging interceptor
class LoggingInterceptor implements RequestInterceptor {
  @override
  Future<void> onRequest(
    Uri uri,
    String method,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) async {
    print('🌐 API Request: $method $uri');
    if (body != null) {
      print('📤 Body: ${jsonEncode(body)}');
    }
  }
}

/// Error handler interceptor
class ErrorHandlerInterceptor implements ResponseInterceptor {
  @override
  Future<void> onResponse(http.Response response) async {
    if (response.statusCode >= 400) {
      print('❌ API Error: ${response.statusCode} ${response.reasonPhrase}');
      print('📥 Response: ${response.body}');
    } else {
      print('✅ API Success: ${response.statusCode}');
    }
  }
}
