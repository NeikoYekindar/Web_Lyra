import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../providers/auth_provider_v2.dart';
import '../../services/playlist_service.dart';
import 'right_playlist_user_card.dart';
import 'right_sidebar_controller.dart';
import '../../services/left_sidebar_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shell/app_shell_controller.dart';
import 'package:lyra/models/track.dart';

class MockArtistService {
  static Future<Map<String, dynamic>?> getArtistInfo(String artistName) async {
    // Ở đây bạn gọi API backend để lấy ảnh artist và số lượng người nghe
    await Future.delayed(const Duration(seconds: 1));
    return {
      'image': 'assets/images/image 18.png', // Ví dụ ảnh Sơn Tùng
      'listeners': '2,345,567 monthly listeners',
      'bio': 'Nguyễn Thanh Tùng, born in 1994...',
      'more_info':
          'Nguyễn Thanh Tùng, born in 1994, known professionally as Sơn Tùng M-TP, is a Vietnamese singer, songwriter, producer, and actor. He is not only known as one of the ...',
    };
  }
}

class RightSidebarDetailSong extends StatelessWidget {
  const RightSidebarDetailSong({super.key});
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<MusicPlayerProvider>(context);
    final track = player.currentTrack;

    return Container(
      // Let parent provide width/margin so this matches other panels
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Hide close button when too narrow
              final showButton = constraints.maxWidth > 50;
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      'Now Playing',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showButton)
                    IconButton(
                      onPressed: () {
                        final shell = Provider.of<AppShellController?>(
                          context,
                          listen: false,
                        );
                        if (shell != null) {
                          shell.closeNowPlayingDetail();
                        } else {
                          // fallback: if controller isn't found just pop
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh Album
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey.shade800,
                      child: track == null || track.albumArtUrl.isEmpty
                          ? const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 60,
                            )
                          : _buildSidebarImage(track.albumArtUrl),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tên bài hát
                  Text(
                    track?.title ?? 'No Track Playing',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Tên nghệ sĩ
                  Text(
                    track?.artist ?? 'Unknown Artist',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),

                  // Thẻ thông tin nghệ sĩ
                  if (track != null) _ArtistInfoCard(artistName: track.artist),
                  const SizedBox(height: 24),

                  // Header Next Queue
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Hide button when width is too narrow
                      final showButton = constraints.maxWidth > 120;
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Next in queue',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (showButton)
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Open',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // List Queue
                  // LƯU Ý QUAN TRỌNG: Không dùng Expanded hay SingleChildScrollView ở đây nữa
                  // vì nó đã nằm trong SingleChildScrollView cha rồi.
                  const _NextQueueSection(),

                  // Khoảng đệm dưới cùng để không bị sát mép khi cuộn
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.music_note, color: Colors.white, size: 60);
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/HTH.png',
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.music_note, color: Colors.white, size: 60),
        ),
      );
    }

    final assetPath = imageUrl.startsWith('assets/')
        ? imageUrl
        : 'assets/$imageUrl';
    return Image.asset(
      assetPath,
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/HTH.png',
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.music_note, color: Colors.white, size: 60),
      ),
    );
  }
}

class _ArtistInfoCard extends StatefulWidget {
  final String artistName;
  const _ArtistInfoCard({required this.artistName});

  @override
  State<_ArtistInfoCard> createState() => _ArtistInfoCardState();
}

