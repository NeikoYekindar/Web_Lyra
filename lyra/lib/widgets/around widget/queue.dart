import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/widgets/common/playlist_card.dart';
import 'package:lyra/widgets/common/trackItem.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../providers/auth_provider_v2.dart';
import '../../services/playlist_service.dart';
import '../../services/artist_service.dart';
import '../../models/current_user.dart';
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

// Widget hiển thị danh sách queue - scrollable without scrollbar
class _QueueList extends StatelessWidget {
  const _QueueList();

  @override
  Widget build(BuildContext context) {
    final player = context.watch<MusicPlayerProvider>();
    final queue = player.queue;
    final currentTrack = player.currentTrack;

    // Lấy các track tiếp theo (không bao gồm track hiện tại)
    // Giống logic trong right_sidebar_detail_song
    final upcomingTracks = currentTrack != null
        ? queue.where((t) => t.trackId != currentTrack.trackId).toList()
        : queue;

    if (upcomingTracks.isEmpty) {
      return Center(
        child: Text(
          'No upcoming tracks',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: upcomingTracks.length,
        itemBuilder: (context, index) {
          final track = upcomingTracks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TrackItem(
              title: track.title,
              artist: track.artist,
              image: track.trackImageUrl,
              onTap: () async {
                try {
                  // Play track từ queue
                  await player.setTrack(track);
                  player.play();
                } catch (e) {
                  debugPrint('Error playing track from queue: $e');
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class QueueWid extends StatelessWidget {
  const QueueWid({super.key});
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Queue',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      final shellCtrl = Provider.of<AppShellController?>(
                        context,
                        listen: false,
                      );
                      shellCtrl?.closeQueue();
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Now Playing',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (track != null)
            TrackItem(
              title: track.trackName,
              artist: track.artist,
              image: track.trackImageUrl,
            ),

          const SizedBox(height: 16),
          Text(
            'Next Up',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          Expanded(child: _QueueList()),
        ],
      ),
    );
  }
}
