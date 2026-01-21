class Artist {
  final String artistId;
  final String nickname;
  final String userId;
  final int totalTracks;
  final int totalAlbums;
  final int totalFollowers;
  final int totalStreams;
  final bool status;
  final String createdAt;
  final String? imageUrl;
  final String? bio;

  Artist({
    required this.artistId,
    required this.nickname,
    required this.userId,
    required this.totalTracks,
    required this.totalAlbums,
    required this.totalFollowers,
    required this.totalStreams,
    required this.status,
    required this.createdAt,
    this.imageUrl,
    this.bio,
  });

  factory Artist.fromApi(Map<String, dynamic> json) {
    return Artist(
      artistId: json['artist_id'] ?? '',
      nickname: json['nickname'] ?? '',
      userId: json['user_id'] ?? '',
      totalTracks: json['total_tracks'] ?? 0,
      totalAlbums: json['total_albums'] ?? 0,
      totalFollowers: json['total_followers'] ?? 0,
      totalStreams: json['total_streams'] ?? 0,
      status: json['status'] == true || json['status'] == 'true',
      createdAt: json['created_at'] ?? '',
      imageUrl: json['image_url'],
      bio: json['bio'],
    );
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      artistId: json['artist_id'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      totalTracks: json['total_tracks'] as int? ?? 0,
      totalAlbums: json['total_albums'] as int? ?? 0,
      totalFollowers: json['total_followers'] as int? ?? 0,
      totalStreams: json['total_streams'] as int? ?? 0,
      status: json['status'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artist_id': artistId,
      'nickname': nickname,
      'user_id': userId,
      'total_tracks': totalTracks,
      'total_albums': totalAlbums,
      'total_followers': totalFollowers,
      'total_streams': totalStreams,
      'status': status,
      'created_at': createdAt,
      'image_url': imageUrl,
      if (bio != null) 'bio': bio,
    };
  }

  Artist copyWith({
    String? artistId,
    String? nickname,
    String? userId,
    int? totalTracks,
    int? totalAlbums,
    int? totalFollowers,
    int? totalStreams,
    bool? status,
    String? createdAt,
    String? imageUrl,
    String? bio,
  }) {
    return Artist(
      artistId: artistId ?? this.artistId,
      nickname: nickname ?? this.nickname,
      userId: userId ?? this.userId,
      totalTracks: totalTracks ?? this.totalTracks,
      totalAlbums: totalAlbums ?? this.totalAlbums,
      totalFollowers: totalFollowers ?? this.totalFollowers,
      totalStreams: totalStreams ?? this.totalStreams,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
    );
  }

  // Backward compatibility getters
  String get id => artistId;
  String get name => nickname;
  String? get image => imageUrl;

  @override
  String toString() {
    return 'Artist(artistId: $artistId, nickname: $nickname, totalFollowers: $totalFollowers)';
  }
}
