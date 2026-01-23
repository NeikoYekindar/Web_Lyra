import 'track.dart';

/// Response model for track search
class SearchTracksResponse {
  final String query;
  final List<SearchTrackHit> hits;
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
              ?.map((e) => SearchTrackHit.fromJson(e as Map<String, dynamic>))
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

/// Individual track hit in search results
class SearchTrackHit {
  final String trackId;
  final String trackName;
  final String artistName;
  final String? lyrics;
  final int streams;
  final String kind;

  const SearchTrackHit({
    required this.trackId,
    required this.trackName,
    required this.artistName,
    this.lyrics,
    required this.streams,
    required this.kind,
  });

  factory SearchTrackHit.fromJson(Map<String, dynamic> json) {
    return SearchTrackHit(
      trackId: json['track_id'] ?? '',
      trackName: json['track_name'] ?? '',
      artistName: json['artist_name'] ?? '',
      lyrics: json['lyrics'],
      streams: json['streams'] ?? 0,
      kind: json['kind'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'track_id': trackId,
    'track_name': trackName,
    'artist_name': artistName,
    'lyrics': lyrics,
    'streams': streams,
    'kind': kind,
  };

  /// Convert to Track model (with minimal data available)
  Track toTrack() {
    return Track(
      trackId: trackId,
      artistId: '', // Not available in search response
      trackName: trackName,
      duration: 0, // Not available in search response
      kind: kind,
      streams: streams,
      trackFileUrl: '', // Not available in search response
      lyricFileUrl: lyrics ?? '',
      trackImageUrl: '', // Not available in search response
      status: 'active',
    );
  }
}
