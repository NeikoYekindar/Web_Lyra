import 'user.dart';

class AuthResponse {
  final String tokenType;
  final String accessToken;
  final String refreshToken;
  final String expiresIn;
  final UserModel? user;

  const AuthResponse({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      tokenType: json['token_type']?.toString() ?? 'bearer',
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      expiresIn: json['expires_in']?.toString() ?? '',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'token_type': tokenType,
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expires_in': expiresIn,
    if (user != null) 'user': user!.toJson(),
  };
}

class SendResponse {
  final String? message;
  final bool success;

  SendResponse({this.message, this.success = false});

  factory SendResponse.fromJson(Map<String, dynamic> json) {
    return SendResponse(
      message: json['message']?.toString(),
      success: json['success'] == true,
    );
  }

  Map<String, dynamic> toJson() => {'message': message, 'success': success};
}
