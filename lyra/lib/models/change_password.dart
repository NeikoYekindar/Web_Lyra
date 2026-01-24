/// Request model for changing password
class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'old_password': oldPassword,
        'new_password': newPassword,
      };
}

/// Response model for change password API
class ChangePasswordResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  const ChangePasswordResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
