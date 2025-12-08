class UserModel {
  final String userId;
  final String displayName;
  final String userType;
  final String email;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profileImageUrl;
  final String? bio;
  final String? dateCreated;
  final List<String>? favoriteGenres;
  const UserModel({
    required this.userId,
    required this.displayName,
    required this.userType,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
    this.bio,
    this.dateCreated,
    this.favoriteGenres,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      gender: json['gender']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      bio: json['bio']?.toString(),
      dateCreated: json['date_created']?.toString(),
      favoriteGenres: json['favorite_genres'] != null
          ? List<String>.from(json['favorite_genres'])
          : null,
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
    'bio': bio,
    'date_created': dateCreated,
    'favorite_genres': favoriteGenres,
  };

  UserModel copyWith({
    String? userId,
    String? displayName,
    String? userType,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
    String? bio,
    String? dateCreated,
    List<String>? favoriteGenres,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      userType: userType ?? this.userType,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      dateCreated: dateCreated ?? this.dateCreated,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
    );
  }
}
