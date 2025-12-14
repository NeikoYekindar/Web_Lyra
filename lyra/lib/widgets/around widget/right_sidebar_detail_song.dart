import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/playlist_service.dart';
import 'right_playlist_user_card.dart';
import 'right_sidebar_controller.dart';
import '../../services/left_sidebar_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shell/app_shell_controller.dart';

class MockArtistService {
  static Future<Map<String, dynamic>?> getArtistInfo(String artistName) async {
    // Ở đây bạn gọi API backend để lấy ảnh artist và số lượng người nghe
    await Future.delayed(const Duration(seconds: 1));
    return {
      'image': 'assets/images/image 18.png', // Ví dụ ảnh Sơn Tùng
      'listeners': '2,044,507 monthly listeners',
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
          Row(
            children: [
              Text(
                'Now Playing',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
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
              ),
            ],
          ),
          const SizedBox(height: 16),

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh Album
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade800,
                      image: track != null && track.albumArtUrl.isNotEmpty
                          ? (track.albumArtUrl.startsWith('http')
                                ? DecorationImage(
                                    image: NetworkImage(track.albumArtUrl),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: AssetImage(track.albumArtUrl),
                                    fit: BoxFit.cover,
                                  ))
                          : null,
                    ),
                    child: (track == null || track.albumArtUrl.isEmpty)
                        ? const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 60,
                          )
                        : null,
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
                  Row(
                    children: [
                      Text(
                        'Next in queue',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Xử lý mở full queue
                        },
                        child: Text(
                          'Open queue',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,

                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
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
}

class _ArtistInfoCard extends StatelessWidget {
  final String artistName;

  const _ArtistInfoCard({required this.artistName});

  @override
  Widget build(BuildContext context) {
    // Gọi API lấy thông tin chi tiết nghệ sĩ
    return FutureBuilder<Map<String, dynamic>?>(
      future: MockArtistService.getArtistInfo(
        artistName,
      ), // Thay bằng Service thật
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
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
                      artistName,
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
                    Row(
                      children: [
                        Text(
                          listeners ?? 'N/A Listeners',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,

                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                                side: const BorderSide(color: Colors.grey),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                // Thêm dòng này nếu bạn muốn chắc chắn không có bóng đổ khi hover
                                shadowColor: Colors.transparent,
                              ).copyWith(
                                // Logic xử lý riêng cho overlayColor
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>((
                                      Set<MaterialState> states,
                                    ) {
                                      if (states.contains(
                                        MaterialState.hovered,
                                      )) {
                                        return Colors
                                            .transparent; // Trả về màu trong suốt khi hover
                                      }
                                      return null; // Giữ nguyên hiệu ứng mặc định cho các trạng thái khác (như khi bấm)
                                    }),
                              ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),

                        // Bạn có thể thêm đoạn Bio ngắn ở đây
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (more_info != null && more_info!.isNotEmpty)
                      Text(
                        more_info!,
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: LeftSidebarService.getPlaylistsUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final list = snapshot.data ?? const <Map<String, dynamic>>[];

        // TRƯỜNG HỢP LIST RỖNG
        if (list.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Không có bài hát tiếp theo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hàng đợi hiện đang trống',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        final item = list.first;
        final title =
            item['title']?.toString() ?? item['name']?.toString() ?? 'Bài hát';
        final artist =
            item['artist']?.toString() ?? item['owner']?.toString() ?? '';
        final coverUrl =
            item['albumArtUrl']?.toString() ?? item['image']?.toString() ?? '';
        final hasImage = coverUrl.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  image: hasImage
                      ? (coverUrl.startsWith('http')
                            ? DecorationImage(
                                image: NetworkImage(coverUrl),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: AssetImage(coverUrl),
                                fit: BoxFit.cover,
                              ))
                      : null,
                ),
                child: hasImage
                    ? null
                    : const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Nút Play nhỏ bên cạnh nếu cần
              IconButton(
                icon: Icon(
                  Icons.play_arrow_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
