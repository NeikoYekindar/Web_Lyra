import 'user.dart';

class SignupResponse {
  final UserModel user;

  const SignupResponse({required this.user});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      user: UserModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => user.toJson();
}