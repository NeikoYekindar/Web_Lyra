import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../models/track.dart';
import '../../models/current_user.dart';
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
      final recentTracks = await serviceLocator.musicService.getRecentTracks();

      if (!mounted) return;
      setState(() {
        _recentTracks = recentTracks;
        _originalRecentTracks = List.from(recentTracks);

        final allTracks = [...recentTracks];
        final seenIds = <String>{};
        _queueTracks = allTracks.where((track) {
          if (seenIds.contains(track.trackId)) return false;
          seenIds.add(track.trackId);
          return true;
        }).toList();

        _isLoadingTracks = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _recentTracks = [];
        _originalRecentTracks = [];
        _queueTracks = [];
        _isLoadingTracks = false;
      });
      print('Error loading recent tracks: $e');
    }
  }

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
            PlaylistsUserImages = [];
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
            },
          )
          .toList();

      if (!mounted) return;
      setState(() {
        PlaylistsUserImages = apiResponse;
        _isLoadingPlaylistsUser = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        PlaylistsUserImages = [];
        _isLoadingPlaylistsUser = false;
      });
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

      // Load track with full queue (at least 10 tracks). Prefer recommendations.
      await musicPlayerProvider.setTrackWithRecommended(
        track,
        fallbackQueue: _queueTracks,
      );
      musicPlayerProvider.play();
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
              child: const Icon(Icons.add, color: Colors.white, size: 28),
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
    ).then((_) => _loadPlayListUser());
  }
}

class _CreatePlaylistDialogMini extends StatefulWidget {
  const _CreatePlaylistDialogMini();

  @override
  State<_CreatePlaylistDialogMini> createState() =>
      _CreatePlaylistDialogMiniState();
}

class _CreatePlaylistDialogMiniState extends State<_CreatePlaylistDialogMini> {
  final TextEditingController _playlistNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Track> _searchResults = <Track>[];
  final List<Track> _selectedTracks = <Track>[];

  bool _isSearching = false;
  bool _isInitialized = false;
  bool _isCreating = false;
  bool _isPublic = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _playlistNameController.text =
          AppLocalizations.of(context)?.myPlaylist ?? 'My Playlist #1';
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleTrackSelection(Track track) {
    setState(() {
      final existingIndex = _selectedTracks.indexWhere(
        (t) => t.trackId == track.trackId,
      );
      if (existingIndex >= 0) {
        _selectedTracks.removeAt(existingIndex);
      } else {
        _selectedTracks.add(track);
      }
    });
  }

  Future<void> _searchTracks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = <Track>[];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results = await serviceLocator.musicService.searchTracks(
        query: query,
        limit: 20,
      );
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchResults = <Track>[];
        _isSearching = false;
      });
    }
  }

  Future<void> _createPlaylist() async {
    final name = _playlistNameController.text.trim();
    if (name.isEmpty) return;

    final userId = CurrentUser.instance.user?.userId ?? '';
    if (userId.isEmpty) {
      if (!mounted) return;
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

      await serviceLocator.playlistService.createPlaylistCatalog(
        playlistName: name,
        userId: userId,
        isPublic: _isPublic,
        trackIds: trackIds.isEmpty ? null : trackIds,
        totalTracks: trackIds.isEmpty ? null : trackIds.length,
        duration: duration > 0 ? duration : null,
      );

      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 420,
        height: 620,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n?.createPlaylist ?? 'Create playlist',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _playlistNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Playlist name',
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
              ),

              const SizedBox(height: 12),
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
                            (t) => t.trackId == track.trackId,
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
                                color: isSelected
                                    ? Colors.green
                                    : Colors.white54,
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
                                    onPressed: () =>
                                        _toggleTrackSelection(track),
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
      ),
    );
  }
}
