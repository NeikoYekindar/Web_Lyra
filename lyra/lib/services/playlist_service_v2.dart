import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/models/api_response.dart';
import '../models/track.dart';

/// Playlist model
class Playlist {
  final String id;
  final String name;
  final String? description;
  final String? coverUrl;
  final String ownerId;
  final String ownerName;
  final bool isPublic;
  final int trackCount;
  final int duration; // in seconds
  final int totalStreams; // total streams for sorting
  final List<String>? trackIds;
  final String? createdAt;
  final String? updatedAt;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.coverUrl,
    required this.ownerId,
    required this.ownerName,
    this.isPublic = false,
    this.trackCount = 0,
    this.duration = 0,
    this.totalStreams = 0,
    this.trackIds,
    this.createdAt,
    this.updatedAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final v = value.trim().toLowerCase();
        if (v == 'true' || v == '1' || v == 'yes') return true;
        if (v == 'false' || v == '0' || v == 'no') return false;
      }
      return false;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value.trim()) ?? 0;
      return 0;
    }

    List<String>? parsedTrackIds;
    final rawTrackIds = json['track_ids'] ?? json['id_tracks'] ?? json['tracks'];
    if (rawTrackIds is List) {
      parsedTrackIds = List<String>.from(rawTrackIds.map((e) => e.toString()));
    } else if (rawTrackIds is String && rawTrackIds.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawTrackIds);
        if (decoded is List) {
          parsedTrackIds = List<String>.from(decoded.map((e) => e.toString()));
        }
      } catch (_) {
        // ignore
      }
    }

    return Playlist(
      id: (json['playlist_id'] ?? json['id'])?.toString() ?? '',
      name:
          (json['playlist_name'] ?? json['name'] ?? json['title'])?.toString() ??
          '',
      description: json['description']?.toString(),
      coverUrl:
          (json['image_url'] ?? json['cover_url'] ?? json['image'])?.toString(),
      ownerId: (json['user_id'] ?? json['owner_id'])?.toString() ?? '',
      ownerName: json['owner_name']?.toString() ?? '',
      isPublic: parseBool(json['is_public'] ?? json['public']),
      trackCount: parseInt(
        json['total_tracks'] ?? json['track_count'] ?? json['tracks_count'],
      ),
      duration: parseInt(json['duration']),
      totalStreams: parseInt(json['total_streams']),
      trackIds: parsedTrackIds,
      createdAt: (json['created_at'] ?? json['release_date'])?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'cover_url': coverUrl,
    'owner_id': ownerId,
    'owner_name': ownerName,
    'is_public': isPublic,
    'track_count': trackCount,
    'duration': duration,
    'track_ids': trackIds,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

/// Playlist details model (includes track list)
class PlaylistDetail {
  final String playlistId;
  final String playlistName;
  final String userId;
  final bool isPublic;
  final String? imageUrl;
  final String? releaseDate;
  final int totalTracks;
  final int duration;
  final int totalStreams;
  final List<Track> tracks;

  const PlaylistDetail({
    required this.playlistId,
    required this.playlistName,
    required this.userId,
    required this.isPublic,
    this.imageUrl,
    this.releaseDate,
    required this.totalTracks,
    required this.duration,
    required this.totalStreams,
    required this.tracks,
  });

  factory PlaylistDetail.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final v = value.trim().toLowerCase();
        if (v == 'true' || v == '1' || v == 'yes') return true;
        if (v == 'false' || v == '0' || v == 'no') return false;
      }
      return false;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value.trim()) ?? 0;
      return 0;
    }

    final rawTracks = json['tracks'];
    final parsedTracks = <Track>[];
    if (rawTracks is List) {
      for (final item in rawTracks) {
        if (item is Map<String, dynamic>) {
          parsedTracks.add(Track.fromApi(item));
        }
      }
    }

    return PlaylistDetail(
      playlistId: (json['playlist_id'] ?? json['id'])?.toString() ?? '',
      playlistName:
          (json['playlist_name'] ?? json['name'] ?? json['title'])?.toString() ??
          '',
      userId: (json['user_id'] ?? json['owner_id'])?.toString() ?? '',
      totalTracks: parseInt(
        json['total_tracks'] ?? json['track_count'] ?? json['tracks_count'],
      ),
      duration: parseInt(json['duration']),
      isPublic: parseBool(json['is_public'] ?? json['public']),
      imageUrl:
          (json['image_url'] ?? json['cover_url'] ?? json['image'])?.toString(),
      releaseDate: (json['release_date'] ?? json['created_at'])?.toString(),
      totalStreams: parseInt(json['total_streams']),
      tracks: parsedTracks,
    );
  }
}

