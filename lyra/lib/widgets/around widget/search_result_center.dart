import 'package:flutter/material.dart';
import 'package:lyra/core/config/api_config.dart';
import 'package:provider/provider.dart';
import 'package:lyra/shell/app_shell_controller.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/models/search_response.dart';
import 'package:lyra/widgets/common/trackItem.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/models/artist.dart';
import 'package:lyra/widgets/center widget/album_detail.dart';

class SearchResultCenter extends StatefulWidget {
  final String? initialQuery;

  const SearchResultCenter({super.key, this.initialQuery});

  @override
  State<SearchResultCenter> createState() => _SearchResultCenterState();
}

class _SearchResultCenterState extends State<SearchResultCenter> {
  late String _currentQuery;

  String get searchQuery => _currentQuery;

  // Search results state
  bool _isLoading = false;
  SearchTracksResponse? _searchResults;
  SearchAlbumsResponse? _albumResults;
  SearchArtistsResponse? _artistResults;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Get query from widget argument or fallback to controller
    _currentQuery =
        widget.initialQuery ?? context.read<AppShellController>().searchText;

    // Perform search immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    final query = _currentQuery;
    print('=== SEARCH DEBUG ===');
    print('Query from controller: "$query"');
    print('Query isEmpty: ${query.isEmpty}');
    print('Query length: ${query.length}');
    print('===================');

