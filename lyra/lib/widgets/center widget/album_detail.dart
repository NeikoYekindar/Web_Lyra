import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/api_config.dart';
import '../../core/di/service_locator.dart';
import '../../models/track.dart';
import '../../providers/music_player_provider.dart';
import '../../services/music_service_v2.dart';
import '../../shell/app_shell_controller.dart';
import '../common/trackItem.dart';
import 'package:lyra/theme/app_theme.dart';

/// Album detail model (includes track list)
class AlbumDetail {
  final String albumId;
  final String albumName;
  final String artistId;
  final int totalTracks;
  final int duration;
  final String? imageUrl;
  final String? releaseDate;
  final int streams;
  final List<Track> tracks;

  const AlbumDetail({
    required this.albumId,
    required this.albumName,
    required this.artistId,
    required this.totalTracks,
    required this.duration,
    this.imageUrl,
    this.releaseDate,
    required this.streams,
    required this.tracks,
  });

  factory AlbumDetail.fromJson(Map<String, dynamic> json) {
    return AlbumDetail(
      albumId: json['album_id']?.toString() ?? '',
      albumName: json['album_name']?.toString() ?? '',
      artistId: json['artist_id']?.toString() ?? '',
      totalTracks: json['total_track'] as int? ?? 0,
      duration: json['duration'] as int? ?? 0,
      imageUrl: json['album_image_url']?.toString(),
      releaseDate: json['release_date']?.toString(),
      streams: json['streams'] as int? ?? 0,
      tracks: (json['tracks'] as List?)
              ?.map((t) => Track.fromApi(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;
  final String albumName;
  final String? albumImage;

  const AlbumDetailScreen({
    super.key,
    required this.albumId,
    required this.albumName,
    this.albumImage,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  AlbumDetail? _albumDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAlbumDetail();
  }

  @override
  void didUpdateWidget(AlbumDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload album detail if albumId changed
    if (oldWidget.albumId != widget.albumId) {
      _loadAlbumDetail();
    }
  }

  Future<void> _loadAlbumDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('🎵 [AlbumDetail] Loading album: ${widget.albumId}');
      
      // Use ApiClient directly to get full response with tracks
      final apiClient = ServiceLocator().apiClient;
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConfig.musicServiceUrl,
        '/albums/${widget.albumId}',
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      if (response.success && response.data != null) {
        print('🎵 [AlbumDetail] Raw response: ${response.data}');
        
        if (mounted) {
          setState(() {
            _albumDetail = AlbumDetail.fromJson(response.data!);
            _isLoading = false;
          });
          
          print('✅ [AlbumDetail] Loaded: ${_albumDetail!.albumName} with ${_albumDetail!.tracks.length} tracks');
        }
      } else {
        throw Exception(response.message ?? 'Failed to load album');
      }
    } catch (e) {
      print('❌ [AlbumDetail] Error: $e');
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

  Future<void> _playAlbum() async {
    if (_albumDetail == null || _albumDetail!.tracks.isEmpty) return;

    final musicPlayerProvider = Provider.of<MusicPlayerProvider>(
      context,
      listen: false,
    );
    final shellController = Provider.of<AppShellController>(
      context,
      listen: false,
    );

    await musicPlayerProvider.setTrack(
      _albumDetail!.tracks.first,
      queue: _albumDetail!.tracks,
    );
    musicPlayerProvider.play();

    if (!shellController.isPlayerMaximized) {
      shellController.toggleMaximizePlayer();
    }
  }

  Future<void> _playTrack(Track track) async {
    if (_albumDetail == null) return;

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
      queue: _albumDetail!.tracks,
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
                        'Error loading album',
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
                        onPressed: _loadAlbumDetail,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_albumDetail == null) {
      return const SizedBox.shrink();
    }

    final detail = _albumDetail!;

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
                      shellController.clearCenterContent();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                
                // Album info section
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Album cover image
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
                          child: _buildAlbumImage(),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Album info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Album',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              detail.albumName,
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
                                Text(
                                  '${detail.totalTracks} tracks${detail.duration > 0 ? ', ${_formatDuration(detail.duration)}' : ''}',
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
                      onTap: _playAlbum,
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

  Widget _buildAlbumImage() {
    final imageUrl = _albumDetail?.imageUrl ?? widget.albumImage;

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
          Icons.album,
          size: 100,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
