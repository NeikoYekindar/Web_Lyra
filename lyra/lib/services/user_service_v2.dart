import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/user.dart';
import '../models/auth_response.dart';

/// User service for FastAPI microservice
class UserServiceV2 {
  final ApiClient _apiClient;

  UserServiceV2(this._apiClient);

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get<UserModel>(
      ApiConfig.userServiceUrl,
      '/users/me', // Or verify with backend
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch user profile');
  }

  /// Update current user profile
  Future<UserModel> updateCurrentUser({
    required String userId,
    String? displayName,
    String? gender,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    String? bio,
    List<String>? favoriteGenres,
    List<int>? profileImageBytes,
    String? profileImageFilename,
  }) async {
    final endpoint = '${ApiConfig.userUpdateEndpoint}/';

    if (profileImageBytes != null && profileImageBytes.isNotEmpty) {
      // Send multipart/form-data with image as a separate part and other fields as form fields
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        profileImageBytes,
        filename: profileImageFilename ?? 'avatar.png',
        contentType: MediaType('image', 'png'),
      );

      final response = await _apiClient.postMultipart<UserModel>(
        ApiConfig.userServiceUrl,
        endpoint,
        files: [multipartFile],
        fields: {
          'user_id': userId,
          if (displayName != null) 'display_name': displayName,
          if (gender != null) 'gender': gender,
          if (dateOfBirth != null)
            'dateOfBirth': dateOfBirth.toIso8601String().split('T').first,
          if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
          if (bio != null) 'bio': bio,
          if (favoriteGenres != null) 'favorite_genre': favoriteGenres,
        },
        fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        return response.data!;
      }

      throw Exception(response.message ?? 'Failed to update user profile');
    }

    throw Exception('Profile image is required for update');
  }

  /// Request password reset
  Future<void> forgotPassword(String email) async {
    final response = await _apiClient.post(
      ApiConfig.userServiceUrl,
      ApiConfig.forgotPasswordEndpoint,
      body: {'email': email},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to send password reset');
    }
  }

  /// Send verification OTP to email (used for email verification)
  Future<SendResponse?> sendVerifyEmail(String email) async {
    final response = await _apiClient.post(
      ApiConfig.userServiceUrl,
      ApiConfig.sendVerifyEmailEndpoint,
      queryParameters: {'email': email},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to send verification email');
    }

    // Parse response data to SendResponse
    if (response.data != null && response.data is Map<String, dynamic>) {
      return SendResponse.fromJson(response.data as Map<String, dynamic>);
    }
    return SendResponse(success: response.success, message: response.message);
  }

  /// Verify OTP code
  Future<void> verifyOtp({required String email, required String otp}) async {
    final response = await _apiClient.post(
      ApiConfig.userServiceUrl,
      ApiConfig.verifyOtpEndpoint,
      body: {'email': email, 'otp': otp},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'OTP verification failed');
    }
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.userServiceUrl,
      ApiConfig.resetPasswordEndpoint,
      body: {'email': email, 'new_password': newPassword},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Password reset failed');
    }
  }

  /// Upload profile image (avatar) and return the uploaded image URL
  Future<String> uploadProfileImage(
    List<int> bytes,
    String filename,
    String userId,
  ) async {
    // Build multipart file
    final multipartFile = http.MultipartFile.fromBytes(
      'image',
      bytes,
      filename: filename,
      contentType: MediaType('image', 'png'),
    );

    final endpoint = ApiConfig.uploadAvatarEndpoint.replaceAll('{id}', userId);

    final response = await _apiClient.postMultipart<String>(
      ApiConfig.userServiceUrl,
      endpoint,
      files: [multipartFile],
      fromJson: (json) {
        if (json is Map<String, dynamic> && json.containsKey('url')) {
          return json['url'] as String;
        }
        if (json is String) return json;
        throw Exception('Unexpected upload response');
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to upload image');
  }

  /// Set up profile during initial creation using multipart/form-data.
  /// Fields: user_id, display_name, dateOfBirth, gender, bio, favorite_genre
  Future<UserModel> setUpProfile({
    required String userId,
    required String displayName,
    DateTime? dateOfBirth,
    String? gender,
    String? bio,
    List<String>? favoriteGenres,
    List<int>? avatarBytes,
    String? avatarFilename,
  }) async {
    final endpoint = ApiConfig.setUpProfileEndpoint;

    final files = <http.MultipartFile>[];
    if (avatarBytes != null && avatarBytes.isNotEmpty) {
      files.add(
        http.MultipartFile.fromBytes(
          'image',
          avatarBytes,
          filename: avatarFilename ?? 'avatar.png',
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    // Ensure each field is sent as its own part. Send empty string if value is null.
    final Map<String, dynamic> fields = {};

    fields['user_id'] = userId;
    fields['display_name'] = displayName ?? 'name';
    fields['dateOfBirth'] = dateOfBirth != null
        ? dateOfBirth.toIso8601String().split('T').first
        : '';
    fields['gender'] = gender ?? '';
    fields['bio'] = bio ?? '';

    if (favoriteGenres != null && favoriteGenres.isNotEmpty) {
      // If there's only one genre, send it as a single text part to match curl
      if (favoriteGenres.length == 1) {
        fields['favorite_genre'] = favoriteGenres.first;
      } else {
        // multiple genres => send repeated parts (ApiClient will add repeated text parts)
        fields['favorite_genre'] = favoriteGenres;
      }
    }

    final response = await _apiClient.postMultipart<UserModel>(
      ApiConfig.userServiceUrl,
      endpoint,
      files: files,
      fields: fields,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to set up profile');
  }
}
