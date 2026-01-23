import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/models/api_response.dart';
import '../models/track.dart';
import '../services/playlist_service_v2.dart';

/// Artist service using ApiClient with authentication
class ArtistServiceV2 {
  final ApiClient _apiClient;

  ArtistServiceV2(this._apiClient);

  /// Follow artist
  /// Endpoint: POST /artists/follow-artist/{artist_id}
  /// Uses Bearer token for authentication (automatically added by ApiClient)
  Future<bool> followArtist({required String artistId}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.getServiceUrl('music'), // or 'artist' if you add it to config
        '/artists/follow-artist/$artistId',
        fromJson: null,
      );

      if (response.success) {
        print('Successfully followed artist: $artistId');
        return true;
      } else {
        print('Follow artist failed: ${response.message}');
        return false;
      }
    } catch (e) {
      print('Error following artist: $e');
      return false;
    }
  }

  /// Unfollow artist
  /// Endpoint: POST /artists/unfollow-artist/{artist_id}
  /// Uses Bearer token for authentication (automatically added by ApiClient)
  Future<bool> unfollowArtist({required String artistId}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.getServiceUrl('music'), // or 'artist' if you add it to config
        '/artists/unfollow-artist/$artistId',
        fromJson: null,
      );

      if (response.success) {
        print('Successfully unfollowed artist: $artistId');
        return true;
      } else {
        print('Unfollow artist failed: ${response.message}');
        return false;
      }
    } catch (e) {
      print('Error unfollowing artist: $e');
      return false;
    }
  }

  /// Check if user is following artist
  /// Endpoint: GET /artists/follow-status/{artist_id}
  Future<bool> isFollowingArtist({required String artistId}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConfig.getServiceUrl('music'),
        '/artists/follow-status/$artistId',
        fromJson: null,
      );

      if (response.success && response.data != null) {
        return response.data!['is_following'] == true;
      }
      return false;
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }

  /// Get artist tracks
  /// Endpoint: GET /artists/info/tracks/{artist_id}
  Future<List<Track>> getArtistTracks({required String artistId}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiConfig.getServiceUrl('music'),
        '/artists/info/tracks/$artistId',
        fromJson: null,
      );

      if (response.success && response.data != null) {
        final data = response.data;

        // Handle direct list response
        if (data is List) {
          return data
              .map((json) => Track.fromApi(json as Map<String, dynamic>))
              .toList();
        }

        // Handle wrapped response
        if (data is Map<String, dynamic>) {
          final tracksJson = data['tracks'] ?? data['data'] ?? [];
          if (tracksJson is List) {
            return tracksJson
                .map((json) => Track.fromApi(json as Map<String, dynamic>))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      print('Error loading artist tracks: $e');
      return [];
    }
  }

  /// Get artist playlists
  /// Endpoint: GET /artists/info/playlists/{artist_id}
  Future<List<Playlist>> getArtistPlaylists({required String artistId}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiConfig.getServiceUrl('music'),
        '/artists/info/playlists/$artistId',
        fromJson: null,
      );

      if (response.success && response.data != null) {
        final data = response.data;

        // Handle direct list response
        if (data is List) {
          return data
              .map((json) => Playlist.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        // Handle wrapped response
        if (data is Map<String, dynamic>) {
          final playlistsJson = data['playlists'] ?? data['data'] ?? [];
          if (playlistsJson is List) {
            return playlistsJson
                .map((json) => Playlist.fromJson(json as Map<String, dynamic>))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      print('Error loading artist playlists: $e');
      return [];
    }
  }

  /// Get artist albums
  /// Endpoint: GET /artists/info/albums/{artist_id}
  Future<List<Map<String, dynamic>>> getArtistAlbums({
    required String artistId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiConfig.getServiceUrl('music'),
        '/artists/info/albums/$artistId',
        fromJson: null,
      );

      if (response.success && response.data != null) {
        final data = response.data;

        // Handle direct list response
        if (data is List) {
          return data.map((json) => json as Map<String, dynamic>).toList();
        }

        // Handle wrapped response
        if (data is Map<String, dynamic>) {
          final albumsJson = data['albums'] ?? data['data'] ?? [];
          if (albumsJson is List) {
            return albumsJson
                .map((json) => json as Map<String, dynamic>)
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      print('Error loading artist albums: $e');
      return [];
    }
  }
}
