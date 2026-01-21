import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/models/api_response.dart';
import '../models/track.dart';
import 'music_service_v2.dart';
import 'playlist_service_v2.dart';

/// Search result wrapper
class SearchResult {
  final List<Track> tracks;
  final List<Album> albums;
  final List<Artist> artists;
  final List<Playlist> playlists;
  final int totalResults;

  const SearchResult({
    this.tracks = const [],
    this.albums = const [],
    this.artists = const [],
    this.playlists = const [],
    this.totalResults = 0,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      tracks: json['tracks'] != null
          ? (json['tracks'] as List).map((e) => Track.fromApi(e)).toList()
          : [],
      albums: json['albums'] != null
          ? (json['albums'] as List).map((e) => Album.fromJson(e)).toList()
          : [],
      artists: json['artists'] != null
          ? (json['artists'] as List).map((e) => Artist.fromJson(e)).toList()
          : [],
      playlists: json['playlists'] != null
          ? (json['playlists'] as List)
                .map((e) => Playlist.fromJson(e))
                .toList()
          : [],
      totalResults: json['total_results'] ?? json['total'] ?? 0,
    );
  }
}

/// Search service for FastAPI microservice
class SearchServiceV2 {
  final ApiClient _apiClient;

  SearchServiceV2(this._apiClient);

  /// Global search across all content types
  Future<SearchResult> search({
    required String query,
    List<String>? types, // ['track', 'album', 'artist', 'playlist']
    int limit = 10,
  }) async {
    final response = await _apiClient.get<SearchResult>(
      ApiConfig.searchServiceUrl,
      ApiConfig.searchEndpoint,
      queryParameters: {
        'q': query,
        if (types != null && types.isNotEmpty) 'types': types.join(','),
        'limit': limit.toString(),
      },
      fromJson: (json) => SearchResult.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Search failed');
  }

  /// Search tracks only
  Future<List<Track>> searchTracks({
    required String query,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<List<Track>>(
      ApiConfig.searchServiceUrl,
      '${ApiConfig.searchEndpoint}/tracks',
      queryParameters: {'q': query, 'limit': limit.toString()},
      fromJson: (json) {
        if (json is List) {
          return json
              .map((e) => Track.fromApi(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Track search failed');
  }

  /// Search artists only
  Future<List<Artist>> searchArtists({
    required String query,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<List<Artist>>(
      ApiConfig.searchServiceUrl,
      '${ApiConfig.searchEndpoint}/artists',
      queryParameters: {'q': query, 'limit': limit.toString()},
      fromJson: (json) {
        if (json is List) {
          return json
              .map((e) => Artist.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Artist search failed');
  }

  /// Search albums only
  Future<List<Album>> searchAlbums({
    required String query,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<List<Album>>(
      ApiConfig.searchServiceUrl,
      '${ApiConfig.searchEndpoint}/albums',
      queryParameters: {'q': query, 'limit': limit.toString()},
      fromJson: (json) {
        if (json is List) {
          return json
              .map((e) => Album.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Album search failed');
  }

  /// Get search suggestions/autocomplete
  Future<List<String>> getSuggestions({
    required String query,
    int limit = 10,
  }) async {
    final response = await _apiClient.get<List<String>>(
      ApiConfig.searchServiceUrl,
      ApiConfig.suggestionsEndpoint,
      queryParameters: {'q': query, 'limit': limit.toString()},
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => e.toString()).toList();
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to get suggestions');
  }
}
