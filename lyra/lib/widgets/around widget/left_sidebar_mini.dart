import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/core/di/service_locator.dart';
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
          _buildCustomIconMenuItem(
            'assets/icons/library_add_icon.svg',
            false,
            60,
          ),
          const SizedBox(height: 16),

          // Hiển thị recent tracks icons
          Expanded(
            child: ListView.separated(
              itemCount: _recentTracks.length > 3 ? 3 : _recentTracks.length,
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
}
