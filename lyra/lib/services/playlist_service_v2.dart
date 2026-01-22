import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/models/api_response.dart';

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
    this.trackIds,
    this.createdAt,
    this.updatedAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      coverUrl: json['cover_url']?.toString() ?? json['image']?.toString(),
      ownerId: json['owner_id']?.toString() ?? '',
      ownerName: json['owner_name']?.toString() ?? '',
      isPublic: json['is_public'] ?? json['public'] ?? false,
      trackCount: json['track_count'] ?? json['tracks_count'] ?? 0,
      trackIds: json['track_ids'] != null
          ? List<String>.from(json['track_ids'])
          : null,
      createdAt: json['created_at']?.toString(),
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
    'track_ids': trackIds,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

/// Playlist service for FastAPI microservice
class PlaylistServiceV2 {
  final ApiClient _apiClient;

  PlaylistServiceV2(this._apiClient);

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