class _ArtistInfoCardState extends State<_ArtistInfoCard> {
  late Future<Map<String, dynamic>?> _future;
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _future = MockArtistService.getArtistInfo(widget.artistName);
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isFollowing = !_isFollowing;
      _isLoading = false;
    });

    // TODO: Call actual API to follow/unfollow artist
    // try {
    //   if (_isFollowing) {
    //     await MusicServiceV2().followArtist(widget.artistName);
    //   } else {
    //     await MusicServiceV2().unfollowArtist(widget.artistName);
    //   }
    // } catch (e) {
    //   debugPrint('Error toggling follow: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Gọi API lấy thông tin chi tiết nghệ sĩ
    return FutureBuilder<Map<String, dynamic>?>(
      future: _future, // Thay bằng Service thật
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        }

        final data = snapshot.data;
        // Nếu không có dữ liệu hoặc lỗi, ẩn phần này hoặc hiện placeholder
        if (data == null) return const SizedBox.shrink();
        final more_info = data['more_info'] ?? '';
        final imageUrl = data['image'];
        final listeners = data['listeners'];
        // final bio = data['bio']; // Có thể hiển thị thêm bio nếu muốn

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias, // Để ảnh bo góc theo container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh Cover Nghệ sĩ
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade800,
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/HTH.png',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: Colors.white54,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                  // Gradient mờ ở dưới ảnh để chữ dễ đọc hơn
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tên nghệ sĩ đè lên ảnh
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      widget.artistName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                      ),
                    ),
                  ),
                ],
              ),

              // Phần thông tin bên dưới ảnh
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Căn lề trái cho toàn bộ nội dung
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      runSpacing: 8,
                      children: [
                        Text(
                          listeners ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _toggleFollow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFollowing
                                  ? Theme.of(context).colorScheme.surfaceVariant
                                  : Theme.of(context).colorScheme.primary,
                              foregroundColor: _isFollowing
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant
                                  : Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  )
                                : Text(_isFollowing ? 'Following' : 'Follow'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    if (more_info != null && more_info.isNotEmpty)
                      Text(
                        more_info,
                        maxLines: 2, // Giới hạn 2 dòng để không bị dài quá
                        overflow:
                            TextOverflow.ellipsis, // Hiện dấu ... nếu dài quá
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,

                          fontSize: 12,
                        ),
                      ),

                    // Nút Follow
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NextQueueSection extends StatelessWidget {
  const _NextQueueSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
      builder: (context, player, _) {
        final queue = player.queue;
        final currentTrack = player.currentTrack;

        // Filter out current track to show only "next" tracks
        final nextTracks = currentTrack != null
            ? queue.where((t) => t.trackId != currentTrack.trackId).toList()
            : queue;

        // TRƯỜNG HỢP LIST RỖNG
        if (nextTracks.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade800,
                  ),
                  child: const Icon(
                    Icons.queue_music,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'No next track',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Queue is empty',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final track = nextTracks.first;
        final title = track.trackName;
        final artist = track.artist;
        final coverUrl = track.trackImageUrl;
        final hasImage = coverUrl.isNotEmpty;

        return LayoutBuilder(
          builder: (context, constraints) {
            // Hide content if too narrow to display anything meaningful
            if (constraints.maxWidth < 60) {
              return const SizedBox.shrink();
            }

            // Scale down for very narrow widths
            final isNarrow = constraints.maxWidth < 150;
            final imageSize = isNarrow ? 32.0 : 48.0;
            final spacing = isNarrow ? 4.0 : 8.0;
            final padding = isNarrow ? 4.0 : 8.0;
            final fontSize = isNarrow ? 12.0 : 15.0;
            final artistFontSize = isNarrow ? 10.0 : 13.0;
            final buttonSize = isNarrow ? 28.0 : 36.0;
            final iconSize = isNarrow ? 18.0 : 20.0;

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(padding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: hasImage
                          ? _buildQueueImage(coverUrl, imageSize)
                          : Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: imageSize * 0.5,
                            ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isNarrow) const SizedBox(height: 4),
                        Text(
                          artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: artistFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tightFor(
                      width: buttonSize,
                      height: buttonSize,
                    ),
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: iconSize,
                    ),
                    onPressed: () async {
                      try {
                        final existing = player.queue;
                        final List<Track> rotated = [
                          track,
                          ...existing.where((t) => t.trackId != track.trackId),
                        ];
                        await player.setTrack(track, queue: rotated);
                        player.play();
                      } catch (e) {
                        debugPrint('Error playing next track directly: $e');
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQueueImage(String imageUrl, [double size = 48]) {
    if (imageUrl.isEmpty) {
      return Icon(Icons.music_note, color: Colors.white, size: size * 0.5);
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/HTH.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.music_note, color: Colors.white, size: size * 0.5),
        ),
      );
    }

    final assetPath = imageUrl.startsWith('assets/')
        ? imageUrl
        : 'assets/$imageUrl';
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/HTH.png',
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.music_note, color: Colors.white, size: 24),
      ),
    );
  }
}
