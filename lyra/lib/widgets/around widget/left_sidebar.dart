import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/services/left_sidebar_service.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../models/track.dart';
import '../../models/current_user.dart';
import '../../shell/app_shell_controller.dart';
import '../common/trackItem.dart';
import '../../services/playlist_service_v2.dart';
import '../center widget/playlist_detail.dart';

// Enum for sort options
enum SortOption { recent, recentlyAdded, alphabetical, creator }

// Enum for view options
enum ViewOption { defaultView, titleOnly, imageOnly }

class LeftSidebar extends StatefulWidget {
  final VoidCallback? onCollapsePressed;

  const LeftSidebar({super.key, this.onCollapsePressed});

  @override
  State<LeftSidebar> createState() => _LeftSidebarState();
}

class _LeftSidebarState extends State<LeftSidebar> {
  List<String> categories = [];
  List<Map<String, dynamic>> PlaylistsUser = [];
  int _selectedCategoryIndex = 0;
  bool _isLoadingCategories = true;
  bool _isLoadingPlaylistsUser = true;
  List<Track> _recentTracks = [];
  List<Track> _originalRecentTracks =
      []; // Store original order for "Recent" sort
  bool _isLoadingTracks = true;
  List<Track> _queueTracks = []; // Queue lớn hơn cho playback

  // Search functionality
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Sort and View options (like Spotify)
  SortOption _currentSortOption = SortOption.recent;
  ViewOption _currentViewOption = ViewOption.defaultView;