    if (query.isEmpty) {
      print('Query is empty, skipping search');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final searchService = ServiceLocator().searchService;
      print('Calling search APIs with query: $query');

      // Gọi cả 3 endpoints song song
      final results = await Future.wait([
        searchService.searchTracksV2(query: query),
        searchService.searchAlbumsV2(query: query),
        searchService.searchArtistsV2(query: query),
      ]);

      final trackResults = results[0] as SearchTracksResponse;
      final albumResults = results[1] as SearchAlbumsResponse;
      final artistResults = results[2] as SearchArtistsResponse;

      print(
        'API returned: ${trackResults.total} tracks, '
        '${albumResults.total} albums, ${artistResults.total} artists',
      );

      // Attach artist objects to track hits so UI can show nickname immediately
      try {
        final apiClient = ServiceLocator().apiClient;
        final Map<String, Artist> artistCache = {};
        for (var i = 0; i < trackResults.hits.length; i++) {
          final t = trackResults.hits[i];
          if ((t.artistObj == null) && t.artistId.isNotEmpty) {
            if (artistCache.containsKey(t.artistId)) {
              trackResults.hits[i] = t.copyWith(
                artistObj: artistCache[t.artistId],
              );
              continue;
            }

            try {
              final artistResp = await apiClient.get<Map<String, dynamic>>(
                ApiConfig.musicServiceUrl,
                '/artists/info/profile/${t.artistId}',
                fromJson: (json) => json as Map<String, dynamic>,
              );

              if (artistResp.success && artistResp.data != null) {
                // prefer 'fr' field if present
                final artistData = (artistResp.data! is Map<String, dynamic>)
                    ? artistResp.data! as Map<String, dynamic>
                    : (artistResp.data! as Map<String, dynamic>?);

                if (artistData != null) {
                  final artistObj = Artist.fromJson(artistData);
                  artistCache[t.artistId] = artistObj;
                  trackResults.hits[i] = t.copyWith(artistObj: artistObj);
                } else {
                  final nickname =
                      artistResp.data!['nickname']?.toString() ?? '';
                  if (nickname.isNotEmpty) {
                    trackResults.hits[i] = t.copyWith(artistName: nickname);
                  }
                }
              }
            } catch (e) {
              debugPrint(
                'Failed to fetch artist for search hit ${t.artistId}: $e',
              );
            }
          }
        }
      } catch (e) {
        debugPrint(
          'Error while attaching artist objects to search results: $e',
        );
      }

      if (mounted) {
        setState(() {
          _searchResults = trackResults;
          _albumResults = albumResults;
          _artistResults = artistResults;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Search error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Filter options
  final List<String> _filters = [
    'All',
    'Artists',
    'Songs',
    'Playlists',
    'Albums',
  ];
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Background màu tối
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ScrollConfiguration(
          behavior: _NoScrollbarBehavior(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Filter Chips (All, Artists, Songs...)
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (ctx, index) => const SizedBox(width: 10),
                    itemBuilder: (ctx, index) {
                      final isSelected = _selectedFilterIndex == index;
                      return ChoiceChip(
                        label: Text(_filters[index]),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedFilterIndex = index;
                          });
                        },
                        backgroundColor: Colors.transparent,
                        selectedColor: Colors.white,
                        labelStyle: GoogleFonts.inter(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Search Query Display
                if (searchQuery.isNotEmpty) ...[
                  Text(
                    'Search results for: "$searchQuery"',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_searchResults != null)
                    Text(
                      'Found ${_searchResults!.total} results',
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // Loading indicator
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // Error message
                if (_errorMessage != null && !_isLoading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: $_errorMessage',
                            style: GoogleFonts.inter(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _performSearch,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Results
                if (!_isLoading && _errorMessage == null) ...[
                  // 2. Artists Section
                  Text(
                    'Artists',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_artistResults != null && _artistResults!.hits.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _artistResults!.hits.length,
                        separatorBuilder: (ctx, index) =>
                            const SizedBox(width: 20),
                        itemBuilder: (ctx, index) {
                          final artist = _artistResults!.hits[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to artist page
                              Navigator.of(
                                context,
                              ).pushNamed('/artist', arguments: artist);
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        artist.imageUrl != null &&
                                            artist.imageUrl!.isNotEmpty
                                        ? NetworkImage(artist.imageUrl!)
                                        : const AssetImage(
                                                'assets/images/HTH.png',
                                              )
                                              as ImageProvider,
                                    backgroundColor: Colors.grey[800],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      artist.nickname,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_formatStreams(artist.totalFollowers)} followers',
                                    style: GoogleFonts.inter(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    'Artist',
                                    style: GoogleFonts.inter(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else if (_artistResults != null &&
                      _artistResults!.hits.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No artists found',
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // 3. Songs Section
                  Text(
                    'Songs',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Display API results or empty state
                  if (_searchResults != null && _searchResults!.hits.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _searchResults!.hits.length,
                      itemBuilder: (ctx, index) {
                        final hit = _searchResults!.hits[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TrackItem(
                            title: hit.trackName,
                            artist: hit.artistObj?.nickname ?? 'Unknown Artist',
                            albumArtist: hit.kind,
                            duration: _formatDuration(hit.durationMs),
                            image:
                                hit.imageUrl ??
                                'assets/images/HTH.png', // Placeholder vì API không trả về image
                            onTap: () async {
                              try {
                                // Show loading indicator
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Loading track...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );

                                // Fetch full track info from API
                                final musicService =
                                    ServiceLocator().musicService;
                                final track = await musicService.getTrackById(
                                  hit.trackId,
                                );

                                if (!context.mounted) return;

                                // Play track with queue from search results
                                final player = context
                                    .read<MusicPlayerProvider>();

                                // Fetch full track objects for all hits
                                final allTracks = await Future.wait(
                                  _searchResults!.hits.map(
                                    (h) => musicService.getTrackById(h.trackId),
                                  ),
                                );

                                // Attach artistObj for each fetched track by calling artist API
                                final apiClient = ServiceLocator().apiClient;
                                final Map<String, Artist> artistCache = {};
                                for (var i = 0; i < allTracks.length; i++) {
                                  var t = allTracks[i];
                                  if (t.artistObj == null &&
                                      t.artistId.isNotEmpty) {
                                    if (artistCache.containsKey(t.artistId)) {
                                      t = t.copyWith(
                                        artistObj: artistCache[t.artistId],
                                      );
                                    } else {
                                      try {
                                        final artistResp = await apiClient
                                            .get<Map<String, dynamic>>(
                                              ApiConfig.musicServiceUrl,
                                              '/artists/info/profile/${t.artistId}',
                                              fromJson: (json) =>
                                                  json as Map<String, dynamic>,
                                            );
                                        if (artistResp.success &&
                                            artistResp.data != null) {
                                          final artistData =
                                              artistResp.data!
                                                  as Map<String, dynamic>?;
                                          if (artistData != null) {
                                            final artistObj = Artist.fromJson(
                                              artistData,
                                            );
                                            artistCache[t.artistId] = artistObj;
                                            t = t.copyWith(
                                              artistObj: artistObj,
                                            );
                                          } else {
                                            final nickname =
                                                artistResp.data!['nickname']
                                                    ?.toString() ??
                                                '';
                                            if (nickname.isNotEmpty) {
                                              t = t.copyWith(
                                                artistName: nickname,
                                              );
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        debugPrint(
                                          'Failed to fetch artist for ${t.artistId}: $e',
                                        );
                                      }
                                    }
                                    allTracks[i] = t;
                                  }
                                }

                                // Ensure the single 'track' being played also has artistObj
                                var playTrack = track;
                                if (playTrack.artistObj == null &&
                                    playTrack.artistId.isNotEmpty) {
                                  if (artistCache.containsKey(
                                    playTrack.artistId,
                                  )) {
                                    playTrack = playTrack.copyWith(
                                      artistObj:
                                          artistCache[playTrack.artistId],
                                    );
                                  } else {
                                    try {
                                      final artistResp = await ServiceLocator()
                                          .apiClient
                                          .get<Map<String, dynamic>>(
                                            ApiConfig.musicServiceUrl,
                                            '/artists/info/profile/${playTrack.artistId}',
                                            fromJson: (json) =>
                                                json as Map<String, dynamic>,
                                          );
                                      if (artistResp.success &&
                                          artistResp.data != null) {
                                        final artistData =
                                            artistResp.data!
                                                as Map<String, dynamic>?;
                                        if (artistData != null) {
                                          final artistObj = Artist.fromJson(
                                            artistData,
                                          );
                                          playTrack = playTrack.copyWith(
                                            artistObj: artistObj,
                                          );
                                        } else {
                                          final nickname =
                                              artistResp.data!['nickname']
                                                  ?.toString() ??
                                              '';
                                          if (nickname.isNotEmpty) {
                                            playTrack = playTrack.copyWith(
                                              artistName: nickname,
                                            );
                                          }
                                        }
                                      }
                                    } catch (e) {
                                      debugPrint(
                                        'Failed to fetch artist for play track ${playTrack.artistId}: $e',
                                      );
                                    }
                                  }
                                }

                                await player.setTrack(
                                  playTrack,
                                  queue: allTracks,
                                );
                                player.play();
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error playing track: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    )
                  else if (_searchResults != null &&
                      _searchResults!.hits.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          'No songs found',
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // 4. Albums Section
                  Text(
                    'Albums',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_albumResults != null && _albumResults!.hits.isNotEmpty)
                    SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _albumResults!.hits.length,
                        itemBuilder: (ctx, index) {
                          final album = _albumResults!.hits[index];
                          return Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Open album detail
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AlbumDetailScreen(
                                      albumId: album.albumId,
                                      albumName: album.albumName,
                                      albumImage: album.albumImageUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(8),
                                            ),
                                        color: Colors.grey[800],
                                      ),
                                      child: album.albumImageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(8),
                                                  ),
                                              child: Image.network(
                                                album.albumImageUrl!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (_, __, ___) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons.album,
                                                        color: Colors.white,
                                                        size: 40,
                                                      ),
                                                    ),
                                              ),
                                            )
                                          : const Center(
                                              child: Icon(
                                                Icons.album,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          album.albumName,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          album.artistName,
                                          style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            if (album.releaseYear != null) ...[
                                              Text(
                                                album.releaseYear!,
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              if (album.totalTrack != null)
                                                Text(
                                                  ' • ',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.grey,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                            ],
                                            if (album.totalTrack != null)
                                              Text(
                                                '${album.totalTrack} tracks',
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey,
                                                  fontSize: 11,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else if (_albumResults != null && _albumResults!.hits.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No albums found',
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ], // End if (!_isLoading && _errorMessage == null)
                // Spacer bottom
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatStreams(int streams) {
    if (streams >= 1000000) {
      return '${(streams / 1000000).toStringAsFixed(1)}M';
    } else if (streams >= 1000) {
      return '${(streams / 1000).toStringAsFixed(1)}K';
    }
    return streams.toString();
  }

  String _formatDuration(int? ms) {
    if (ms == null || ms <= 0) return '0:00';
    final totalSeconds = (ms / 1000).round();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
