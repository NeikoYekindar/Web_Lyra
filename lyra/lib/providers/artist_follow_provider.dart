import 'package:flutter/foundation.dart';
import '../core/di/service_locator.dart';

/// Provider to manage artist follow status across all widgets
class ArtistFollowProvider with ChangeNotifier {
  // Map of artistId -> isFollowing status
  final Map<String, bool> _followStatus = {};

  // Map of artistId -> loading status
  final Map<String, bool> _loadingStatus = {};

  /// Get follow status for an artist
  bool isFollowing(String artistId) {
    return _followStatus[artistId] ?? false;
  }

  /// Check if a follow/unfollow operation is in progress
  bool isLoading(String artistId) {
    return _loadingStatus[artistId] ?? false;
  }

  /// Check follow status from API and update cache
  Future<void> checkFollowStatus(String artistId) async {
    try {
      final isFollowing = await serviceLocator.artistService.isFollowingArtist(
        artistId: artistId,
      );
      _followStatus[artistId] = isFollowing;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking follow status: $e');
    }
  }

  /// Toggle follow status for an artist
  Future<bool> toggleFollow(String artistId) async {
    if (_loadingStatus[artistId] == true) return false;

    _loadingStatus[artistId] = true;
    notifyListeners();

    try {
      final currentStatus = _followStatus[artistId] ?? false;
      bool success;

      if (currentStatus) {
        success = await serviceLocator.artistService.unfollowArtist(
          artistId: artistId,
        );
      } else {
        success = await serviceLocator.artistService.followArtist(
          artistId: artistId,
        );
      }

      if (success) {
        _followStatus[artistId] = !currentStatus;
        _loadingStatus[artistId] = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling follow: $e');
    }

    _loadingStatus[artistId] = false;
    notifyListeners();
    return false;
  }

  /// Clear cached follow status for an artist
  void clearCache(String artistId) {
    _followStatus.remove(artistId);
    _loadingStatus.remove(artistId);
    notifyListeners();
  }

  /// Clear all cached follow statuses
  void clearAllCache() {
    _followStatus.clear();
    _loadingStatus.clear();
    notifyListeners();
  }
}
