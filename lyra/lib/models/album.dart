import 'artist.dart';

class Album {
  final String albumId;
  final String albumName;
  final String artistId;
  final int totalTrack;
  final int duration;
  final String? albumImageUrl;
  final String releaseDate;
  final int streams;
  final Artist? artist;

  Album({
    required this.albumId,
    required this.albumName,
    required this.artistId,
    required this.totalTrack,
    required this.duration,
    this.albumImageUrl,
    required this.releaseDate,
    required this.streams,
    this.artist,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      albumId: json['album_id'] ?? '',
      albumName: json['album_name'] ?? '',
      artistId: json['artist_id'] ?? '',
      totalTrack: json['total_track'] ?? 0,
      duration: json['duration'] ?? 0,
      albumImageUrl: json['album_image_url'],
      releaseDate: json['release_date'] ?? '',
      streams: json['streams'] ?? 0,
      artist: json['artist'] != null
          ? Artist.fromApi(json['artist'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'album_id': albumId,
      'album_name': albumName,
      'artist_id': artistId,
      'total_track': totalTrack,
      'duration': duration,
      if (albumImageUrl != null) 'album_image_url': albumImageUrl,
      'release_date': releaseDate,
      'streams': streams,
      if (artist != null) 'artist': artist!.toJson(),
    };
  }

  Album copyWith({
    String? albumId,
    String? albumName,
    String? artistId,
    int? totalTrack,
    int? duration,
    String? albumImageUrl,
    String? releaseDate,
    int? streams,
    Artist? artist,
  }) {
    return Album(
      albumId: albumId ?? this.albumId,
      albumName: albumName ?? this.albumName,
      artistId: artistId ?? this.artistId,
      totalTrack: totalTrack ?? this.totalTrack,
      duration: duration ?? this.duration,
      albumImageUrl: albumImageUrl ?? this.albumImageUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      streams: streams ?? this.streams,
      artist: artist ?? this.artist,
    );
  }

  String? get releaseYear {
    try {
      final date = DateTime.parse(releaseDate);
      return date.year.toString();
    } catch (_) {
      return null;
    }
  }

  String get artistName => artist?.nickname ?? '';
}
