import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/track.dart';
import '../models/current_user.dart';
import '../core/di/service_locator.dart';
import '../services/music_service_v2.dart';

class MusicPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  Track? _currentTrack;
  bool _isPlaying = false;
  int _durationMs = 0;
  int _positionMs = 0;

  // Queue management
  final List<Track> _queue = [];
  int _currentIndex = -1;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  int get durationMs => _durationMs;
  int get positionMs => _positionMs;
  List<Track> get queue => List.unmodifiable(_queue);
  Track? get nextTrack => hasNext ? _queue[_currentIndex + 1] : null;
  bool get hasNext => _currentIndex < _queue.length - 1;
  bool get hasPrevious => _currentIndex > 0;

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
  bool _hasTrackedStream = false;

  MusicPlayerProvider() {
    // cập nhật position - chỉ notify mỗi 500ms để tránh rebuild quá nhiều
    int lastNotifyMs = 0;
    _player.positionStream.listen((pos) {
      _positionMs = pos.inMilliseconds;
      if (_currentTrack != null) {
        _currentTrack = _currentTrack!.copyWith(positionMs: pos.inMilliseconds);
      }

      // Track stream after 30 seconds of playback (only once per track)
      if (_positionMs >= 30000 && !_hasTrackedStream && _currentTrack != null) {
        _hasTrackedStream = true;
        _trackStream();
      }

      // Chỉ notify mỗi 500ms để tránh rebuild quá nhiều
      if (_positionMs - lastNotifyMs >= 500 || _positionMs < lastNotifyMs) {
        lastNotifyMs = _positionMs;
        notifyListeners();
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

      // Auto play next track when current track completes
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }

      notifyListeners();
    });
  }

  // =========================
  // STREAM TRACKING
  // =========================
  Future<void> _trackStream() async {
    if (_currentTrack == null) return;

    final userId = CurrentUser.instance.user?.userId;
    if (userId == null) {
      debugPrint('⚠️ Cannot track stream: user not logged in');
      return;
    }

    try {
      await ServiceLocator().musicService.incrementStream(
        _currentTrack!.trackId,
        userId,
      );
      debugPrint('✅ Stream tracked for: ${_currentTrack!.trackName}');
    } catch (e) {
      debugPrint('❌ Error tracking stream: $e');
    }
  }

  // =========================
  // LOAD TRACK (KHÔNG AUTO PLAY)
  // =========================
  Future<void> setTrack(Track track, {List<Track>? queue}) async {
    _currentTrack = track.copyWith(positionMs: 0);
    _durationMs = 0;
    _positionMs = 0;
    _hasTrackedStream = false; // Reset tracking flag for new track

    // Update queue if provided
    if (queue != null) {
      _queue.clear();
      _queue.addAll(queue);
      _currentIndex = _queue.indexWhere((t) => t.trackId == track.trackId);
      if (_currentIndex == -1) {
        // Track not in queue, add it at the beginning
        _queue.insert(0, track);
        _currentIndex = 0;
      }
    } else if (_queue.isEmpty) {
      // No queue provided and queue is empty, just add current track
      _queue.clear();
      _queue.add(track);
      _currentIndex = 0;
    } else {
      // Queue exists, update current index
      _currentIndex = _queue.indexWhere((t) => t.trackId == track.trackId);
      if (_currentIndex == -1) {
        // Track not in queue, replace current position
        if (_currentIndex >= 0 && _currentIndex < _queue.length) {
          _queue[_currentIndex] = track;
        } else {
          _queue.insert(0, track);
          _currentIndex = 0;
        }
      }
    }

    notifyListeners();

    // Save track to persistence
    saveLastTrack();

    try {
      await _player.setUrl(track.audioUrl);
    } catch (e) {
      debugPrint("❌ Error loading audio: $e");
    }
  }

  // =========================
  // QUEUE MANAGEMENT
  // =========================
  void addToQueue(Track track) {
    _queue.add(track);
    notifyListeners();
  }

  void addNextInQueue(Track track) {
    if (_currentIndex >= 0 && _currentIndex < _queue.length - 1) {
      _queue.insert(_currentIndex + 1, track);
    } else {
      _queue.add(track);
    }
    notifyListeners();
  }

  void removeFromQueue(int index) {
    if (index >= 0 && index < _queue.length && index != _currentIndex) {
      _queue.removeAt(index);
      if (index < _currentIndex) {
        _currentIndex--;
      }
      notifyListeners();
    }
  }

  void clearQueue() {
    final current = _currentTrack;
    _queue.clear();
    if (current != null) {
      _queue.add(current);
      _currentIndex = 0;
    } else {
      _currentIndex = -1;
    }
    notifyListeners();
  }

  // =========================
  // PLAY NEXT/PREVIOUS
  // =========================
  Future<void> playNext() async {
    if (hasNext) {
      final nextTrack = _queue[_currentIndex + 1];
      await setTrack(nextTrack);
      play();
    }
  }

  Future<void> playPrevious() async {
    if (hasPrevious) {
      final previousTrack = _queue[_currentIndex - 1];
      await setTrack(previousTrack);
      play();
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

  // Play without toggle - always play
  void play() {
    _player.play();
  }

  void pause() {
    _player.pause();
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
  // PERSISTENCE - Save/Restore Last Track
  // =========================
  static const String _lastTrackKey = 'last_played_track';

  Future<void> saveLastTrack() async {
    if (_currentTrack == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final trackJson = jsonEncode(_currentTrack!.toJson());
      await prefs.setString(_lastTrackKey, trackJson);
      debugPrint('✅ Saved last track: ${_currentTrack!.trackName}');
    } catch (e) {
      debugPrint('❌ Error saving last track: $e');
    }
  }

  Future<void> restoreLastTrack() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trackJson = prefs.getString(_lastTrackKey);

      if (trackJson != null) {
        final trackData = jsonDecode(trackJson);
        final track = Track.fromJson(trackData);

        // Load queue from recent + top tracks
        try {
          debugPrint('🔍 Attempting to load recent/top tracks for queue');
          final musicService = serviceLocator.musicService;
          if (musicService == null) {
            debugPrint('⚠️ serviceLocator.musicService is null');
          }

          final recentTracks = await musicService.getRecentTracks();
          debugPrint('ℹ️ recentTracks count: ${recentTracks.length}');

          final topTracks = await musicService.getUserTopTracks(limit: 20);
          debugPrint('ℹ️ topTracks count: ${topTracks.length}');

          // Combine and deduplicate
          final allTracks = <Track>[...recentTracks, ...topTracks];
          final seenIds = <String>{};
          final queueTracks = allTracks.where((t) {
            if (seenIds.contains(t.trackId)) return false;
            seenIds.add(t.trackId);
            return true;
          }).toList();

          debugPrint('ℹ️ combined unique tracks: ${queueTracks.length}');

          if (queueTracks.isEmpty) {
            debugPrint('⚠️ queueTracks is empty; will set track without queue');
            await setTrack(track);
            debugPrint('✅ Restored last track (no queue): ${track.trackName}');
          } else {
            await setTrack(track, queue: queueTracks);
            debugPrint(
              '✅ Restored last track with ${queueTracks.length} tracks in queue: ${track.trackName}',
            );
          }
        } catch (e, st) {
          // If loading queue fails, just set track without queue
          debugPrint('⚠️ Could not load queue: $e');
          debugPrint('$st');
          await setTrack(track);
          debugPrint('✅ Restored last track (no queue): ${track.trackName}');
        }
      } else {
        debugPrint('ℹ️ No last track found');
      }
    } catch (e) {
      debugPrint('❌ Error restoring last track: $e');
    }
  }
}