/// Playlist service for FastAPI microservice
class PlaylistServiceV2 {
  final ApiClient _apiClient;

  PlaylistServiceV2(this._apiClient);

  /// Get top playlists
  /// Swagger: GET /playlists/top-playlists?limit=10&month=&year=
  Future<List<Playlist>> getTopPlaylists({
    int limit = 10,
    int? month,
    int? year,
  }) async {
    final response = await _apiClient.get<List<Playlist>>(
      ApiConfig.playlistServiceUrl,
      ApiConfig.topPlaylistsEndpoint,
      queryParameters: {
        'limit': limit.toString(),
        if (month != null) 'month': month.toString(),
        if (year != null) 'year': year.toString(),
      },
      fromJson: (json) {
        if (json is List) {
          return json
              .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch top playlists');
  }

  /// Get all playlists with pagination
  Future<PaginatedResponse<Playlist>> getPlaylists({
    int page = 1,
    int pageSize = 20,
    bool? isPublic,
    String? ownerId,
  }) async {
    final response = await _apiClient.get<PaginatedResponse<Playlist>>(
      ApiConfig.playlistServiceUrl,
      ApiConfig.playlistsEndpoint,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (isPublic != null) 'is_public': isPublic.toString(),
        if (ownerId != null) 'owner_id': ownerId,
      },
      fromJson: (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        Playlist.fromJson,
      ),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch playlists');
  }

  /// Get current user's playlists
  Future<List<Playlist>> getUserPlaylists() async {
    final response = await _apiClient.get<List<Playlist>>(
      ApiConfig.playlistServiceUrl,
      '${ApiConfig.playlistsEndpoint}/me',
      fromJson: (json) {
        if (json is List) {
          return json
              .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch user playlists');
  }

  /// Get playlists for a specific user (legacy/compat endpoint)
  /// Swagger: GET /playlists/your-playlists?user_id=...
  Future<List<Playlist>> getYourPlaylists({required String userId}) async {
    final response = await _apiClient.get<List<Playlist>>(
      ApiConfig.playlistServiceUrl,
      ApiConfig.yourPlaylistsEndpoint,
      // Some backends apply a very small default page size.
      // Ask for a larger page size so the UI can show all playlists.
      queryParameters: {
        'user_id': userId,
        'page': '1',
        'page_size': ApiConfig.maxPageSize.toString(),
      },
      fromJson: (json) {
        dynamic raw = json;

        if (raw is Map<String, dynamic>) {
          raw = raw['data'] ?? raw['playlists'] ?? raw['items'] ?? raw['result'];
        }

        if (raw is List) {
          final playlists = <Playlist>[];
          for (final item in raw) {
            if (item is Map<String, dynamic>) {
              playlists.add(Playlist.fromJson(item));
            }
          }
          return playlists;
        }

        return <Playlist>[];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch your playlists');
  }

  /// Get playlist by ID
  Future<Playlist> getPlaylistById(String playlistId) async {
    final endpoint = ApiConfig.playlistDetailEndpoint.replaceAll(
      '{id}',
      playlistId,
    );

    final response = await _apiClient.get<Playlist>(
      ApiConfig.playlistServiceUrl,
      endpoint,
      fromJson: (json) => Playlist.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch playlist');
  }

  /// Get playlist details by ID (includes track objects)
  /// Swagger: GET /playlists/{playlist_id}
  Future<PlaylistDetail> getPlaylistDetail(String playlistId) async {
    final endpoint = ApiConfig.playlistDetailEndpoint.replaceAll(
      '{id}',
      playlistId,
    );

    final response = await _apiClient.get<PlaylistDetail>(
      ApiConfig.playlistServiceUrl,
      endpoint,
      fromJson: (json) =>
          PlaylistDetail.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to fetch playlist detail');
  }

  /// Create new playlist
  Future<Playlist> createPlaylist({
    required String name,
    String? description,
    bool isPublic = false,
    String? coverUrl,
  }) async {
    final response = await _apiClient.post<Playlist>(
      ApiConfig.playlistServiceUrl,
      ApiConfig.createPlaylistEndpoint,
      body: {
        'name': name,
        if (description != null) 'description': description,
        'is_public': isPublic,
        if (coverUrl != null) 'cover_url': coverUrl,
      },
      fromJson: (json) => Playlist.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to create playlist');
  }

  /// Create playlist via catalog endpoint (multipart)
  ///
  /// Docs: POST /playlists/create (multipart/form-data)
  /// Required: playlist_name, user_id
  /// Optional: is_public, duration, total_tracks, id_tracks (JSON string array)
  Future<Playlist> createPlaylistCatalog({
    required String playlistName,
    required String userId,
    bool isPublic = false,
    List<String>? trackIds,
    int? duration,
    int? totalTracks,
  }) async {
    /// Backend test toggle:
    /// - `true`  => send JSON array string: ["t01","t02"] (recommended)
    /// - `false` => send quoted CSV string: "t01","t02" (NO brackets)
    const bool useJsonArrayForIdTracks = false;

    final normalizedTrackIds = (trackIds ?? const <String>[])
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    final normalizedDuration = duration ?? 0;
    final normalizedTotalTracks = totalTracks ?? normalizedTrackIds.length;

    final idTracksValue = useJsonArrayForIdTracks
        ? jsonEncode(normalizedTrackIds)
        : normalizedTrackIds.map((id) => '$id').join(',');

    final fields = <String, dynamic>{
      'playlist_name': playlistName,
      'user_id': userId,
      'is_public': isPublic.toString(),
      // Backend validation may reject missing duration/total_tracks.
      'duration': normalizedDuration.toString(),
      'total_tracks': normalizedTotalTracks.toString(),
      // Some backends expect this field to exist even when empty.
      'id_tracks': idTracksValue,
    };

    assert(() {
      print('🧩 createPlaylistCatalog() payload');
      print('  playlist_name: $playlistName');
      print('  user_id: $userId');
      print('  is_public: ${isPublic.toString()}');
      print('  duration: ${normalizedDuration.toString()}');
      print('  total_tracks: ${normalizedTotalTracks.toString()}');
      print('  id_tracks: $idTracksValue');
      return true;
    }());

    final response = await _apiClient.postMultipart<Playlist>(
      ApiConfig.playlistServiceUrl,
      ApiConfig.playlistsCreateEndpoint,
      files: const [],
      fields: fields,
      fromJson: (json) => Playlist.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to create playlist');
  }

  /// Update playlist
  Future<Playlist> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    String? coverUrl,
  }) async {
    final endpoint = ApiConfig.playlistDetailEndpoint.replaceAll(
      '{id}',
      playlistId,
    );

    final response = await _apiClient.patch<Playlist>(
      ApiConfig.playlistServiceUrl,
      endpoint,
      body: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (isPublic != null) 'is_public': isPublic,
        if (coverUrl != null) 'cover_url': coverUrl,
      },
      fromJson: (json) => Playlist.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to update playlist');
  }

  /// Delete playlist
  Future<void> deletePlaylist(String playlistId) async {
    final endpoint = ApiConfig.playlistDetailEndpoint.replaceAll(
      '{id}',
      playlistId,
    );

    final response = await _apiClient.delete(
      ApiConfig.playlistServiceUrl,
      endpoint,
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to delete playlist');
    }
  }

  /// Add track to playlist
  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    final response = await _apiClient.post(
      ApiConfig.playlistServiceUrl,
      '${ApiConfig.playlistDetailEndpoint.replaceAll('{id}', playlistId)}/tracks',
      body: {'track_id': trackId},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to add track to playlist');
    }
  }

  /// Remove track from playlist
  Future<void> removeTrackFromPlaylist(
    String playlistId,
    String trackId,
  ) async {
    final response = await _apiClient.delete(
      ApiConfig.playlistServiceUrl,
      '${ApiConfig.playlistDetailEndpoint.replaceAll('{id}', playlistId)}/tracks/$trackId',
    );

    if (!response.success) {
      throw Exception(
        response.message ?? 'Failed to remove track from playlist',
      );
    }
  }

  /// Reorder tracks in playlist
  Future<void> reorderPlaylistTracks(
    String playlistId,
    List<String> trackIds,
  ) async {
    final response = await _apiClient.put(
      ApiConfig.playlistServiceUrl,
      '${ApiConfig.playlistDetailEndpoint.replaceAll('{id}', playlistId)}/tracks/reorder',
      body: {'track_ids': trackIds},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to reorder playlist tracks');
    }
  }
}
