import 'package:flutter/foundation.dart';
import '../core/config/api_config.dart';
import '../core/di/service_locator.dart';
import '../models/track.dart';
import 'music_service_v2.dart';

/// Types of user interactions with tracks
enum InteractionType {
  play,
  like,
  skip,
  addToPlaylist,
}

/// Service for recording user interactions with tracks
/// Uses POST /recommendations/interactions API
class InteractionService {
  /// Get recommended tracks for a user
  /// 
  /// [userId] - The ID of the user
  /// [n] - Number of recommendations (1-100, default 10)
  /// [filterLiked] - Whether to filter out already liked tracks (default true)
  static Future<List<Track>> getRecommendations({
    required String userId,
    int n = 10,
    bool filterLiked = true,
  }) async {
    if (userId.isEmpty) {
      debugPrint('⚠️ Cannot get recommendations: missing userId');
      return [];
    }

    try {
      final apiClient = ServiceLocator().apiClient;
      final musicService = MusicServiceV2(apiClient);
      final endpoint = ApiConfig.userRecommendationsEndpoint.replaceAll('{user_id}', userId);

      debugPrint('📊 Getting recommendations for user: $userId');

      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConfig.musicServiceUrl,
        endpoint,
        queryParameters: {
          'n': n.toString(),
          'filter_liked': filterLiked.toString(),
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        // API returns { "recommendations": [{ "track_id": "...", "score": 0 }, ...] }
        final data = response.data!;
        List<dynamic>? recommendationList;
        
        if (data.containsKey('recommendations')) {
          recommendationList = data['recommendations'] as List<dynamic>?;
        } else if (data.containsKey('tracks')) {
          recommendationList = data['tracks'] as List<dynamic>?;
        }
        
        if (recommendationList != null && recommendationList.isNotEmpty) {
          // Extract track IDs from recommendations
          final trackIds = recommendationList
              .map((item) => (item as Map<String, dynamic>)['track_id'] as String?)
              .where((id) => id != null && id.isNotEmpty)
              .cast<String>()
              .toList();
          
          debugPrint('📊 Fetching ${trackIds.length} tracks by ID...');
          
          // Fetch track details for each track ID
          final List<Track> tracks = [];
          for (final trackId in trackIds) {
            try {
              final track = await musicService.getTrackById(trackId);
              tracks.add(track);
            } catch (e) {
              debugPrint('⚠️ Failed to fetch track $trackId: $e');
            }
          }
          
          debugPrint('✅ Got ${tracks.length} recommendations');
          return tracks;
        }
        debugPrint('⚠️ No tracks found in response: $data');
        return [];
      } else {
        debugPrint('⚠️ Failed to get recommendations: ${response.message}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error getting recommendations: $e');
      return [];
    }
  }

  /// Record a user interaction with a track
  /// 
  /// [trackId] - The ID of the track
  /// [userId] - The ID of the user
  /// [action] - The type of interaction (play, like, skip, add_to_playlist)
  /// [duration] - Duration in seconds (optional, mainly for play action)
  static Future<bool> recordInteraction({
    required String trackId,
    required String userId,
    required InteractionType action,
    int? duration,
  }) async {
    if (trackId.isEmpty || userId.isEmpty) {
      debugPrint('⚠️ Cannot record interaction: missing trackId or userId');
      return false;
    }

    try {
      final apiClient = ServiceLocator().apiClient;
      
      final body = {
        'action': _actionToString(action),
        'track_id': trackId,
        'user_id': userId,
        if (duration != null) 'duration': duration,
      };

      debugPrint('📊 Recording interaction: $body');

      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConfig.musicServiceUrl,
        ApiConfig.interactionsEndpoint,
        body: body,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        debugPrint('✅ Interaction recorded successfully');
        return true;
      } else {
        debugPrint('⚠️ Failed to record interaction: ${response.message}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error recording interaction: $e');
      return false;
    }
  }

  /// Record a play interaction
  static Future<bool> recordPlay({
    required String trackId,
    required String userId,
    int? durationSeconds,
  }) {
    return recordInteraction(
      trackId: trackId,
      userId: userId,
      action: InteractionType.play,
      duration: durationSeconds,
    );
  }

  /// Record a like interaction
  static Future<bool> recordLike({
    required String trackId,
    required String userId,
  }) {
    return recordInteraction(
      trackId: trackId,
      userId: userId,
      action: InteractionType.like,
    );
  }

  /// Record a skip interaction
  static Future<bool> recordSkip({
    required String trackId,
    required String userId,
    int? durationBeforeSkip,
  }) {
    return recordInteraction(
      trackId: trackId,
      userId: userId,
      action: InteractionType.skip,
      duration: durationBeforeSkip,
    );
  }

  /// Record an add to playlist interaction
  static Future<bool> recordAddToPlaylist({
    required String trackId,
    required String userId,
  }) {
    return recordInteraction(
      trackId: trackId,
      userId: userId,
      action: InteractionType.addToPlaylist,
    );
  }

  /// Convert InteractionType to API string
  static String _actionToString(InteractionType action) {
    switch (action) {
      case InteractionType.play:
        return 'play';
      case InteractionType.like:
        return 'like';
      case InteractionType.skip:
        return 'skip';
      case InteractionType.addToPlaylist:
        return 'add_to_playlist';
    }
  }

  /// Trigger model retraining with latest interactions
  /// Call this after user login to update recommendations
  static Future<bool> triggerRetrain() async {
    try {
      final apiClient = ServiceLocator().apiClient;
      
      debugPrint('🔄 Triggering recommendation model retrain...');

      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConfig.musicServiceUrl,
        '/recommendations/trigger-retrain',
        body: {},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        debugPrint('✅ Model retrain triggered successfully');
        return true;
      } else {
        debugPrint('⚠️ Failed to trigger retrain: ${response.message}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error triggering retrain: $e');
      return false;
    }
  }

  /// Reload ML models from disk
  /// Useful if models were updated externally
  static Future<bool> reloadModels() async {
    try {
      final apiClient = ServiceLocator().apiClient;
      
      debugPrint('🔄 Reloading recommendation models...');

      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConfig.musicServiceUrl,
        '/recommendations/reload-models',
        body: {},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        debugPrint('✅ Models reloaded successfully');
        return true;
      } else {
        debugPrint('⚠️ Failed to reload models: ${response.message}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error reloading models: $e');
      return false;
    }
  }
}
