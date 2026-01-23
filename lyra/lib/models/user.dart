class UserModel {
  final String userId;
  final String displayName;
  final String userType;
  final String email;
  final bool isEmailVerified;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profileImageUrl;
  final String? bio;
  final String? dateCreated;
  final int? following;
  final int? publicPlaylists;
  final List<String>? favoriteGenres;
  const UserModel({
    required this.userId,
    required this.displayName,
    required this.userType,
    required this.email,
    this.isEmailVerified = false,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
    this.bio,
    this.dateCreated,
    this.following,
    this.publicPlaylists,
    this.favoriteGenres,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Helper to clean URL by removing all whitespace characters
    String? cleanUrl(dynamic value) {
      if (value == null) return null;
      return value.toString().replaceAll(RegExp(r'\s+'), '');
    }

    return UserModel(
      userId: json['user_id']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isEmailVerified:
          json['is_email_verified'] == true ||
          json['email_verified'] == true ||
          json['isEmailVerified'] == true,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      gender: json['gender']?.toString(),
      profileImageUrl: cleanUrl(json['profile_image_url']),
      bio: json['bio']?.toString(),
      dateCreated: json['date_created']?.toString(),
      following: json['following'] != null
          ? int.tryParse(json['following'].toString())
          : (json['follows'] != null
                ? int.tryParse(json['follows'].toString())
                : null),
      publicPlaylists: json['public_playlist'] != null
          ? int.tryParse(json['public_playlist'].toString())
          : (json['publicPlaylistCount'] != null
                ? int.tryParse(json['publicPlaylistCount'].toString())
                : null),
      favoriteGenres: () {
        if (json['favorite_genres'] != null) {
          try {
            return List<String>.from(json['favorite_genres']);
          } catch (_) {
            // fallback if it's a single string
            final val = json['favorite_genres'];
            if (val is String) return [val];
          }
        }
        if (json['favorite_genre'] != null) {
          final val = json['favorite_genre'];
          if (val is String) return [val];
          if (val is List) {
            return List<String>.from(val.map((e) => e.toString()));
          }
        }
        return null;
      }(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'display_name': displayName,
    'user_type': userType,
    'email': email,
    'is_email_verified': isEmailVerified,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'gender': gender,
    'profile_image_url': profileImageUrl,
    'bio': bio,
    'date_created': dateCreated,
    'following': following,
    'public_playlist': publicPlaylists,
    'favorite_genres': favoriteGenres,
  };

  @override
  String toString() => toJson().toString();

  UserModel copyWith({
    String? userId,
    String? displayName,
    String? userType,
    String? email,
    bool? isEmailVerified,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
    String? bio,
    String? dateCreated,
    int? following,
    int? publicPlaylists,
    List<String>? favoriteGenres,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      userType: userType ?? this.userType,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      dateCreated: dateCreated ?? this.dateCreated,
      following: following ?? this.following,
      publicPlaylists: publicPlaylists ?? this.publicPlaylists,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
    );
  }
}
