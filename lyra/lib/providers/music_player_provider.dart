import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import 'package:lyra/mock/mock_tracks.dart';

class MusicPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  Track? _currentTrack;
  bool _isPlaying = false;
  int _durationMs = 0;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  int get durationMs => _durationMs;
  int get positionMs => _currentTrack?.positionMs ?? 0;

  // =========================
  // 🔊 VOLUME
  // =========================
  double _volume = 1.0;
  double _lastVolume = 1.0;

  double get volume => _volume;
  bool get isMuted => _volume == 0;

  Future<void> setVolume(double v) async {
    _volume = v.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
    notifyListeners();
  }

  void toggleMute() {
    if (_volume == 0) {
      _volume = _lastVolume;
    } else {
      _lastVolume = _volume;
      _volume = 0;
    }
    _player.setVolume(_volume);
    notifyListeners();
  }

  // =========================
  // 🔥 POSITION STREAM (CHO LYRIC)
  // =========================
  Stream<int> get positionMsStream =>
      _player.positionStream.map((p) => p.inMilliseconds);

  // =========================
  // INIT
  // =========================
  MusicPlayerProvider() {
    // cập nhật position cho track (KHÔNG notify)
    _player.positionStream.listen((pos) {
      if (_currentTrack != null) {
        _currentTrack = _currentTrack!.copyWith(positionMs: pos.inMilliseconds);
      }
    });

    // duration
    _player.durationStream.listen((d) {
      if (d != null) {
        _durationMs = d.inMilliseconds;
        notifyListeners();
      }
    });

    // play / pause
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  // =========================
  // LOAD TRACK (KHÔNG AUTO PLAY)
  // =========================
  Future<void> setTrack(Track track) async {
    _currentTrack = track.copyWith(positionMs: 0);
    _durationMs = 0;
    notifyListeners();

    try {
      await _player.setUrl(track.audioUrl);
    } catch (e) {
      debugPrint("❌ Error loading audio: $e");
    }
  }

  // =========================
  // PLAY / PAUSE
  // =========================
  void togglePlay() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  // =========================
  // SEEK
  // =========================
  void setProgressFraction(double fraction) {
    if (_durationMs == 0) return;
    final newMs = (_durationMs * fraction).toInt();
    _player.seek(Duration(milliseconds: newMs));
  }

  void seekTo(int positionMs) {
    _player.seek(Duration(milliseconds: positionMs));
  }

  // =========================
  // DEMO
  // =========================
  void loadDemoTrack() {
    setTrack(MockTracks.demo);
  }
}
