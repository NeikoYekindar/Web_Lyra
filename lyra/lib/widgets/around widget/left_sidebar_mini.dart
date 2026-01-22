import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/services/music_service_v2.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../models/track.dart';
import '../../shell/app_shell_controller.dart';

class LeftSidebarMini extends StatefulWidget {
  final VoidCallback? onLibraryIconPressed;

  const LeftSidebarMini({super.key, this.onLibraryIconPressed});

  @override
  State<LeftSidebarMini> createState() => _LeftSidebarMiniState();
}

class _LeftSidebarMiniState extends State<LeftSidebarMini> {
  List<String> albumImages = [];
  List<Map<String, dynamic>> PlaylistsUserImages = [];
  bool _isLoadingPlaylistsUser = true;
  bool _isLoadingAlbums = true;
  List<Track> _recentTracks = [];
  List<Track> _originalRecentTracks = []; // Store original order
  bool _isLoadingTracks = true;
  List<Track> _queueTracks = []; // Queue lớn hơn cho playback

  @override
  void initState() {
    super.initState();
    _loadAlbumImages();
    _loadPlayListUser();
    _loadRecentTracks();
  }

  Future<void> _loadRecentTracks() async {
    try {
      // Load both recent tracks and top tracks for queue
      final recentTracks = await serviceLocator.musicService.getRecentTracks();

      if (mounted) {
        setState(() {
          _recentTracks = recentTracks;
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

  Future<void> _loadPlayListUser() async {
    try {
      // Giả lập API call
      await Future.delayed(const Duration(milliseconds: 800));

      final List<Map<String, dynamic>> apiResponse = [
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3',
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3',
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3',
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3',
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3',
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3',
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        // Thêm các bài hát khác tương tự
      ];

      if (mounted) {
        setState(() {
          PlaylistsUserImages = apiResponse;
          _isLoadingPlaylistsUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          PlaylistsUserImages = [];
        });
      }
      print('Error loading playlists user: $e');
    }
  }

  // Giả lập API call để lấy danh sách album
  Future<void> _loadAlbumImages() async {
    try {
      // Giả lập API call với delay
      await Future.delayed(const Duration(milliseconds: 500));

      final List<String> apiResponse = [
        'assets/images/album_1.png',
        'assets/images/album_2.png',
        'assets/images/album_3.png',
        'assets/images/album_3.png',
      ];

      if (mounted) {
        setState(() {
          albumImages = apiResponse;
          _isLoadingAlbums = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          albumImages = [];
          _isLoadingAlbums = false;
        });
      }
      print('Error loading albums: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,

      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 8, bottom: 10, left: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomIconMenuItemLibrary(
            'assets/icons/library_icon.svg',
            true,
            60,
            widget.onLibraryIconPressed,
          ),
          const SizedBox(height: 8),
          _buildCreateButtonMini(),
          const SizedBox(height: 16),

          // Hiển thị recent tracks icons
          Expanded(
            child: ListView.separated(
              itemCount: _recentTracks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final track = _recentTracks[index];
                return _buildTrackIconMini(track, false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomIconMenuItemLibrary(
    String svgPath,
    bool isActive,
    double size,
    VoidCallback? onPressed,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed ?? () {},
          child: Center(
            child: SvgPicture.asset(svgPath, width: 25, height: 25),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomIconMenuItem(String svgPath, bool isActive, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Center(
            child: SvgPicture.asset(svgPath, width: 45, height: 45),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumIconPNG(String pngPath, bool isActive) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            print('Clicked album: $pngPath'); // Debug log
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              pngPath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback widget khi không load được PNG
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getAlbumColor(pngPath),
                        _getAlbumColor(pngPath).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(Icons.album, color: Colors.white, size: 60),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _getAlbumColor(String pngPath) {
    // Trả về màu khác nhau dựa trên tên file
    if (pngPath.contains('album1')) return Colors.red;
    if (pngPath.contains('album2')) return Colors.blue;
    if (pngPath.contains('album3')) return Colors.green;
    return Colors.orange; // Default color
  }

  Widget _buildTrackIconMini(Track track, bool isActive) {
    return GestureDetector(
      onTap: () => _onTrackTapped(track),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: track.trackImageUrl.isNotEmpty
              ? Image.network(
                  track.trackImageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  },
                )
              : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
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

  Widget _buildCreateButtonMini() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _showCreatePlaylistDialog,
          child: Center(
            child: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => const _CreatePlaylistDialogMini(),
    );
  }
}

class _CreatePlaylistDialogMini extends StatefulWidget {
  const _CreatePlaylistDialogMini();

  @override
  State<_CreatePlaylistDialogMini> createState() => _CreatePlaylistDialogMiniState();
}

class _CreatePlaylistDialogMiniState extends State<_CreatePlaylistDialogMini> {
  final TextEditingController _playlistNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Track> _searchResults = [];
  List<Track> _selectedTracks = [];
  bool _isSearching = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _playlistNameController.text = AppLocalizations.of(context)?.myPlaylist ?? 'My Playlist #1';
      _isInitialized = true;
    }
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
      final paginatedResult = await musicService.getTracks(search: query, pageSize: 20);
      if (mounted) {
        setState(() {
          _searchResults = paginatedResult.items;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
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

  void _createPlaylist() {
    final playlistName = _playlistNameController.text.trim();
    if (playlistName.isEmpty) return;

    // TODO: Implement actual playlist creation with API
    print('Creating playlist: $playlistName with ${_selectedTracks.length} tracks');
    Navigator.of(context).pop();
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
            // Header
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

            // Playlist name input
            TextField(
              controller: _playlistNameController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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

            // Search section
            Text(
              l10n?.findSongsForPlaylist ?? "Let's find something for your playlist",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Search input
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => _searchTracks(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF3E3E3E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                hintText: l10n?.searchSongsAndPodcasts ?? 'Search for songs and podcasts',
                hintStyle: const TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 16),

            // Search results / Selected tracks
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _searchResults.isNotEmpty
                      ? ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final track = _searchResults[index];
                            final isSelected = _selectedTracks.any((t) => t.id == track.id);
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
                                    child: const Icon(Icons.music_note, color: Colors.white),
                                  ),
                                ),
                              ),
                              title: Text(
                                track.title,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                track.artist,
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                                maxLines: 1,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isSelected ? Icons.check_circle : Icons.add_circle_outline,
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
                                              child: const Icon(Icons.music_note, color: Colors.white, size: 20),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          track.title,
                                          style: const TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.remove_circle, color: Colors.red),
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
                                l10n?.searchSongsAndPodcasts ?? 'Search for songs to add',
                                style: const TextStyle(color: Colors.white38),
                              ),
                            ),
            ),

            // Create button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createPlaylist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
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
}
