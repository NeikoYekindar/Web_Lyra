import 'package:flutter/foundation.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/models/api_response.dart';
import '../models/track.dart';
import '../models/artist.dart' as models;

/// Music models for API responses
class Album {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String coverUrl;
  final int? releaseYear;
  final int? totalTracks;
  final List<String>? trackIds;

  const Album({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.coverUrl,
    this.releaseYear,
    this.totalTracks,
    this.trackIds,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    // Parse release_year from release_date if available
    int? releaseYear;
    if (json['release_year'] != null) {
      releaseYear = json['release_year'] as int?;
    } else if (json['release_date'] != null) {
      try {
        final dateStr = json['release_date'].toString();
        releaseYear = int.tryParse(dateStr.split('-').first);
      } catch (_) {}
    }

    return Album(
      id: json['album_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['album_name']?.toString() ?? json['title']?.toString() ?? '',
      artistId: json['artist_id']?.toString() ?? '',
      artistName: json['artist_name']?.toString() ?? '',
      coverUrl: json['album_image_url']?.toString() ?? json['cover_url']?.toString() ?? '',
      releaseYear: releaseYear,
      totalTracks: json['total_track'] as int? ?? json['total_tracks'] as int?,
      trackIds: json['track_ids'] != null
          ? List<String>.from(json['track_ids'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist_id': artistId,
    'artist_name': artistName,
    'cover_url': coverUrl,
    'release_year': releaseYear,
    'track_ids': trackIds,
  };
}

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String? bio;
  final int? monthlyListeners;
  final bool isVerified;
  final List<String>? genres;

  const Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.bio,
    this.monthlyListeners,
    this.isVerified = false,
    this.genres,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl:
          json['image_url']?.toString() ?? json['image']?.toString() ?? '',
      bio: json['bio']?.toString(),
      monthlyListeners: json['monthly_listeners'] as int?,
      isVerified: json['is_verified'] ?? false,
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_url': imageUrl,
    'bio': bio,
    'monthly_listeners': monthlyListeners,
    'is_verified': isVerified,
    'genres': genres,
  };
}

/// Music service for FastAPI microservice
class MusicServiceV2 {
  final ApiClient _apiClient;

  MusicServiceV2(this._apiClient);

  /// Search tracks (catalog service)
  ///
  /// Docs: GET /tracks/search?q=...&kind=...&sort_by=...
  /// Response schema is not strictly defined in OpenAPI, so parsing is tolerant.
  Future<List<Track>> searchTracks({
    required String query,
    String? kind,
    String? sortBy,
    int limit = 20,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    final response = await _apiClient.get<List<Track>>(
      ApiConfig.musicServiceUrl,
      ApiConfig.tracksSearchEndpoint,
      queryParameters: {
        'q': q,
        if (kind != null && kind.trim().isNotEmpty) 'kind': kind.trim(),
        if (sortBy != null && sortBy.trim().isNotEmpty)
          'sort_by': sortBy.trim(),
        // Some backends accept limit/page_size. Safe to send; ignored if unsupported.
        'limit': limit.toString(),
      },
      fromJson: (json) {
        List<dynamic>? rawItems;

        if (json is List) {
          rawItems = json;
        } else if (json is Map<String, dynamic>) {
          // Catalog search currently returns { query, hits: [...], total }
          // but other endpoints may return { items: [...] } or { data: [...] } etc.
          final hits = json['hits'];
          final items = json['items'];
          final data = json['data'];
          final tracks = json['tracks'];
          final results = json['results'];

          if (hits is List) {
            rawItems = hits;
          } else if (items is List) {
            rawItems = items;
          } else if (results is List) {
            rawItems = results;
          } else if (data is List) {
            rawItems = data;
          } else if (tracks is List) {
            rawItems = tracks;
          } else if (data is Map<String, dynamic>) {
            // Sometimes responses are wrapped: { data: { hits/items/tracks: [...] } }
            final nestedHits = data['hits'];
            final nestedItems = data['items'];
            final nestedTracks = data['tracks'];
            final nestedResults = data['results'];

            if (nestedHits is List) {
              rawItems = nestedHits;
            } else if (nestedItems is List) {
              rawItems = nestedItems;
            } else if (nestedResults is List) {
              rawItems = nestedResults;
            } else if (nestedTracks is List) {
              rawItems = nestedTracks;
            }
          }
        }

        if (rawItems == null) return <Track>[];
        return rawItems
            .whereType<Map<String, dynamic>>()
            .map(Track.fromApi)
            .toList();
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to search tracks');
  }

  /// Get all tracks with pagination
  Future<PaginatedResponse<Track>> getTracks({
    int page = 1,
    int pageSize = 20,
    String? genre,
    String? search,
  }) async {
    final response = await _apiClient.get<PaginatedResponse<Track>>(
      ApiConfig.musicServiceUrl,
      ApiConfig.topTracks,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (genre != null) 'genre': genre,
        if (search != null) 'search': search,
      },
      fromJson: (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        Track.fromApi,
      ),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch tracks');
  }

  /// Get track by ID
  Future<Track> getTrackById(String trackId) async {
    final endpoint = ApiConfig.trackDetailEndpoint.replaceAll('{id}', trackId);

    final response = await _apiClient.get<Track>(
      ApiConfig.musicServiceUrl,
      endpoint,
      fromJson: (json) => Track.fromApi(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch track');
  }

  Future<List<Track>> getTrendingTracks({int limit = 10}) async {
    /// Toggle nhanh khi test backend:
    /// - `true`  => dùng endpoint `/tracks/top-tracks` (cần Authorization)
    /// - `false` => dùng endpoint `/tracks/search?q=*` (public, thường trả nhiều bài hơn)
    const bool useTopTracksEndpoint = false; // Đổi sang false vì endpoint top-tracks không tồn tại

    /// CÁCH 1: /tracks/top-tracks (auth-gated)
    if (useTopTracksEndpoint) {
      final response = await _apiClient.get<List<Track>>(
        ApiConfig.musicServiceUrl,
        ApiConfig.topTracks,
        queryParameters: {'limit': limit.toString()},
        fromJson: (json) {
          // Some services wrap list under { data: [...] } which ApiClient already unwraps.
          if (json is List) {
            return json
                .whereType<Map<String, dynamic>>()
                .map(Track.fromApi)
                .toList();
          }
          return <Track>[];
        },
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw Exception(response.message ?? 'Failed to fetch trending tracks');
    }

    /// CÁCH 2: /tracks/search?q=* (public)
    final tracks = await searchTracks(query: '*', limit: limit);
    if (tracks.length <= limit) return tracks;
    return tracks.take(limit).toList();
  }

  /// Get all albums with pagination
  Future<PaginatedResponse<Album>> getAlbums({
    int page = 1,
    int pageSize = 20,
    String? artistId,
  }) async {
    final response = await _apiClient.get<PaginatedResponse<Album>>(
      ApiConfig.musicServiceUrl,
      ApiConfig.albumsEndpoint,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (artistId != null) 'artist_id': artistId,
      },
      fromJson: (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        Album.fromJson,
      ),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch albums');
  }

  /// Get album by ID
  Future<Album> getAlbumById(String albumId) async {
    final response = await _apiClient.get<Album>(
      ApiConfig.musicServiceUrl,
      '${ApiConfig.albumsEndpoint}/$albumId',
      fromJson: (json) => Album.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch album');
  }

  /// Get album with full details including artist name
  /// This fetches both album and artist info
  Future<Album> getAlbumWithDetails(String albumId) async {
    print('🔍 [getAlbumWithDetails] Fetching album: $albumId');
    final album = await getAlbumById(albumId);
    print('   ✅ Got album: ${album.title}, artist_id: ${album.artistId}, artist_name: ${album.artistName}');
    
    // Fetch artist name if not present
    if (album.artistName.isEmpty && album.artistId.isNotEmpty) {
      try {
        print('   🔍 Fetching artist profile: ${album.artistId}');
        final artist = await getArtistProfile(album.artistId);
        print('   ✅ Got artist: ${artist.nickname}');
        return Album(
          id: album.id,
          title: album.title,
          artistId: album.artistId,
          artistName: artist.nickname,
          coverUrl: album.coverUrl,
          releaseYear: album.releaseYear,
          trackIds: album.trackIds,
        );
      } catch (e) {
        print('   ⚠️ Failed to fetch artist name for album: $e');
        return album;
      }
    }
    
    print('   ℹ️ Artist name already present, skipping artist fetch');
    return album;
  }

  /// Get top albums
  /// Fallback: use /api/v1/albums endpoint since /albums/top-albums returns 404
  Future<List<Album>> getTopAlbums({
    int? month,
    int? year,
    int limit = 10,
  }) async {
    print('🔍 [getTopAlbums] Starting request...');
    print('   📍 Base URL: ${ApiConfig.musicServiceUrl}');
    print('   📍 Endpoint: ${ApiConfig.topAlbumsEndpoint}');
    print('   📊 Params: month=$month, year=$year, limit=$limit');
    
    // Thử dùng endpoint top-albums trước
    try {
      final queryParams = {
        if (month != null) 'month': month.toString(),
        if (year != null) 'year': year.toString(),
        'limit': limit.toString(),
      };
      print('   🌐 Full URL: ${ApiConfig.musicServiceUrl}${ApiConfig.topAlbumsEndpoint}?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}');
      
      final response = await _apiClient.get<List<Album>>(
        ApiConfig.musicServiceUrl,
        ApiConfig.topAlbumsEndpoint,
        queryParameters: queryParams,
        fromJson: (json) {
          print('   📥 Response type: ${json.runtimeType}');
          print('   📥 Response data: $json');
          if (json is List) {
            print('   ✅ Parsed ${json.length} albums');
            return json.map((e) => Album.fromJson(e as Map<String, dynamic>)).toList();
          }
          print('   ⚠️ Response is not a List');
          return [];
        },
      );

      if (response.success && response.data != null) {
        print('   ✅ Success! Got ${response.data!.length} albums');
        return response.data!;
      }
      print('   ❌ Response not successful or data is null');
    } catch (e) {
      print('   ⚠️ Top albums endpoint failed: $e');
      print('   🔄 Falling back to /api/v1/albums...');
    }

    // Fallback: Dùng endpoint /api/v1/albums với pagination
    print('   📍 Fallback endpoint: ${ApiConfig.albumsEndpoint}');
    final paginatedResponse = await getAlbums(page: 1, pageSize: limit);
    print('   ✅ Fallback success! Got ${paginatedResponse.items.length} albums');
    return paginatedResponse.items;
  }

  /// Get all artists with pagination
  Future<PaginatedResponse<Artist>> getArtists({
    int page = 1,
    int pageSize = 20,
    String? genre,
  }) async {
    final response = await _apiClient.get<PaginatedResponse<Artist>>(
      ApiConfig.musicServiceUrl,
      ApiConfig.artistsEndpoint,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (genre != null) 'genre': genre,
      },
      fromJson: (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        Artist.fromJson,
      ),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch artists');
  }

  /// Get artist profile by ID
  /// GET /artists/info/profile/{artist_id}
  Future<models.Artist> getArtistProfile(String artistId) async {
    final endpoint = ApiConfig.artistProfileEndpoint.replaceAll('{artist_id}', artistId);
    final response = await _apiClient.get<models.Artist>(
      ApiConfig.musicServiceUrl,
      endpoint,
      fromJson: (json) => models.Artist.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch artist profile');
  }

  /// Get artist by ID
  Future<Artist> getArtistById(String artistId) async {
    final response = await _apiClient.get<Artist>(
      ApiConfig.musicServiceUrl,
      '${ApiConfig.artistsEndpoint}/$artistId',
      fromJson: (json) => Artist.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch artist');
  }

  /// Get popular artists
  Future<List<Artist>> getPopularArtists({int limit = 10}) async {
    final response = await _apiClient.get<List<Artist>>(
      ApiConfig.musicServiceUrl,
      '${ApiConfig.artistsEndpoint}/popular',
      queryParameters: {'limit': limit.toString()},
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

    throw Exception(response.message ?? 'Failed to fetch popular artists');
  }

  /// Get top artists
  Future<List<models.Artist>> getTopArtists({int limit = 10}) async {
    final response = await _apiClient.get<List<models.Artist>>(
      ApiConfig.musicServiceUrl,
      ApiConfig.topArtistsEndpoint,
      queryParameters: {'limit': limit.toString()},
      fromJson: (json) {
        if (json is List) {
          final artists = json
              .map((e) => models.Artist.fromApi(e as Map<String, dynamic>))
              .toList();

          return artists;
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch top artists');
  }

  /// Get tracks by artist
  Future<List<Track>> getTracksByArtist(
    String artistId, {
    int limit = 50,
  }) async {
    final response = await _apiClient.get<List<Track>>(
      ApiConfig.musicServiceUrl,
      '${ApiConfig.artistsEndpoint}/$artistId/tracks',
      queryParameters: {'limit': limit.toString()},
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

    throw Exception(response.message ?? 'Failed to fetch artist tracks');
  }

  /// Get user's top tracks (can be used for recently played)
  Future<List<Track>> getUserTopTracks({int limit = 20}) async {
    final response = await _apiClient.get<List<Track>>(
      ApiConfig.musicServiceUrl,
      ApiConfig.topTracks,
      queryParameters: {'limit': limit.toString()},
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

    throw Exception(response.message ?? 'Failed to fetch user top tracks');
  }

  /// Increment stream count for a track
  Future<void> incrementStream(String trackId, String userId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.musicServiceUrl,
        ApiConfig.trackStreamsEndpoint.replaceAll('{id}', trackId),
        queryParameters: {'user_id': userId},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (!response.success) {
        debugPrint('⚠️ Failed to increment stream for track $trackId');
      }
    } catch (e) {
      debugPrint('❌ Error incrementing stream: $e');
      // Don't throw - stream tracking should not block playback
    }
  }

  /// Get user's recently played tracks
  Future<List<Track>> getRecentTracks() async {
    final response = await _apiClient.get<List<Track>>(
      ApiConfig.musicServiceUrl,
      ApiConfig.recentTracksEndpoint,
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

    throw Exception(response.message ?? 'Failed to fetch recent tracks');
  }
}
