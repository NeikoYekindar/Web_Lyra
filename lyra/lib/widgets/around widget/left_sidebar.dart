import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/services/left_sidebar_service.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../models/track.dart';
import '../../shell/app_shell_controller.dart';
import '../common/trackItem.dart';

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
  List<Track> _originalRecentTracks = []; // Store original order for "Recent" sort
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
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

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
          _originalRecentTracks = List.from(recentTracks); // Save original order
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
      final apiResponse = await LeftSidebarService.getPlaylistsUser();

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
                  style: TextStyle(
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
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
                      style: TextStyle(
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                hintText: AppLocalizations.of(context)?.searchLibrary ?? 'Search in library...',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  if (_filteredRecentTracks.isNotEmpty) ...[
                    // Image only view - Grid layout
                    if (_currentViewOption == ViewOption.imageOnly)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              child: Text(
                                track.trackName,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
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
                          return GestureDetector(
                            onTap: () => _onTrackTapped(track),
                            child: TrackItem(
                              index: index + 1,
                              title: track.trackName,
                              artist: track.artist,
                              albumArtist: track.kind,
                              duration: _formatDuration(track.durationMs),
                              image: track.trackImageUrl,
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 12),
                  ],
                  // Show "No results" message when searching but nothing found
                  if (_searchQuery.isNotEmpty && 
                      _filteredRecentTracks.isEmpty && 
                      _filteredPlaylistsUser.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)?.noResults ?? 'No results found',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.transparent),
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
                        playlists: playlists,
                        // onTap: () => _onPlaylistUserTapped(playlists),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
        ...SortOption.values.map((option) => PopupMenuItem<SortOption>(
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
        )),
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
          _recentTracks.sort((a, b) => 
            a.trackName.toLowerCase().compareTo(b.trackName.toLowerCase()));
          PlaylistsUser.sort((a, b) => 
            (a['name'] ?? '').toString().toLowerCase()
              .compareTo((b['name'] ?? '').toString().toLowerCase()));
          break;
        case SortOption.creator:
          _recentTracks = List.from(_originalRecentTracks);
          _recentTracks.sort((a, b) => 
            a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
          PlaylistsUser.sort((a, b) => 
            (a['owner'] ?? '').toString().toLowerCase()
              .compareTo((b['owner'] ?? '').toString().toLowerCase()));
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

      // Show player if not shown
      if (!shellController.isPlayerMaximized) {
        shellController.toggleMaximizePlayer();
      }
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
    final defaultName = '${AppLocalizations.of(context)?.myPlaylist ?? "My Playlist"} #$playlistNumber';
    
    showDialog(
      context: context,
      builder: (context) => _CreatePlaylistDialog(
        defaultName: defaultName,
        onCreatePlaylist: (name) {
          _createNewPlaylist(name);
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
  final Map<String, dynamic> playlists;
  final VoidCallback? onTap;

  const PlaylistUserCard({super.key, required this.playlists, this.onTap});

  @override
  State<PlaylistUserCard> createState() => _PlaylistUserCardState();
}

class _PlaylistUserCardState extends State<PlaylistUserCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          padding: const EdgeInsets.all(8),
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: _isHovered
                ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: double.infinity,
            // padding: EdgeInsets.all(_isHovered ? 8 : 0),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Thay đổi từ start sang center

              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.playlists['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // if (_isHovered)
                    //     Positioned(
                    //       bottom: 8,
                    //       right: 8,
                    //       child: Container(
                    //         width: 48,
                    //         height: 48,
                    //         decoration: BoxDecoration(
                    //           color: const Color(0xFFE62429),
                    //           shape: BoxShape.circle,
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.black.withOpacity(0.3),
                    //               blurRadius: 8,
                    //               offset: const Offset(0, 4),
                    //             ),
                    //           ],
                    //         ),
                    //         child: const Icon(
                    //           Icons.play_arrow,
                    //           color: Colors.black,
                    //           size: 28,
                    //         ),
                    //       ),
                    //     ),
                  ],
                ),

                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.playlists['name'],

                      style: TextStyle(
                        color: _isHovered
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.95),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.playlists['type'] +
                          ' · ' +
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

                // Text(
                //   widget.playlists['role'],
                //   style: TextStyle(
                //     color: Colors.grey[400],
                //     fontSize: 12,
                //   ),
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Create Playlist Dialog - Spotify style
class _CreatePlaylistDialog extends StatefulWidget {
  final String defaultName;
  final Function(String) onCreatePlaylist;

  const _CreatePlaylistDialog({
    required this.defaultName,
    required this.onCreatePlaylist,
  });

  @override
  State<_CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<_CreatePlaylistDialog> {
  late TextEditingController _nameController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.defaultName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Placeholder for alignment
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Playlist info section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playlist cover placeholder
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.music_note,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 24),

                // Playlist details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.publicPlaylist ?? 'Public Playlist',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Editable playlist name
                      TextField(
                        controller: _nameController,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _createPlaylist(),
                      ),
                      const SizedBox(height: 16),
                      // Owner info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Icon(
                              Icons.person,
                              size: 14,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'You', // TODO: Get actual user name
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                // Add collaborator button
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Add collaborator functionality
                    },
                    icon: Icon(
                      Icons.person_add_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // More options button
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: More options
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Search section title
            Text(
              AppLocalizations.of(context)?.findSongsForPlaylist ?? 
                  "Let's find something for your playlist",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)?.searchSongsAndPodcasts ?? 
                                  'Search for songs and podcasts',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Close/Cancel button
                IconButton(
                  onPressed: () {
                    _createPlaylist();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createPlaylist() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      widget.onCreatePlaylist(name);
    }
    Navigator.pop(context);
  }
}