import 'package:flutter/foundation.dart';
import '../models/track.dart';

class MusicPlayerProvider extends ChangeNotifier {
  Track? _currentTrack;
  bool _isPlaying = false;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;

  void loadFromApi(Map<String, dynamic> json) {
    _currentTrack = Track.fromApi(json);
    _isPlaying = false; // default
    notifyListeners();
  }

  void setTrack(Track track) {
    _currentTrack = track;
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void updatePosition(int positionMs) {
    if (_currentTrack == null) return;
    _currentTrack = _currentTrack!.copyWith(positionMs: positionMs);
    notifyListeners();
  }

  void setProgressFraction(double fraction) {
    if (_currentTrack == null) return;
    final duration = _currentTrack!.durationMs;
    updatePosition((duration * fraction).round());
  }

  // Demo track helper for development/testing
  void loadDemoTrack() {
    loadFromApi({
      'id': 'demo_001',
      'title': 'Chúng Ta Của hiện tại',
      'artist': 'Sơn Tùng M-TP',
      // Use any reachable image/asset. Replace with real URL or asset path.
      'albumArtUrl': 'assets/images/playlist_mtp.png',
      'durationMs': 249000,
      'positionMs': 0,
    });
  }

  // Load from backend 'now playing'
  Future<void> loadNowPlaying(Future<Map<String, dynamic>> Function() fetcher) async {
    try {
      final json = await fetcher();
      loadFromApi(json);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load now playing: $e');
      }
    }
  }
}
