import '../models/track.dart';

class MockTracks {
  static const Track demo = Track(
    id: 'track_001',
    title: 'Yêu em 2 ngày',
    artist: 'Dương Domic',
    albumArtUrl: 'assets/images/album_3.png',
    durationMs: 249000,
    audioUrl:
        'https://res.cloudinary.com/dskqufysc/video/upload/v1764491757/Y%C3%AAu_Em_2_Ng%C3%A0y_kmuu39.mp3',
    lyricUrl:
        'https://res.cloudinary.com/dskqufysc/raw/upload/v1764491512/D%C6%B0%C6%A1ng_Domic_-_Y%C3%AAu_Em_2_Ng%C3%A0y_tevatt.lrc',
  );

  static const List<Track> playlist = [
    demo,
    Track(
      id: 'track_002',
      title: 'Chúng ta của tương lai',
      artist: 'Sơn Tùng M-TP',
      albumArtUrl: 'assets/images/album_1.png',
      durationMs: 285000,
      audioUrl: 'https://example.com/audio2.mp3',
      lyricUrl: 'https://example.com/lyric2.lrc',
    ),
    Track(
      id: 'track_003',
      title: 'Nàng thơ',
      artist: 'Hoàng Dũng',
      albumArtUrl: 'assets/images/album_2.png',
      durationMs: 263000,
      audioUrl: 'https://example.com/audio3.mp3',
      lyricUrl: 'https://example.com/lyric3.lrc',
    ),
  ];
}
