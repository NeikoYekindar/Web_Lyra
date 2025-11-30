import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/playlist_service.dart';
import 'right_playlist_user_card.dart';
import 'right_sidebar_controller.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RightSidebarController>(
      create: (_) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        final ctrl = RightSidebarController();
        // Initialize fetching of next playlists via provider-backed service
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final token = _resolveAuthToken(auth);
          final service = PlaylistService(baseUrl: auth.baseUrl, authToken: token);
          await ctrl.fetchUserPlaylists(() => service.fetchUserNextPlaylists2());
        });
        return ctrl;
      },
      child: Consumer<RightSidebarController>(
        builder: (context, ctrl, _) {
          return Container(
      width: 360,
      
      margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
      decoration: BoxDecoration(
        color: AppColors.bg_right_sidebar(context),
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
                      color: Theme.of(  context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: ctrl.onMorePressed,
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: ctrl.onClosePressed,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                ],
              

              
              
            ),
            const SizedBox(height: 8),

            MouseRegion(
              onEnter: (_) => ctrl.setNowPlayingHover(true),
              onExit: (_) => ctrl.setNowPlayingHover(false),
              child: Container(
                decoration: BoxDecoration(
                  color: ctrl.nowPlayingHovered ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                // padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                padding: ctrl.nowPlayingHovered
                    ? const EdgeInsets.symmetric(vertical: 6, horizontal: 4)
                    : const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                              ?  Icon(Icons.music_note, color: Theme.of(context).colorScheme.onSurface, size: 30)
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
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                track?.artist ?? 'Nghệ sĩ chưa rõ',
                                style: TextStyle(
                                  color: AppColors.text_min_right_sidebar_detail_song(  context),
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
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
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
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          )
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: ctrl.playlistsUser.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final playlists = ctrl.playlistsUser[index];
                          return PlaylistUserCard(
                            playlists: playlists,
                            onTap: () => ctrl.onPlaylistUserTapped(playlists),
                          );
                        },
                      )
                      
                      
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
}

String? _resolveAuthToken(AuthProvider auth) {
  try {
    final dynamic a = auth as dynamic;
    final token = a.token ?? a.accessToken ?? a.idToken;
    if (token is String && token.isNotEmpty) return token;
  } catch (_) {}
  return null;
}