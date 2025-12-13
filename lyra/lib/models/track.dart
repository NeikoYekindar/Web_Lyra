class Track {
  final String id;
  final String title;
  final String artist;
  final String albumArtUrl; // can be asset path or network url
  final int durationMs;
  final int positionMs;
  final String audioUrl; // URL to playable audio file
  final String lyricUrl; // URL to lyric file
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.durationMs,
    required this.audioUrl,
    required this.lyricUrl,
    this.positionMs = 0,
  });

  double get progress => durationMs == 0 ? 0 : positionMs / durationMs;

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? albumArtUrl,
    int? durationMs,
    int? positionMs,
  }) => Track(
    id: id ?? this.id,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    albumArtUrl: albumArtUrl ?? this.albumArtUrl,
    durationMs: durationMs ?? this.durationMs,
    positionMs: positionMs ?? this.positionMs,
    audioUrl: audioUrl,
    lyricUrl: lyricUrl,
  );

  factory Track.fromApi(Map<String, dynamic> json) {
    // Assumed keys; adjust if your API differs.
    return Track(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Unknown',
      artist: json['artist'] ?? json['artistName'] ?? 'Unknown Artist',
      albumArtUrl: json['albumArtUrl'] ?? json['image'] ?? '',
      durationMs: json['durationMs'] ?? json['duration'] ?? 0,
      positionMs: json['positionMs'] ?? 0,
      audioUrl: json['audioUrl'] ?? '',
      lyricUrl: json['lyricUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'albumArtUrl': albumArtUrl,
    'durationMs': durationMs,
    'positionMs': positionMs,
  };
}
