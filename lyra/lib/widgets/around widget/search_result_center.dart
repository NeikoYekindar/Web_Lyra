import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:lyra/shell/app_shell_controller.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/models/search_response.dart';
import 'package:lyra/widgets/common/trackItem.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:lyra/models/track.dart';

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
      print('Calling API with query: $query');
      final results = await searchService.searchTracksV2(query: query);
      print('API returned ${results.total} results');

      if (mounted) {
        setState(() {
          _searchResults = results;
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

  // Mock Data giả lập
  final List<String> _filters = [
    'All',
    'Artists',
    'Songs',
    'Playlists',
    'Albums',
    'Podcasts',
  ];
  int _selectedFilterIndex = 0;

  final List<Map<String, String>> _artists = [
    {'name': 'Sơn Tùng M-TP', 'image': 'assets/images/HTH.png'},
    {'name': 'SOOBIN', 'image': 'assets/images/HTH.png'},
    {'name': 'Shiki', 'image': 'assets/images/HTH.png'}, // Placeholder
    {'name': 'Saabirose', 'image': 'assets/images/HTH.png'},
    {'name': 'Seachains', 'image': 'assets/images/HTH.png'},
  ];

  final List<Map<String, String>> _songs = [
    {
      'title': 'SO ĐẬM',
      'artist': 'EM XINH "SAY HI", Phương Ly...',
      'image': 'assets/images/HTH.png',
      'duration': '3:40',
    },
    {
      'title': 'Sinh Ra Đã Là Thứ Đối Lập nhau',
      'artist': 'Emcee L (Da LAB), Badbies',
      'image': 'assets/images/HTH.png',
      'duration': '3:54',
    },
    {
      'title': 'Say Yes (Vietnamese Version)',
      'artist': 'OgeNus, PiaLinh',
      'image': 'assets/images/HTH.png',
      'duration': '3:43',
    },
    {
      'title': 'Sau Cơn Mưa',
      'artist': 'CoolKid, RHYDER',
      'image': 'assets/images/HTH.png',
      'duration': '2:34',
    },
  ];

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
                        labelStyle: TextStyle(
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
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (_searchResults != null)
                    Text(
                      'Found ${_searchResults!.total} results',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            style: const TextStyle(color: Colors.red),
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
                  // 2. Artists Section (Mock data - endpoint not ready)
                  const Text(
                    'Artists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180, // Chiều cao cố định cho list ngang
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _artists.length,
                      separatorBuilder: (ctx, index) =>
                          const SizedBox(width: 20),
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(
                                _artists[index]['image']!,
                              ),
                              backgroundColor: Colors.grey[800],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _artists[index]['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Artist',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // 3. Songs Section
                  const Text(
                    'Songs',
                    style: TextStyle(
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
                            artist: hit.artistName,
                            albumArtist: hit.kind,
                            duration: _formatStreams(hit.streams),
                            image:
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
                                final allTracks = await Future.wait(
                                  _searchResults!.hits.map(
                                    (h) => musicService.getTrackById(h.trackId),
                                  ),
                                );

                                await player.setTrack(track, queue: allTracks);
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
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          'No songs found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // 4. Playlists Section (Mock data - endpoint not ready)
                  const Text(
                    'Playlists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (ctx, index) {
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                    color: Colors
                                        .primaries[index %
                                            Colors.primaries.length]
                                        .withOpacity(0.5),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Playlist ${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'By Lyra',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
