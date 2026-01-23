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
    // Delegate to fromJson which has more robust parsing
    return Artist.fromJson(json);
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final s = v.toLowerCase().trim();
        return s == 'true' || s == '1' || s == 'yes';
      }
      return false;
    }

    // API sometimes uses 'status' or 'active' and may send string values
    final dynamic statusRaw = json.containsKey('status')
        ? json['status']
        : json.containsKey('active')
        ? json['active']
        : null;

    return Artist(
      artistId: json['artist_id']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      totalTracks: parseInt(json['total_tracks']),
      totalAlbums: parseInt(json['total_albums']),
      totalFollowers: parseInt(json['total_followers']),
      totalStreams: parseInt(json['total_streams']),
      status: parseBool(statusRaw),
      createdAt: json['created_at']?.toString() ?? '',
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
