import 'package:flutter/foundation.dart';
import '../core/di/service_locator.dart';

/// Provider to manage track like status across all widgets
class TrackLikeProvider with ChangeNotifier {
  // Map of trackId -> isLiked status
  final Map<String, bool> _likeStatus = {};

  // Map of trackId -> loading status
  final Map<String, bool> _loadingStatus = {};

  /// Get like status for a track
  bool isLiked(String trackId) {
    return _likeStatus[trackId] ?? false;
  }

  /// Check if a like/unlike operation is in progress
  bool isLoading(String trackId) {
    return _loadingStatus[trackId] ?? false;
  }

  /// Check like status from API and update cache
  Future<void> checkLikeStatus(String trackId) async {
    try {
      final isLiked = await serviceLocator.trackService.isTrackLiked(
        trackId: trackId,
      );
      _likeStatus[trackId] = isLiked;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking like status: $e');
    }
  }

  /// Toggle like status for a track
  Future<bool> toggleLike(String trackId) async {
    if (_loadingStatus[trackId] == true) return false;

    _loadingStatus[trackId] = true;
    notifyListeners();

    try {
      // Get current status and toggle it
      final currentStatus = _likeStatus[trackId] ?? false;
      final newStatus = !currentStatus;

      final success = await serviceLocator.trackService.toggleLikeTrack(
        trackId: trackId,
        toggle: newStatus, // true to like, false to unlike
      );

      if (success) {
        _likeStatus[trackId] = newStatus;
        _loadingStatus[trackId] = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }

    _loadingStatus[trackId] = false;
    notifyListeners();
    return false;
  }

  /// Clear cached like status for a track
  void clearCache(String trackId) {
    _likeStatus.remove(trackId);
    _loadingStatus.remove(trackId);
    notifyListeners();
  }

  /// Clear all cached like statuses
  void clearAllCache() {
    _likeStatus.clear();
    _loadingStatus.clear();
    notifyListeners();
  }
}
