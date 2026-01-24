import 'artist.dart';
import 'media_item.dart';

class Track implements MediaItem {
  // API fields
  final String trackId;
  final String artistId;
  final String artistName; // Artist name from API
  final String trackName;
  final int duration; // seconds
  final String kind;
  final int streams;
  final String trackFileUrl;
  final String lyricFileUrl;
  final String trackImageUrl;
  final DateTime? uploadDate;
  final String status;
  final Artist? artistObj; // Nested artist object

  // Playback state (local)
  final int positionMs;

  const Track({
    required this.trackId,
    required this.artistId,
    this.artistName = '',
    required this.trackName,
    required this.duration,
    required this.kind,
    required this.streams,
    required this.trackFileUrl,
    required this.lyricFileUrl,
    required this.trackImageUrl,
    this.uploadDate,
    required this.status,
    this.artistObj,
    this.positionMs = 0,
  });

  // Backwards-compatible getters used elsewhere in the app
  String get id => trackId;
  @override
  String get title => trackName;
  String get artist =>
      artistObj?.nickname ?? (artistName.isNotEmpty ? artistName : artistId); // Use artist nickname or artistName if available
  String get albumArtUrl => trackImageUrl;
  int get durationMs => duration * 1000;
  String get audioUrl => trackFileUrl;
  String get lyricUrl => lyricFileUrl;

  double get progress => durationMs == 0 ? 0 : positionMs / durationMs;

  // MediaItem interface implementation
  @override
  String get subtitle => artist;

  @override
  String? get imageUrl => trackImageUrl;

  @override
  String? get additionalInfo {
    final mins = duration ~/ 60;
    final secs = duration % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  Track copyWith({
    String? trackId,
    String? artistId,
    String? artistName,
    String? trackName,
    int? duration,
    String? kind,
    int? streams,
    String? trackFileUrl,
    String? lyricFileUrl,
    String? trackImageUrl,
    DateTime? uploadDate,
    String? status,
    Artist? artistObj,
    int? positionMs,
  }) => Track(
    trackId: trackId ?? this.trackId,
    artistId: artistId ?? this.artistId,
    artistName: artistName ?? this.artistName,
    trackName: trackName ?? this.trackName,
    duration: duration ?? this.duration,
    kind: kind ?? this.kind,
    streams: streams ?? this.streams,
    trackFileUrl: trackFileUrl ?? this.trackFileUrl,
    lyricFileUrl: lyricFileUrl ?? this.lyricFileUrl,
    trackImageUrl: trackImageUrl ?? this.trackImageUrl,
    uploadDate: uploadDate ?? this.uploadDate,
    status: status ?? this.status,
    artistObj: artistObj ?? this.artistObj,
    positionMs: positionMs ?? this.positionMs,
  );

  factory Track.fromApi(Map<String, dynamic> json) {
    DateTime? parsedUploadDate;
    try {
      final ud =
          json['upload_date'] ?? json['uploadDate'] ?? json['uploaded_at'];
      if (ud != null && ud is String && ud.isNotEmpty) {
        parsedUploadDate = DateTime.tryParse(ud);
      }
    } catch (_) {
      parsedUploadDate = null;
    }

    // Parse nested artist object if present
    Artist? artistObj;
    if (json['artist'] != null && json['artist'] is Map<String, dynamic>) {
      try {
        artistObj = Artist.fromApi(json['artist'] as Map<String, dynamic>);
      } catch (_) {
        artistObj = null;
      }
    }

    return Track(
      trackId: (json['track_id'] ?? json['id'] ?? '').toString(),
      artistId: (json['artist_id'] ?? '').toString(),
      artistName: (json['artist_name'] ?? json['artistName'] ?? '').toString(),
      trackName: (json['track_name'] ?? json['title'] ?? json['name'] ?? '')
          .toString(),
      duration: (json['duration'] is int)
          ? json['duration'] as int
          : (int.tryParse((json['duration'] ?? '0').toString()) ?? 0),
      kind: (json['kind'] ?? '').toString(),
      streams: (json['streams'] is int)
          ? json['streams'] as int
          : (int.tryParse((json['streams'] ?? '0').toString()) ?? 0),
      trackFileUrl: (json['track_file_url'] ?? json['audio_url'] ?? '')
          .toString(),
      lyricFileUrl: (json['lyric_file_url'] ?? json['lyricUrl'] ?? '')
          .toString(),
      trackImageUrl:
          (json['track_image_url'] ??
                  json['albumArtUrl'] ??
                  json['image'] ??
                  '')
              .toString(),
      uploadDate: parsedUploadDate,
      status: (json['status'] ?? 'unknown').toString(),
      artistObj: artistObj,
      positionMs: (json['positionMs'] is int)
          ? json['positionMs'] as int
          : (int.tryParse((json['positionMs'] ?? '0').toString()) ?? 0),
    );
  }

  // Parse from JSON (for persistence/SharedPreferences)
  factory Track.fromJson(Map<String, dynamic> json) {
    DateTime? parsedUploadDate;
    if (json['upload_date'] != null) {
      try {
        parsedUploadDate = DateTime.parse(json['upload_date'] as String);
      } catch (_) {
        parsedUploadDate = null;
      }
    }

    Artist? artistObj;
    if (json['artist'] != null && json['artist'] is Map<String, dynamic>) {
      try {
        artistObj = Artist.fromJson(json['artist'] as Map<String, dynamic>);
      } catch (_) {
        artistObj = null;
      }
    }

    return Track(
      trackId: json['track_id'] as String,
      artistId: json['artist_id'] as String,
      artistName: (json['artist_name'] ?? '').toString(),
      trackName: json['track_name'] as String,
      duration: json['duration'] as int,
      kind: json['kind'] as String,
      streams: json['streams'] as int,
      trackFileUrl: json['track_file_url'] as String,
      lyricFileUrl: json['lyric_file_url'] as String,
      trackImageUrl: json['track_image_url'] as String,
      uploadDate: parsedUploadDate,
      status: json['status'] as String,
      artistObj: artistObj,
      positionMs: json['positionMs'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'track_id': trackId,
    'artist_id': artistId,
    'artist_name': artistName,
    'track_name': trackName,
    'duration': duration,
    'kind': kind,
    'streams': streams,
    'track_file_url': trackFileUrl,
    'lyric_file_url': lyricFileUrl,
    'track_image_url': trackImageUrl,
    'upload_date': uploadDate?.toIso8601String(),
    'status': status,
    if (artistObj != null) 'artist': artistObj!.toJson(),
    'positionMs': positionMs,
  };
}
