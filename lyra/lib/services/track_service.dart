import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/models/api_response.dart';

/// Track service for like/unlike operations
class TrackService {
  final ApiClient _apiClient;

  TrackService(this._apiClient);

  /// Toggle like/unlike track
  /// Endpoint: POST /tracks/like/{track_id}?toggle=true/false
  /// Uses Bearer token for authentication (automatically added by ApiClient)
  /// @param toggle: true to like, false to unlike
  Future<bool> toggleLikeTrack({
    required String trackId,
    required bool toggle,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.getServiceUrl('music'),
        '/tracks/like/$trackId?toggle=$toggle',
        fromJson: null,
      );

      if (response.success) {
        print('Successfully ${toggle ? 'liked' : 'unliked'} track: $trackId');
        return true;
      } else {
        print('Toggle like failed: ${response.message}');
        return false;
      }
    } catch (e) {
      print('Error toggling like: $e');
      return false;
    }
  }

  /// Check if track is liked
  /// Endpoint: GET /tracks/liked-track/{track_id}
  Future<bool> isTrackLiked({required String trackId}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConfig.getServiceUrl('music'),
        '/tracks/liked-track/$trackId',
        fromJson: null,
      );

      if (response.success && response.data != null) {
        // Assuming API returns {"is_liked": true/false}
        return response.data!['is_liked'] == true;
      }
      return false;
    } catch (e) {
      print('Error checking like status: $e');
      return false;
    }
  }
}
