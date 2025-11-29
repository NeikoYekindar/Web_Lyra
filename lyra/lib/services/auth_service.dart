import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/signup_response.dart';

class AuthService {
  final String baseUrl;
  

  const AuthService({required this.baseUrl});

  Uri _url(String path) => Uri.parse('$baseUrl$path');

  Future<AuthResponse> login({required String email, required String password}) async {
    try {
      final resp = await http
          .post(
            _url('/users/login'),
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'email': email, 'passwd': password}),
          )
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(json);
      }

      // Try to parse error message if available
      String message = 'Login failed (${resp.statusCode})';
      try {
        final err = jsonDecode(resp.body);
        if (err is Map && err['message'] is String) message = err['message'] as String;
      } catch (_) {}
      throw Exception(message);
    } on SocketException {
      throw Exception('Không kết nối được server (SocketException). Kiểm tra mạng hoặc IP: $baseUrl');
    } on TimeoutException {
      throw Exception('Yêu cầu quá thời gian (timeout). Server có phản hồi chậm hoặc không truy cập được.');
    } on http.ClientException catch (e) {
      throw Exception('ClientException: ${e.message}. Có thể do CORS (Web) hoặc URL sai.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  Future<SignupResponse> signup({
    required String displayName,
    required String userType,
    required String fullName,
    required String password,
    required String email,
    DateTime? dateOfBirth,
    required String gender,
    String? profileImageUrl,
  }) async {
    try {
      // Build request body - only include fields with valid values
      final Map<String, dynamic> requestBody = {
        'display_name': displayName,
        'user_type': userType,
        'full_name': fullName,
        'passwd': password,
        'email': email,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender,
      };
      
      // Only add profile_image_url if it has a real value
      if (profileImageUrl != null && profileImageUrl.isNotEmpty && profileImageUrl != 'unknown') {
        requestBody['profile_image_url'] = profileImageUrl;
      }

      print('DEBUG: Signup request body: ${jsonEncode(requestBody)}');
      
      final resp = await http
          .post(
            _url('/users/create'),
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      print('DEBUG: Response status: ${resp.statusCode}');
      print('DEBUG: Response body: ${resp.body}');

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        return SignupResponse.fromJson(json);
      }

      // Enhanced error handling for 422 and other status codes
      String message = 'Signup failed (${resp.statusCode})';
      try {
        final err = jsonDecode(resp.body);
        if (err is Map) {
          if (err['message'] is String) {
            message = err['message'] as String;
          } else if (err['detail'] is String) {
            message = err['detail'] as String;
          } else if (err['error'] is String) {
            message = err['error'] as String;
          } else {
            // If it's a validation error, try to extract field errors
            message = 'Validation error: ${resp.body}';
          }
        }
      } catch (_) {
        message = 'HTTP ${resp.statusCode}: ${resp.body}';
      }
      throw Exception(message);
    } on SocketException {
      throw Exception('Không kết nối được server (SocketException). Kiểm tra mạng hoặc IP: $baseUrl');
    } on TimeoutException {
      throw Exception('Yêu cầu quá thời gian (timeout). Server có phản hồi chậm hoặc không truy cập được.');
    } on http.ClientException catch (e) {
      throw Exception('ClientException: ${e.message}. Có thể do CORS (Web) hoặc URL sai.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}
