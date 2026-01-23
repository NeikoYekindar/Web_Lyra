import 'track.dart';
import 'artist.dart';
import 'album.dart';

/// Response model for track search
class SearchTracksResponse {
  final String query;
  final List<Track> hits;
  final int total;

  const SearchTracksResponse({
    required this.query,
    required this.hits,
    required this.total,
  });

  factory SearchTracksResponse.fromJson(Map<String, dynamic> json) {
    return SearchTracksResponse(
      query: json['query'] ?? '',
      hits:
          (json['hits'] as List?)
              ?.map((e) => Track.fromApi(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'query': query,
    'hits': hits.map((e) => e.toJson()).toList(),
    'total': total,
  };
}

/// Response model for album search
class SearchAlbumsResponse {
  final String query;
  final List<Album> hits;
  final int total;

  const SearchAlbumsResponse({
    required this.query,
    required this.hits,
    required this.total,
  });

  factory SearchAlbumsResponse.fromJson(Map<String, dynamic> json) {
    return SearchAlbumsResponse(
      query: json['query'] ?? '',
      hits:
          (json['hits'] as List?)
              ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}

/// Response model for artist search
class SearchArtistsResponse {
  final String query;
  final List<Artist> hits;
  final int total;

  const SearchArtistsResponse({
    required this.query,
    required this.hits,
    required this.total,
  });

  factory SearchArtistsResponse.fromJson(Map<String, dynamic> json) {
    return SearchArtistsResponse(
      query: json['query'] ?? '',
      hits:
          (json['hits'] as List?)
              ?.map((e) => Artist.fromApi(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}
