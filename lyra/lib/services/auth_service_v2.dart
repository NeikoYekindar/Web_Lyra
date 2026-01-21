import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/models/api_response.dart';
import '../models/auth_response.dart';
import '../models/signup_response.dart';
import '../models/user.dart';
import '../models/current_user.dart';

/// Authentication service for FastAPI microservice
class AuthServiceV2 {
  final ApiClient _apiClient;

  AuthServiceV2(this._apiClient);

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<AuthResponse>(
      ApiConfig.userServiceUrl,
      ApiConfig.loginEndpoint,
      body: {
        'email': email,
        'passwd': password, // or 'password' if FastAPI expects that
      },
      fromJson: (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      // Store tokens in client
      await _apiClient.setTokens(
        response.data!.accessToken,
        response.data!.refreshToken,
      );
      return response.data!;
    }

    throw Exception(response.message ?? 'Login failed');
  }

  /// Signup new user
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
    // Request raw JSON so we can check for tokens in the signup response
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConfig.userServiceUrl,
      ApiConfig.signupEndpoint,
      body: {
        'display_name': displayName,
        'user_type': userType,
        'full_name': fullName,
        'passwd': password,
        'email': email,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        if (profileImageUrl != null && profileImageUrl.isNotEmpty)
          'profile_image_url': profileImageUrl,
      },
      fromJson: null,
    );

    if (response.success && response.data != null) {
      final json = response.data!;

      // Try to extract access/refresh tokens if present at top level or inside data
      String? accessToken;
      String? refreshToken;

      if (json['access_token'] != null)
        accessToken = json['access_token']?.toString();
      if (json['refresh_token'] != null)
        refreshToken = json['refresh_token']?.toString();

      if ((accessToken == null || refreshToken == null) &&
          json['data'] is Map<String, dynamic>) {
        final inner = json['data'] as Map<String, dynamic>;
        if (inner['access_token'] != null)
          accessToken = inner['access_token']?.toString();
        if (inner['refresh_token'] != null)
          refreshToken = inner['refresh_token']?.toString();
      }

      if (accessToken != null && refreshToken != null) {
        // Persist tokens in ApiClient
        await _apiClient.setTokens(accessToken, refreshToken);
      }

      // Determine the user JSON payload
      Map<String, dynamic>? userJson;
      if (json['data'] is Map<String, dynamic>) {
        userJson = json['data'] as Map<String, dynamic>;
      } else {
        userJson = json;
      }

      final user = UserModel.fromJson(userJson);
      return SignupResponse(user: user);
    }

    throw Exception(response.message ?? 'Signup failed');
  }

  /// Refresh access token
  Future<AuthResponse> refreshToken() async {
    final refreshToken = _apiClient.refreshToken;
    final accessToken = _apiClient.accessToken;

    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('No refresh token available');
    }

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('No access token available');
    }

    // API expects role, access_token, refresh_token as query parameters
    final response = await _apiClient.post<AuthResponse>(
      ApiConfig.authServiceUrl,
      ApiConfig.refreshTokenEndpoint,
      queryParameters: {
        'role': 'normal', // Default role
        'access_token': accessToken,
        'refresh_token': refreshToken,
      },
      fromJson: (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      // Update tokens
      await _apiClient.setTokens(
        response.data!.accessToken,
        response.data!.refreshToken,
      );
      return response.data!;
    }

    throw Exception(response.message ?? 'Token refresh failed');
  }

  /// Verify access token
  /// Note: /auths/verify endpoint may not be available yet
  /// Using getCurrentUser() as token validation instead
  Future<bool> verifyToken() async {
    final accessToken = _apiClient.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    try {
      final response = await _apiClient.post(
        ApiConfig.authServiceUrl,
        ApiConfig.verifyTokenEndpoint,
        body: {'access_token': accessToken},
      );

      return response.success;
    } catch (e) {
      print('Token verification endpoint not available: $e');
      // Return true to skip verification and let getCurrentUser() validate instead
      return true;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final accessToken = _apiClient.accessToken;
      final refreshToken = _apiClient.refreshToken;

      // Get user_id from CurrentUser if available
      String? userId;
      if (CurrentUser.instance.user != null) {
        userId = CurrentUser.instance.user!.userId;
      }

      // API expects user_id, access_token, refresh_token in body
      if (userId != null && accessToken != null && refreshToken != null) {
        final response = await _apiClient.post(
          ApiConfig.userServiceUrl,
          ApiConfig.logoutEndpoint,
          body: {
            'user_id': userId,
            'access_token': accessToken,
            'refresh_token': refreshToken,
          },
        );
        print('✅ Logout API response: ${response.success}');
      } else {
        print('⚠️ Skipping logout API call - missing required fields:');
        print('  userId: ${userId != null ? "✓" : "✗"}');
        print('  accessToken: ${accessToken != null ? "✓" : "✗"}');
        print('  refreshToken: ${refreshToken != null ? "✓" : "✗"}');
      }
    } catch (e) {
      print('❌ Logout API error: $e');
    } finally {
      // Clear tokens even if request fails
      await _apiClient.clearTokens();
      print('🧹 Tokens cleared from local storage');
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _apiClient.isAuthenticated;
}
