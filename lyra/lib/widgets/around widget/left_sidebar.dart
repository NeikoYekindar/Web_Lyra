import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/services/left_sidebar_service.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../models/track.dart';
import '../../shell/app_shell_controller.dart';
import '../common/trackItem.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _isLoadingTracks = true;
  List<Track> _queueTracks = []; // Queue lớn hơn cho playback
  @override
  void initState() {
    super.initState();
    _loadLeftSidebarCategories();
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
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildCustomIconMenuItemLibraryCreate(
                  'assets/icons/create.svg',
                  false,
                  120,
                  60,
                ),
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

          // Recent Activity Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.all(8),

            child: Row(
              children: [
                _buildCustomIconMenuItemLibraryCreate(
                  'assets/icons/SearchLeftSideBar.svg',
                  false,
                  38,
                  38,
                ),
                const SizedBox(width: 8),

                const Spacer(),
                Text(
                  AppLocalizations.of(context)?.recent ?? 'Recent',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                _buildCustomIconMenuItemLibraryCreate(
                  'assets/icons/MenuLeftSideBar.svg',
                  false,
                  45,
                  45,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_recentTracks.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentTracks.length > 3
                        ? 3
                        : _recentTracks.length,
                    itemBuilder: (context, index) {
                      final track = _recentTracks[index];
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: PlaylistsUser.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final playlists = PlaylistsUser[index];
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
        ],
      ),
    );
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
                ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
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

                      style: GoogleFonts.inter(
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
                      style: GoogleFonts.inter(
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
                //   style: GoogleFonts.inter(
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