  // Filtered lists based on search query
  List<Track> get _filteredRecentTracks {
    if (_searchQuery.isEmpty) return _recentTracks;
    final query = _searchQuery.toLowerCase();
    return _recentTracks.where((track) {
      return track.trackName.toLowerCase().contains(query) ||
          track.artist.toLowerCase().contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredPlaylistsUser {
    if (_searchQuery.isEmpty) return PlaylistsUser;
    final query = _searchQuery.toLowerCase();
    return PlaylistsUser.where((playlist) {
      final name = (playlist['name'] ?? '').toString().toLowerCase();
      final owner = (playlist['owner'] ?? '').toString().toLowerCase();
      return name.contains(query) || owner.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadLeftSidebarCategories();
    _loadRecentTracks();
    _loadPlayListUser();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  String get _selectedCategoryName {
    if (categories.isEmpty || _selectedCategoryIndex >= categories.length) {
      return 'Tracks';
    }
    return categories[_selectedCategoryIndex];
  }

  bool get _showTracks => _selectedCategoryName.toLowerCase() == 'tracks';
  bool get _showPlaylists => _selectedCategoryName.toLowerCase() == 'playlists';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to music player changes to refresh recent tracks
    final musicPlayer = Provider.of<MusicPlayerProvider>(context, listen: true);
    // Refresh recent tracks when current track changes
    if (musicPlayer.currentTrack != null && _recentTracks.isNotEmpty) {
      final currentTrackId = musicPlayer.currentTrack!.trackId;
      // If current track is not in recent list, reload
      if (!_recentTracks.any((t) => t.trackId == currentTrackId)) {
        _loadRecentTracks();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecentTracks() async {
    try {
      // Load both recent tracks and top tracks for queue
      final recentTracks = await serviceLocator.musicService.getRecentTracks();

      if (mounted) {
        setState(() {
          _recentTracks = recentTracks;
          _originalRecentTracks = List.from(
            recentTracks,
          ); // Save original order
          // Combine recent and top tracks for queue, remove duplicates
          final allTracks = [...recentTracks];
          final seenIds = <String>{};
          _queueTracks = allTracks.where((track) {
            if (seenIds.contains(track.trackId)) {
              return false;
            }
            seenIds.add(track.trackId);
            return true;
          }).toList();
          _isLoadingTracks = false;
        });
      }
    } catch (e) {
      print('Error loading recent tracks: $e');
      if (mounted) {
        setState(() {
          _recentTracks = [];
          _queueTracks = [];
          _isLoadingTracks = false;
        });
      }
    }
  }

  Future<void> _loadLeftSidebarCategories() async {
    try {
      final apiResponse = await LeftSidebarService.getCategories();

      if (mounted) {
        setState(() {
          categories = apiResponse;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          categories = [];
          _isLoadingCategories = false;
        });
      }
    }
  }

  // Removed album image loading (unused) to clean up warnings.

  Future<void> _loadPlayListUser() async {
    try {
      final userId = CurrentUser.instance.user?.userId ?? '';
      if (mounted) {
        setState(() {
          _isLoadingPlaylistsUser = true;
        });
      }

      if (userId.isEmpty) {
        if (mounted) {
          setState(() {
            PlaylistsUser = [];
            _isLoadingPlaylistsUser = false;
          });
        }
        return;
      }

      final playlists = await serviceLocator.playlistService.getYourPlaylists(
        userId: userId,
      );

      final ownerName = CurrentUser.instance.user?.displayName ?? 'You';
      final apiResponse = playlists
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'type': 'Playlist',
              'owner': (p.ownerName.isNotEmpty ? p.ownerName : ownerName),
              'image': (p.coverUrl != null && p.coverUrl!.isNotEmpty)
                  ? p.coverUrl!
                  : 'assets/images/khongbuon.png',
              'duration': p.duration,
              // Preserve track ids so tapping playlist can play them.
              'track_ids': p.trackIds ?? <String>[],
            },
          )
          .toList();

      if (mounted) {
        setState(() {
          PlaylistsUser = apiResponse;
          _isLoadingPlaylistsUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          PlaylistsUser = [];
          _isLoadingPlaylistsUser = false;
        });
      }
      print('Error loading playlists user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 8, bottom: 10, left: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCustomIconMenuItemLibrary(
                  'assets/icons/closetominisize_icon.svg',
                  false,
                  40,
                  40,
                  widget.onCollapsePressed,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)?.yourLibrary ?? 'Your Library',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildCreateButton(),
                const SizedBox(width: 2),
                _buildCustomIconMenuItemLibraryCreate(
                  'assets/icons/expand.svg',
                  false,
                  35,
                  35,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.transparent),
            child: SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedCategoryIndex;
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });

                      final selected = categories[index].toLowerCase();
                      if (selected == 'playlists') {
                        _loadPlayListUser();
                      } else if (selected == 'tracks') {
                        _loadRecentTracks();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      foregroundColor: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      minimumSize: Size(
                        categories[index].length * 10.0 + 20,
                        40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      categories[index],
                      style: GoogleFonts.inter(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Recent Activity Section with Search
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.all(8),

            child: Row(
              children: [
                // Search icon / Search field toggle
                if (_isSearching)
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Icon(
                            Icons.search,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(
                                      context,
                                    )?.searchLibrary ??
                                    'Search in library...',
                                hintStyle: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  _buildSearchIconButton(),
                  const SizedBox(width: 8),
                  const Spacer(),
                  _buildSortMenuButton(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showTracks && _filteredRecentTracks.isNotEmpty) ...[
                    // Image only view - Grid layout
                    if (_currentViewOption == ViewOption.imageOnly)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: _filteredRecentTracks.length,
                        itemBuilder: (context, index) {
                          final track = _filteredRecentTracks[index];
                          return GestureDetector(
                            onTap: () => _onTrackTapped(track),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: buildCoverImage(
                                track.trackImageUrl.isEmpty
                                    ? 'assets/images/khongbuon.png'
                                    : track.trackImageUrl,
                              ),
                            ),
                          );
                        },
                      )
                    // Title only view - Simple list
                    else if (_currentViewOption == ViewOption.titleOnly)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredRecentTracks.length,
                        itemBuilder: (context, index) {
                          final track = _filteredRecentTracks[index];
                          return GestureDetector(
                            onTap: () => _onTrackTapped(track),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Text(
                                track.trackName,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      )
                    // Default view - Full TrackItem
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredRecentTracks.length,
                        itemBuilder: (context, index) {
                          final track = _filteredRecentTracks[index];
                          return TrackItem(
                            index: index + 1,
                            title: track.trackName,
                            artist: track.artist,
                            albumArtist: track.kind,
                            duration: _formatDuration(track.durationMs),
                            image: track.trackImageUrl,
                            onTap: () => _onTrackTapped(track),
                          );
                        },
                      ),
                    const SizedBox(height: 12),
                  ],
                  // Show "No results" message when searching but nothing found
                  if (_searchQuery.isNotEmpty &&
                      ((_showTracks && _filteredRecentTracks.isEmpty) ||
                          (_showPlaylists && _filteredPlaylistsUser.isEmpty)))
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)?.noResults ??
                              'No results found',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  if (_showPlaylists)
                    if (_isLoadingPlaylistsUser)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_filteredPlaylistsUser.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No playlists',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: _filteredPlaylistsUser.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final playlists = _filteredPlaylistsUser[index];
                            return PlaylistUserCard(
                              index: index + 1,
                              playlists: playlists,
                              onTap: () => _onPlaylistUserTapped(playlists),
                            );
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onPlaylistUserTapped(Map<String, dynamic> playlist) async {
    try {
      final playlistId =
          (playlist['playlist_id'] ?? playlist['id'] ?? '').toString();
      if (playlistId.trim().isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid playlist id.')),
        );
        return;
      }

      if (!mounted) return;
      final shellController = Provider.of<AppShellController>(
        context,
        listen: false,
      );

      // Show playlist detail screen in center
      shellController.showCenterContent(
        PlaylistDetailScreen(
          key: ValueKey('playlist_$playlistId'),
          playlistId: playlistId,
          playlistName: playlist['name'] ?? 'Playlist',
          playlistImage: playlist['image'],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Open playlist failed: $e')));
    }
  }

  // Search icon button widget
  Widget _buildSearchIconButton() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
          // Focus the search field after it's rendered
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _searchFocusNode.requestFocus();
          });
        },
        style: IconButton.styleFrom(overlayColor: Colors.transparent),
        icon: SvgPicture.asset(
          'assets/icons/SearchLeftSideBar.svg',
          width: 38,
          height: 38,
        ),
      ),
    );
  }

  // Get sort option display text
  String _getSortOptionText(SortOption option) {
    final l10n = AppLocalizations.of(context);
    switch (option) {
      case SortOption.recent:
        return l10n?.recent ?? 'Recent';
      case SortOption.recentlyAdded:
        return l10n?.recentlyAdded ?? 'Recently Added';
      case SortOption.alphabetical:
        return l10n?.alphabetical ?? 'Alphabetical';
      case SortOption.creator:
        return l10n?.creator ?? 'Creator';
    }
  }

  // Build sort/view menu button (like Spotify)
  Widget _buildSortMenuButton() {
    return PopupMenuButton<dynamic>(
      tooltip: '',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      onSelected: (value) {
        setState(() {
          if (value is SortOption) {
            _currentSortOption = value;
            _applySorting();
          } else if (value is ViewOption) {
            _currentViewOption = value;
          }
        });
      },
      itemBuilder: (context) => [
        // Sort by header
        PopupMenuItem<void>(
          enabled: false,
          height: 36,
          child: Text(
            AppLocalizations.of(context)?.sortBy ?? 'Sort by',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Sort options
        ...SortOption.values.map(
          (option) => PopupMenuItem<SortOption>(
            value: option,
            height: 44,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getSortOptionText(option),
                    style: TextStyle(
                      color: _currentSortOption == option
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: _currentSortOption == option
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (_currentSortOption == option)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
        // Divider
        const PopupMenuDivider(),
        // View as header
        PopupMenuItem<void>(
          enabled: false,
          height: 36,
          child: Text(
            AppLocalizations.of(context)?.viewAs ?? 'View as',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // View options as icons row
        PopupMenuItem<void>(
          enabled: false,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ViewOption.values.map((option) {
              final isSelected = _currentViewOption == option;
              return InkWell(
                onTap: () {
                  setState(() {
                    _currentViewOption = option;
                  });
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.surfaceVariant
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getViewOptionIcon(option),
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getSortOptionText(_currentSortOption),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/icons/MenuLeftSideBar.svg',
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }

  // Get icon for view option
  IconData _getViewOptionIcon(ViewOption option) {
    switch (option) {
      case ViewOption.defaultView:
        return Icons.view_list_rounded;
      case ViewOption.titleOnly:
        return Icons.text_fields_rounded;
      case ViewOption.imageOnly:
        return Icons.image_rounded;
    }
  }

  // Get view option display text
  String _getViewOptionText(ViewOption option) {
    final l10n = AppLocalizations.of(context);
    switch (option) {
      case ViewOption.defaultView:
        return l10n?.defaultView ?? 'Default';
      case ViewOption.titleOnly:
        return l10n?.titleOnly ?? 'Title only';
      case ViewOption.imageOnly:
        return l10n?.imageOnly ?? 'Image only';
    }
  }

  // Apply sorting to lists
  void _applySorting() {
    setState(() {
      switch (_currentSortOption) {
        case SortOption.recent:
          // Restore original order (recent first)
          _recentTracks = List.from(_originalRecentTracks);
          break;
        case SortOption.recentlyAdded:
          // Sort by recently added (oldest first - reverse of original)
          _recentTracks = List.from(_originalRecentTracks.reversed);
          break;
        case SortOption.alphabetical:
          _recentTracks = List.from(_originalRecentTracks);
          _recentTracks.sort(
            (a, b) =>
                a.trackName.toLowerCase().compareTo(b.trackName.toLowerCase()),
          );
          PlaylistsUser.sort(
            (a, b) => (a['name'] ?? '').toString().toLowerCase().compareTo(
              (b['name'] ?? '').toString().toLowerCase(),
            ),
          );
          break;
        case SortOption.creator:
          _recentTracks = List.from(_originalRecentTracks);
          _recentTracks.sort(
            (a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()),
          );
          PlaylistsUser.sort(
            (a, b) => (a['owner'] ?? '').toString().toLowerCase().compareTo(
              (b['owner'] ?? '').toString().toLowerCase(),
            ),
          );
          break;
      }
    });
  }

  Widget _buildCustomIconMenuItemLibrary(
    String svgPath,
    bool isActive,
    double sizeWidth,
    double sizeHeight,
    VoidCallback? onPressed,
  ) {
    return Container(
      width: sizeWidth,
      height: sizeHeight,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed ?? () {},
        style: IconButton.styleFrom(overlayColor: Colors.transparent),
        icon: SvgPicture.asset(
          svgPath,
          width: 25,
          height: 25,
          // colorFilter: ColorFilter.mode(
          //   isActive ? Colors.white : Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }

  void _onTrackTapped(Track track) async {
    try {
      final musicPlayerProvider = Provider.of<MusicPlayerProvider>(
        context,
        listen: false,
      );
      final shellController = Provider.of<AppShellController>(
        context,
        listen: false,
      );

      // Load track with full queue (at least 10 tracks)
      await musicPlayerProvider.setTrack(track, queue: _queueTracks);
      musicPlayerProvider.play();
    } catch (e) {
      print('Error playing track: $e');
    }
  }

  String _formatDuration(int durationMs) {
    final seconds = durationMs ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Create button that shows playlist creation dialog
  Widget _buildCreateButton() {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () => _showCreatePlaylistDialog(),
        style: IconButton.styleFrom(overlayColor: Colors.transparent),
        icon: SvgPicture.asset(
          'assets/icons/create.svg',
          width: 120,
          height: 60,
        ),
      ),
    );
  }

  // Show create playlist dialog like Spotify
  void _showCreatePlaylistDialog() {
    // Generate playlist name with number
    final playlistNumber = PlaylistsUser.length + 1;
    final defaultName =
        '${AppLocalizations.of(context)?.myPlaylist ?? "My Playlist"} #$playlistNumber';

    showDialog(
      context: context,
      builder: (context) => _CreatePlaylistDialog(
        defaultName: defaultName,
        onCreatePlaylist: (playlist) {
          _createNewPlaylistFromApi(playlist);
        },
      ),
    );
  }

  // Create new playlist
  void _createNewPlaylist(String name) {
    setState(() {
      PlaylistsUser.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'type': 'Playlist',
        'owner': 'You', // TODO: Get actual user name
        'image': 'assets/images/khongbuon.png', // Default playlist image
      });
    });
  }

  void _createNewPlaylistFromApi(Playlist playlist) {
    if (categories.isNotEmpty) {
      final playlistIndex = categories.indexWhere(
        (c) => c.toLowerCase() == 'playlists',
      );
      if (playlistIndex >= 0) {
        setState(() {
          _selectedCategoryIndex = playlistIndex;
          _searchController.clear();
          _searchQuery = '';
        });
      }
    }

    _loadPlayListUser();
  }

  Widget _buildCustomIconMenuItemLibraryCreate(
    String svgPath,
    bool isActive,
    double sizeWidth,
    double sizeHeight,
  ) {
    return Container(
      width: sizeWidth,
      height: sizeHeight,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {},
        style: IconButton.styleFrom(overlayColor: Colors.transparent),
        icon: SvgPicture.asset(
          svgPath,
          width: sizeWidth,
          height: sizeHeight,
          // colorFilter: ColorFilter.mode(
          //   isActive ? Colors.white : Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }
}

class PlaylistUserCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> playlists;
  final VoidCallback? onTap;

  const PlaylistUserCard(
      {super.key, required this.index, required this.playlists, this.onTap});

  @override
  State<PlaylistUserCard> createState() => _PlaylistUserCardState();
}

class _PlaylistUserCardState extends State<PlaylistUserCard> {
  bool _hovering = false;
  bool _pressed = false;

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _backgroundColor(BuildContext context) {
    if (_pressed) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.13);
    }
    if (_hovering) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.07);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.onTap != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: isInteractive ? (_) => setState(() => _pressed = true) : null,
        onTapUp: isInteractive ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: isInteractive ? () => setState(() => _pressed = false) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          color: _backgroundColor(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Index number
              SizedBox(
                width: 30,
                child: Text(
                  '${widget.index}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Thumbnail image
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Builder(
                  builder: (context) {
                    final image =
                        (widget.playlists['image'] ?? '').toString();
                    final fallbackAsset = 'assets/images/khongbuon.png';

                    if (image.startsWith('http://') ||
                        image.startsWith('https://')) {
                      return Image.network(
                        image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          fallbackAsset,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      );
                    }

                    return Image.asset(
                      image.isNotEmpty ? image : fallbackAsset,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        fallbackAsset,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Playlist name and owner
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.playlists['name'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.playlists['owner'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Total duration
              Text(
                _formatDuration(
                  (widget.playlists['duration'] ?? 0) is int
                      ? widget.playlists['duration']
                      : int.tryParse(
                              widget.playlists['duration']?.toString() ?? '0') ??
                          0,
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _CreatePlaylistDialog extends StatefulWidget {
  final String defaultName;
  final Function(Playlist) onCreatePlaylist;

  const _CreatePlaylistDialog({
    required this.defaultName,
    required this.onCreatePlaylist,
  });

  @override
  State<_CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<_CreatePlaylistDialog> {
  late final TextEditingController _playlistNameController;
  final TextEditingController _searchController = TextEditingController();
  List<Track> _searchResults = [];
  final List<Track> _selectedTracks = [];
  bool _isSearching = false;
  bool _isCreating = false;
  bool _isPublic = false;

  @override
  void initState() {
    super.initState();
    _playlistNameController = TextEditingController(text: widget.defaultName);
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchTracks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final musicService = serviceLocator.musicService;
      final results = await musicService.searchTracks(query: query, limit: 20);

      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _toggleTrackSelection(Track track) {
    setState(() {
      if (_selectedTracks.any((t) => t.id == track.id)) {
        _selectedTracks.removeWhere((t) => t.id == track.id);
      } else {
        _selectedTracks.add(track);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: const Color(0xFF282828),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n?.createPlaylist ?? 'Create Playlist',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _playlistNameController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onSubmitted: (_) => _createPlaylist(),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF3E3E3E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: l10n?.myPlaylist ?? 'My Playlist',
                hintStyle: const TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                ChoiceChip(
                  label: const Text('Private'),
                  selected: !_isPublic,
                  onSelected: (_) => setState(() => _isPublic = false),
                  selectedColor: const Color(0xFF3E3E3E),
                  backgroundColor: const Color(0xFF2F2F2F),
                  labelStyle: TextStyle(
                    color: !_isPublic ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Public'),
                  selected: _isPublic,
                  onSelected: (_) => setState(() => _isPublic = true),
                  selectedColor: const Color(0xFF3E3E3E),
                  backgroundColor: const Color(0xFF2F2F2F),
                  labelStyle: TextStyle(
                    color: _isPublic ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              l10n?.findSongsForPlaylist ??
                  "Let's find something for your playlist",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: _searchTracks,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF3E3E3E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                hintText:
                    l10n?.searchSongsAndPodcasts ??
                    'Search for songs and podcasts',
                hintStyle: const TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _isSearching
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final track = _searchResults[index];
                        final isSelected = _selectedTracks.any(
                          (t) => t.id == track.id,
                        );

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              track.trackImageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 48,
                                height: 48,
                                color: Colors.grey.shade800,
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            track.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            track.artist,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              color: isSelected ? Colors.green : Colors.white54,
                            ),
                            onPressed: () => _toggleTrackSelection(track),
                          ),
                        );
                      },
                    )
                  : _selectedTracks.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_selectedTracks.length} tracks selected',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _selectedTracks.length,
                            itemBuilder: (context, index) {
                              final track = _selectedTracks[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    track.trackImageUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.grey.shade800,
                                      child: const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  track.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _toggleTrackSelection(track),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        l10n?.searchSongsAndPodcasts ??
                            'Search for songs to add',
                        style: const TextStyle(color: Colors.white38),
                      ),
                    ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _createPlaylist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isCreating
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        l10n?.create ?? 'Create',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createPlaylist() async {
    final name = _playlistNameController.text.trim();
    if (name.isEmpty) return;

    final userId = CurrentUser.instance.user?.userId ?? '';
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to create a playlist.')),
      );
      return;
    }

    if (_isCreating) return;
    setState(() => _isCreating = true);

    try {
      final trackIds = _selectedTracks
          .map((t) => t.trackId)
          .where((id) => id.trim().isNotEmpty)
          .toList();

      final duration = _selectedTracks.fold<int>(
        0,
        (sum, t) => sum + (t.duration > 0 ? t.duration : 0),
      );

      final created = await serviceLocator.playlistService
          .createPlaylistCatalog(
            playlistName: name,
            userId: userId,
            isPublic: _isPublic,
            trackIds: trackIds.isEmpty ? null : trackIds,
            totalTracks: trackIds.isEmpty ? null : trackIds.length,
            duration: duration > 0 ? duration : null,
          );

      if (!mounted) return;
      widget.onCreatePlaylist(created);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Create playlist failed: $e')));
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }
}
