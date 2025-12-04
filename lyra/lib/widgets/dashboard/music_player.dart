import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/music_player_provider.dart';
import 'music_player_controller.dart';
import '/screens/dashboard/dashboard_controller.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = MusicPlayerController();
    return Container(
      height: 90,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Left side - dynamic current track info
          Expanded(
            flex: 1,
            child: Consumer<MusicPlayerProvider>(
              builder: (context, player, _) {
                final track = player.currentTrack;
                return Row(
                  children: [
                    // Album art (network or asset fallback)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.shade800,
                        image: track != null && track.albumArtUrl.isNotEmpty
                            ? DecorationImage(
                                image: track.albumArtUrl.startsWith('http')
                                    ? NetworkImage(track.albumArtUrl)
                                    : AssetImage(track.albumArtUrl) as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: track == null || track.albumArtUrl.isEmpty
                          ? const Icon(Icons.music_note, color: Colors.white, size: 30)
                          : null,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            track?.artist ?? 'Nghệ sĩ chưa rõ',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     // Example favorite action
                    //   },
                    //   icon: const Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                    //   tooltip: 'Yêu thích',
                    // ),
                  ],
                );
              },
            ),
          ),
          // Center - Player controls + progress
          Container(
            width: 600,
            // Remove fixed height & bottom margin to avoid vertical overflow.
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<MusicPlayerProvider>(
                  builder: (context, player, _) {
                    final isPlaying = player.isPlaying;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/shuffle.svg',
                            width: 21,
                            height: 21,
                            // If you want to recolor the SVG to grey regardless of original color:
                            colorFilter: const ColorFilter.mode( const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                        ),
                        const SizedBox(width: 25),
                        
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/back_music_player.svg',
                            width: 20,
                            height: 20,
                            // If you want to recolor the SVG to white regardless of original color:
                            colorFilter: const ColorFilter.mode(const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                        ),
                        const SizedBox(width: 25),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(color: const Color(0xFFE62429), shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () => player.togglePlay(),
                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: const Color.fromARGB(255, 255, 255, 255), size: 24),
                            padding: EdgeInsets.zero,
                            // tooltip: isPlaying ? 'Tạm dừng' : 'Phát',
                          ),  
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/next_music_player.svg',
                            width: 20,
                            height: 20,
                            // If you want to recolor the SVG to white regardless of original color:
                            colorFilter: const ColorFilter.mode(const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/repeat.svg',
                            width: 19,
                            height: 19,
                            // If you want to recolor the SVG to white regardless of original color:
                            colorFilter: const ColorFilter.mode(const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 4),
                // Progress bar
                Container(
                  height: 20,
                  child: Consumer<MusicPlayerProvider>(
                  builder: (context, player, _) {
                    final track = player.currentTrack;
                    final durationMs = track?.durationMs ?? 0;
                    final positionMs = track?.positionMs ?? 0;
                    String format(int ms) {
                      final totalSeconds = (ms / 1000).floor();
                      final m = (totalSeconds ~/ 60).toString().padLeft(1, '0');
                      final s = (totalSeconds % 60).toString().padLeft(2, '0');
                      return '$m:$s';
                    }
                    return Row(
                      children: [
                        Text(format(positionMs), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade700,
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: track == null ? 0 : track.progress.clamp(0, 1),
                              onChanged: track == null
                                  ? null
                                  : (value) {
                                      player.setProgressFraction(value);
                                    },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(format(durationMs), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    );
                  },
                ),
                ),
                
                
              ],
            ),
          ),

          // Right side - Additional controls
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              
              children: [
                Consumer<DashboardController>(
                    builder: (context, dashboard, _) {
                      // Kiểm tra trạng thái để đổi màu icon
                      final bool isActive = dashboard.isRightSidebarDetail;
                      
                      return IconButton(
                        // Gọi hàm toggle thay vì chỉ open
                        onPressed: () => ctrl.toggleNowPlayingDetail(context),
                        icon: SvgPicture.asset(
                          'assets/icons/now playing view.svg',
                          width: 18,
                          height: 18,
                          // Logic đổi màu: 
                          // Nếu isActive = true (đang mở) -> Màu chủ đạo (ví dụ Đỏ hoặc Trắng sáng)
                          // Nếu isActive = false (đang đóng) -> Màu xám (B3B3B3)
                          colorFilter: ColorFilter.mode(
                            isActive 
                              ? const Color(0xFFE62429) // Hoặc Colors.white tuỳ design của bạn khi active
                              : const Color(0xFFB3B3B3), 
                            BlendMode.srcIn
                          ),
                        ),
                        tooltip: isActive ? 'Đóng chi tiết' : 'Xem chi tiết',
                      );
                    },
                  ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                            'assets/icons/lyrics.svg',
                            width: 18,
                            height: 18,
                            // If you want to recolor the SVG to white regardless of original color:
                            colorFilter: const ColorFilter.mode(const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                            'assets/icons/queue.svg',
                            width: 18,
                            height: 18,
                            // If you want to recolor the SVG to white regardless of original color:
                            colorFilter: const ColorFilter.mode(const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                            'assets/icons/Volume.svg',
                            width: 18,
                            height: 18,
                            // If you want to recolor the SVG to white regardless of original color:
                            colorFilter: const ColorFilter.mode(const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                ),
                
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.queue_music,
                //     color: Colors.grey,
                //     size: 20,
                //   ),
                // ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.devices,
                //     color: Colors.grey,
                //     size: 20,
                //   ),
                // ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.volume_up,
                //     color: Colors.grey,
                //     size: 20,
                //   ),
                // ),
                SizedBox(
                  width: 100,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade700,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: 0.7,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.fullscreen,
                //     color: Colors.grey,
                //     size: 20,
                //   ),
                // ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                            'assets/icons/maximise-02.svg',
                            width: 18,
                            height: 18,
                            // If you want to recolor the SVG to white regardless of original color:
                            colorFilter: const ColorFilter.mode(const Color(0xFFB3B3B3), BlendMode.srcIn),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}