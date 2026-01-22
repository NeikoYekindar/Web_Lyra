import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../core/di/service_locator.dart';
import '../../models/track.dart';
import 'right_playlist_user_card.dart';
import 'right_sidebar_controller.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RightSidebarController>(
      create: (_) {
        final ctrl = RightSidebarController();
        // Fetch user playlists using PlaylistServiceV2
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            final playlists = await serviceLocator.playlistService
                .getUserPlaylists();
            final playlistMaps = playlists
                .map(
                  (p) => {
                    'id': p.id,
                    'name': p.name,
                    'description': p.description ?? '',
                    'cover_url': p.coverUrl ?? '',
                    'owner_name': p.ownerName ?? '',
                    'track_count': p.trackCount ?? 0,
                  },
                )
                .toList();
            ctrl.setPlaylists(playlistMaps);
          } catch (e) {
            print('Error loading playlists in sidebar: $e');
            ctrl.setPlaylists([]);
          }
        });
        return ctrl;
      },
      child: Consumer<RightSidebarController>(
        builder: (context, ctrl, _) {
          return Container(
            width: 360,

            margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    children: [
                      Text(
                        'Now Playing',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: ctrl.onMorePressed,
                        icon: const Icon(Icons.more_horiz, color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: ctrl.onClosePressed,
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  MouseRegion(
                    onEnter: (_) => ctrl.setNowPlayingHover(true),
                    onExit: (_) => ctrl.setNowPlayingHover(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ctrl.nowPlayingHovered
                            ? Theme.of(
                                context,
                              ).colorScheme.surfaceVariant.withOpacity(0.7)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      padding: ctrl.nowPlayingHovered
                          ? const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            )
                          : const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 0,
                            ),
                      child: Consumer<MusicPlayerProvider>(
                        builder: (context, player, _) {
                          final track = player.currentTrack;
                          return Row(
                            children: [
                              // Album art (network or asset fallback)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey.shade800,
                                  child:
                                      track != null &&
                                          track.albumArtUrl.isNotEmpty
                                      ? _buildQueueImage(track.albumArtUrl)
                                      : Icon(
                                          Icons.music_note,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          size: 30,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Song details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      track?.title ?? 'Chưa chọn bài hát',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      track?.artist ?? 'Nghệ sĩ chưa rõ',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,

                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // if (ctrl.nowPlayingHovered)
                              //   IconButton(
                              //     onPressed: () {
                              //       // TODO: implement quick actions (e.g., like/add)
                              //     },
                              //     icon: const Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                              //     tooltip: 'Yêu thích',
                              //   ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Next in Queue Section
                  Consumer<MusicPlayerProvider>(
                    builder: (context, player, _) {
                      // Check if there's a current track first
                      if (player.currentTrack == null || player.queue.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final currentIndex = player.queue.indexWhere(
                        (t) => t.trackId == player.currentTrack!.trackId,
                      );

                      final upcomingTracks =
                          currentIndex >= 0 &&
                              currentIndex < player.queue.length - 1
                          ? player.queue.sublist(currentIndex + 1)
                          : <Track>[];

                      if (upcomingTracks.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Next in Queue',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: player.clearQueue,
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: upcomingTracks.length,
                              itemBuilder: (context, index) {
                                final track = upcomingTracks[index];
                                return _QueueTrackItem(
                                  track: track,
                                  queueIndex: currentIndex + 1 + index,
                                  onTap: () async {
                                    await player.setTrack(track);
                                    player.play();
                                  },
                                  onRemove: () => player.removeFromQueue(
                                    currentIndex + 1 + index,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Next from: Thiên Hạ Nghe Gì',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: ctrl.isLoadingNextPlaylist
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.redPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : ctrl.playlistsUser.isEmpty
                          ? Center(
                              child: Text(
                                'No playlists available',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: ctrl.playlistsUser.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final playlists = ctrl.playlistsUser[index];
                                return PlaylistUserCard(
                                  playlists: playlists,
                                  onTap: () =>
                                      ctrl.onPlaylistUserTapped(playlists),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQueueImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.music_note, color: Colors.white, size: 30);
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/HTH.png',
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.music_note, color: Colors.white, size: 30),
        ),
      );
    }

    final assetPath = imageUrl.startsWith('assets/')
        ? imageUrl
        : 'assets/$imageUrl';
    return Image.asset(
      assetPath,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/HTH.png',
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.music_note, color: Colors.white, size: 30),
      ),
    );
  }
}

class _QueueTrackItem extends StatefulWidget {
  final Track track;
  final int queueIndex;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _QueueTrackItem({
    required this.track,
    required this.queueIndex,
    required this.onTap,
    required this.onRemove,
  });

  @override
  State<_QueueTrackItem> createState() => _QueueTrackItemState();
}

class _QueueTrackItemState extends State<_QueueTrackItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: _isHovered
                ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              // Album art
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey.shade800,
                  child: widget.track.albumArtUrl.isNotEmpty
                      ? Image.network(
                          widget.track.albumArtUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Track info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.track.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.track.artist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Remove button (shown on hover)
              if (_isHovered)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Remove from queue',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
