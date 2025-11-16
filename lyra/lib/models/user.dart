class UserModel {
  final String userId;
  final String displayName;
  final String userType;
  final String email;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profileImageUrl;
  final String? dateCreated;

  const UserModel({
    required this.userId,
    required this.displayName,
    required this.userType,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
    this.dateCreated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth'].toString()) : null,
      gender: json['gender']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      dateCreated: json['date_created']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'display_name': displayName,
        'user_type': userType,
        'email': email,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender,
        'profile_image_url': profileImageUrl,
        'date_created': dateCreated,
      };
}
