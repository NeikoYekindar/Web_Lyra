import 'package:flutter/material.dart';
import 'right_playlist_user_card_controller.dart';
import 'package:provider/provider.dart';
class PlaylistUserCard extends StatelessWidget {
  final Map<String, dynamic> playlists;
  final VoidCallback? onTap;

  const PlaylistUserCard({
    super.key,
    required this.playlists,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RightPlaylistUserCardController>(
      create: (_) {
        final ctrl = RightPlaylistUserCardController();
        return ctrl;
      },
      child: Consumer<RightPlaylistUserCardController>(
        builder: (context, ctrl, _) => _buildCard(context, ctrl),
      ),
    );
  }

  Widget _buildCard(BuildContext context, RightPlaylistUserCardController ctrl) {
    final title = (playlists['title'] ?? playlists['name'] ?? 'Playlist').toString();
    final subtitle = (playlists['subtitle'] ?? playlists['owner'] ?? '').toString();
    final coverUrl = (playlists['coverUrl'] ?? playlists['image'] ?? '').toString();

    return MouseRegion(
      onEnter: (_) => ctrl.setHovered(true),
      onExit: (_) => ctrl.setHovered(false),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: ctrl.isHovered
                ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _AlbumArt(coverUrl: coverUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ctrl.isHovered ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(0.95),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ctrl.isHovered ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(0.95),
                          fontSize: 12, 
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  final String coverUrl;
  const _AlbumArt({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    final hasImage = coverUrl.isNotEmpty;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade800,
        image: hasImage
            ? (coverUrl.startsWith('http')
                ? DecorationImage(image: NetworkImage(coverUrl), fit: BoxFit.cover)
                : DecorationImage(image: AssetImage(coverUrl), fit: BoxFit.cover))
            : null,
      ),
      child: hasImage
          ? null
          : const Icon(
              Icons.queue_music,
              color: Colors.white,
              size: 22,
            ),
    );
  }
}
