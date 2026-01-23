import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/api_config.dart';
import '../../core/di/service_locator.dart';
import '../../models/track.dart';
import '../../providers/music_player_provider.dart';
import '../../services/playlist_service_v2.dart';
import '../../shell/app_shell_controller.dart';
import '../common/trackItem.dart';
import 'package:lyra/theme/app_theme.dart';
class PlaylistDetailScreen extends StatefulWidget {
  final String playlistId;
  final String playlistName;
  final String? playlistImage;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
    this.playlistImage,
  });

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  PlaylistDetail? _playlistDetail;
  bool _isLoading = true;
  String? _error;
  String? _ownerName;

  @override
  void initState() {
    super.initState();
    _loadPlaylistDetail();
  }

  @override
  void didUpdateWidget(PlaylistDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload playlist detail if playlistId changed
    if (oldWidget.playlistId != widget.playlistId) {
      _loadPlaylistDetail();
    }
  }

  Future<void> _loadPlaylistDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final detail = await serviceLocator.playlistService
          .getPlaylistDetail(widget.playlistId);

      final apiClient = ServiceLocator().apiClient;

      // Fetch owner/artist name using userId
      String? ownerName;
      if (detail.userId.isNotEmpty) {
        try {
          final artistResponse = await apiClient.get<Map<String, dynamic>>(
            ApiConfig.musicServiceUrl,
            '/artists/info/profile/${detail.userId}',
            fromJson: (json) => json as Map<String, dynamic>,
          );
          if (artistResponse.success && artistResponse.data != null) {
            ownerName = artistResponse.data!['nickname']?.toString();
          }
        } catch (e) {
          debugPrint('Failed to load owner name: $e');
        }
      }

      // Fetch artist names for tracks that don't have artist_name
      final Map<String, String> artistNameCache = {};
      final List<Track> updatedTracks = [];
      
      for (final track in detail.tracks) {
        // If track already has artistName or artistObj, use as-is
        if (track.artistName.isNotEmpty || track.artistObj != null) {
          updatedTracks.add(track);
          continue;
        }
        
        // Otherwise fetch artist name
        final artistId = track.artistId;
        if (artistId.isEmpty) {
          updatedTracks.add(track);
          continue;
        }
        
        // Check cache first
        if (artistNameCache.containsKey(artistId)) {
          updatedTracks.add(track.copyWith(artistName: artistNameCache[artistId]));
          continue;
        }
        
        // Fetch from API
        try {
          final artistResponse = await apiClient.get<Map<String, dynamic>>(
            ApiConfig.musicServiceUrl,
            '/artists/info/profile/$artistId',
            fromJson: (json) => json as Map<String, dynamic>,
          );
          if (artistResponse.success && artistResponse.data != null) {
            final nickname = artistResponse.data!['nickname']?.toString() ?? '';
            artistNameCache[artistId] = nickname;
            updatedTracks.add(track.copyWith(artistName: nickname));
          } else {
            updatedTracks.add(track);
          }
        } catch (e) {
          debugPrint('Failed to load artist name for $artistId: $e');
          updatedTracks.add(track);
        }
      }

      // Create updated detail with new tracks
      final updatedDetail = PlaylistDetail(
        playlistId: detail.playlistId,
        playlistName: detail.playlistName,
        userId: detail.userId,
        isPublic: detail.isPublic,
        imageUrl: detail.imageUrl,
        releaseDate: detail.releaseDate,
        totalTracks: detail.totalTracks,
        duration: detail.duration,
        totalStreams: detail.totalStreams,
        tracks: updatedTracks,
      );

      if (mounted) {
        setState(() {
          _playlistDetail = updatedDetail;
          _ownerName = ownerName;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return '$hours hr $minutes min';
    }
    return '$minutes min';
  }

  String _formatTrackDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _playPlaylist() async {
    if (_playlistDetail == null || _playlistDetail!.tracks.isEmpty) return;

    final musicPlayerProvider = Provider.of<MusicPlayerProvider>(
      context,
      listen: false,
    );
    final shellController = Provider.of<AppShellController>(
      context,
      listen: false,
    );

    await musicPlayerProvider.setTrack(
      _playlistDetail!.tracks.first,
      queue: _playlistDetail!.tracks,
    );
    musicPlayerProvider.play();

    if (!shellController.isPlayerMaximized) {
      shellController.toggleMaximizePlayer();
    }
  }

  Future<void> _playTrack(Track track) async {
    if (_playlistDetail == null) return;

    final musicPlayerProvider = Provider.of<MusicPlayerProvider>(
      context,
      listen: false,
    );
    final shellController = Provider.of<AppShellController>(
      context,
      listen: false,
    );

    await musicPlayerProvider.setTrack(
      track,
      queue: _playlistDetail!.tracks,
    );
    musicPlayerProvider.play();

    if (!shellController.isPlayerMaximized) {
      shellController.toggleMaximizePlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading playlist',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPlaylistDetail,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_playlistDetail == null) {
      return const SizedBox.shrink();
    }

    final detail = _playlistDetail!;

    return CustomScrollView(
      slivers: [
        // Header with gradient background
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 238, 29, 29).withOpacity(0.8),
                  Theme.of(context).colorScheme.surface,
                ],
                stops: const [0.0, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: IconButton(
                    onPressed: () {
                      // Clear center content to go back to home
                      final shellController = Provider.of<AppShellController>(
                        context,
                        listen: false,
                      );
                      shellController.closeCenterContent();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                
                // Playlist info section
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Playlist cover image
                      Container(
                        width: 232,
                        height: 232,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildPlaylistImage(),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Playlist info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Playlist',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              detail.playlistName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (_ownerName != null) ...[
                                  Text(
                                    _ownerName!,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    ' • ',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                Text(
                                  '${detail.totalTracks} tracks, ${_formatDuration(detail.duration)}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 14,
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
              ],
            ),
          ),
        ),

        // Controls (Play button, etc.)
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Row(
              children: [
                // Play button
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.redPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _playPlaylist,
                      customBorder: const CircleBorder(),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 32),

                // Add to liked songs button
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 16),

                // More options
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Track list header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 28),
                const SizedBox(width: 12),
                const SizedBox(width: 50),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Title',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Album',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Track list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = detail.tracks[index];
                return TrackItem(
                  index: index + 1,
                  title: track.trackName,
                  artist: track.artist,
                  albumArtist: track.kind,
                  duration: _formatTrackDuration(track.duration),
                  image: track.trackImageUrl,
                  onTap: () => _playTrack(track),
                );
              },
              childCount: detail.tracks.length,
            ),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildPlaylistImage() {
    final imageUrl = _playlistDetail?.imageUrl ?? widget.playlistImage;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackImage(),
        );
      } else {
        return Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackImage(),
        );
      }
    }

    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      color: const Color(0xFF8B4513),
      child: Center(
        child: Icon(
          Icons.music_note,
          size: 100,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
