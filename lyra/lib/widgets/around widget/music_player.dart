import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '/providers/music_player_provider.dart';
import '/providers/track_like_provider.dart';
import '/models/track.dart';
import 'package:lyra/shell/app_shell_controller.dart';
import 'package:lyra/widgets/around%20widget/music_player_controller.dart';
import 'package:lyra/shell/app_nav.dart';
import 'package:lyra/shell/app_routes.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  void initState() {
    super.initState();
    // Check like status when widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final player = Provider.of<MusicPlayerProvider>(context, listen: false);
      final likeProvider = Provider.of<TrackLikeProvider>(
        context,
        listen: false,
      );
      if (player.currentTrack != null) {
        likeProvider.checkLikeStatus(player.currentTrack!.trackId);
      }
    });
  }

  Future<void> _toggleLike(String trackId) async {
    final likeProvider = Provider.of<TrackLikeProvider>(context, listen: false);
    await likeProvider.toggleLike(trackId);
  }

  @override
  Widget build(BuildContext context) {
    final shell = context.watch<AppShellController>();
    final ctrl = MusicPlayerController();
    // Hide player completely when no track is loaded
    return Consumer<MusicPlayerProvider>(
      builder: (context, player, _) {
        if (player.currentTrack == null) {
          return const SizedBox.shrink(); // Hide player completely
        }

        // Use LayoutBuilder so the player adapts to available vertical space
        return LayoutBuilder(
          builder: (context, constraints) {
            final availableH = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : double.infinity;
            final height = availableH.isFinite ? min(86.0, availableH) : 86.0;

            return SizedBox(
              height: height,
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // ============================
                    // LEFT — TRACK INFO
                    // ============================
                    Expanded(
                      flex: 1,
                      child: Consumer<MusicPlayerProvider>(
                        builder: (context, player, _) {
                          final Track? track = player.currentTrack;

                          return Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                                  child:
                                      track == null || track.albumArtUrl.isEmpty
                                      ? Icon(
                                          Icons.music_note,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondaryContainer,
                                          size: 30,
                                        )
                                      : _buildPlayerImage(
                                          track.albumArtUrl,
                                          context,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      track?.title ?? "Chưa chọn bài hát",
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
                                      track?.artistObj?.nickname ??
                                          "Nghệ sĩ chưa rõ",
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
                            ],
                          );
                        },
                      ),
                    ),

                    // ============================
                    // CENTER — CONTROLS + PROGRESS
                    // ============================
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 72,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --- PLAYBACK CONTROLS ---
                              Consumer<MusicPlayerProvider>(
                                builder: (context, player, _) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _icon(
                                        context,
                                        "assets/icons/shuffle.svg",
                                      ),
                                      const SizedBox(width: 20),
                                      _HoverIconButton(
                                        iconPath:
                                            "assets/icons/back_music_player.svg",
                                        onTap: () => context
                                            .read<MusicPlayerProvider>()
                                            .playPrevious(),
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            player.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                          onPressed: player.togglePlay,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      _HoverIconButton(
                                        iconPath:
                                            "assets/icons/next_music_player.svg",
                                        onTap: () => context
                                            .read<MusicPlayerProvider>()
                                            .playNext(),
                                      ),
                                      const SizedBox(width: 20),
                                      _icon(context, "assets/icons/repeat.svg"),
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: 10),

                              // --- PROGRESS BAR ---
                              Consumer<MusicPlayerProvider>(
                                builder: (context, player, _) {
                                  final duration = player.durationMs;
                                  final position = player.positionMs;
                                  final progress = duration > 0
                                      ? (position / duration).clamp(0.0, 1.0)
                                      : 0.0;

                                  return Row(
                                    children: [
                                      Text(
                                        _fmt(position),
                                        style: GoogleFonts.inter(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                trackHeight: 3,
                                                thumbShape:
                                                    const RoundSliderThumbShape(
                                                      enabledThumbRadius: 5,
                                                    ),
                                                thumbColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                overlayShape:
                                                    SliderComponentShape
                                                        .noOverlay,
                                                activeTrackColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                inactiveTrackColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                          child: Slider(
                                            value: progress,
                                            onChanged: duration == 0
                                                ? null
                                                : player.setProgressFraction,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _fmt(duration),
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ============================
                    // RIGHT — EXTRA BUTTONS
                    // ============================
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<TrackLikeProvider>(
                            builder: (context, likeProvider, child) {
                              final track = player.currentTrack;
                              if (track == null) return const SizedBox.shrink();

                              final isLiked = likeProvider.isLiked(
                                track.trackId,
                              );
                              final isLoading = likeProvider.isLoading(
                                track.trackId,
                              );

                              return IconButton(
                                icon: isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      )
                                    : Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                color: isLiked
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                onPressed: isLoading
                                    ? null
                                    : () => _toggleLike(track.trackId),
                              );
                            },
                          ),
                          // Now-playing detail toggle (colors when active)
                          NowPlayingToggle(ctrl: ctrl),
                          const SizedBox(width: 10),

                          // Lyrics button
                          Builder(
                            builder: (ctx) {
                              final shellLocal = ctx
                                  .watch<AppShellController>();
                              return IconButton(
                                onPressed: () {
                                  ctx.read<AppShellController>().toggleLyrics();
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/lyrics.svg',
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                    shellLocal.showLyrics
                                        ? Theme.of(ctx).colorScheme.primary
                                        : Theme.of(
                                            ctx,
                                          ).colorScheme.onSurfaceVariant,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              );
                            },
                          ),

                          const SizedBox(width: 10),
                          _icon(context, "assets/icons/queue.svg"),
                          const SizedBox(width: 10),

                          // Volume control
                          Consumer<MusicPlayerProvider>(
                            builder: (context, player, _) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Builder(
                                    builder: (ctx) {
                                      final player = ctx
                                          .watch<MusicPlayerProvider>();
                                      final muted = player.isMuted;
                                      final vol = player.volume;

                                      String assetPath;
                                      if (muted || vol <= 0) {
                                        assetPath = 'assets/icons/muted.svg';
                                      } else if (vol < 0.5) {
                                        assetPath =
                                            'assets/icons/Smallvolume.svg';
                                      } else {
                                        assetPath =
                                            'assets/icons/Fullvolume.svg';
                                      }

                                      return IconButton(
                                        onPressed: () => ctx
                                            .read<MusicPlayerProvider>()
                                            .toggleMute(),
                                        icon: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              assetPath,
                                              width: 20,
                                              height: 20,
                                              colorFilter: ColorFilter.mode(
                                                muted
                                                    ? Theme.of(ctx)
                                                          .colorScheme
                                                          .onSurfaceVariant
                                                    : Theme.of(
                                                        ctx,
                                                      ).colorScheme.onSurface,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints:
                                            const BoxConstraints.tightFor(
                                              width: 28,
                                              height: 28,
                                            ),
                                      );
                                    },
                                  ),

                                  const SizedBox(width: 4),

                                  // 🎚 Volume slider
                                  SizedBox(
                                    width: 100,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 3,
                                        thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6,
                                        ),
                                        thumbColor: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        inactiveTrackColor: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                        activeTrackColor: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        overlayShape:
                                            SliderComponentShape.noOverlay,
                                      ),
                                      child: Slider(
                                        value: player.volume,
                                        min: 0,
                                        max: 1,
                                        onChanged: player.setVolume,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(width: 10),
                          // Maximize player button — use AppShellController
                          Builder(
                            builder: (ctx) {
                              return IconButton(
                                onPressed: () {
                                  ctx
                                      .read<AppShellController>()
                                      .toggleMaximizePlayer();
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/maximise-02.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlayerImage(String imageUrl, BuildContext context) {
    if (imageUrl.isEmpty) {
      return Icon(
        Icons.music_note,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 30,
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: 55,
        height: 55,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/HTH.png',
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.music_note,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 30,
          ),
        ),
      );
    }

    final assetPath = imageUrl.startsWith('assets/')
        ? imageUrl
        : 'assets/$imageUrl';
    return Image.asset(
      assetPath,
      width: 55,
      height: 55,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/HTH.png',
        width: 55,
        height: 55,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.music_note,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          size: 30,
        ),
      ),
    );
  }

  Widget _icon(BuildContext context, String path) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Center(
        child: SvgPicture.asset(
          path,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurfaceVariant,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  String _fmt(int ms) {
    final total = (ms / 1000).floor();
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _HoverIconButton extends StatefulWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _HoverIconButton({required this.iconPath, required this.onTap});

  @override
  State<_HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: AnimatedOpacity(
            opacity: _isHovered ? 1.0 : 0.7,
            duration: const Duration(milliseconds: 150),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: SvgPicture.asset(
                  widget.iconPath,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurfaceVariant,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NowPlayingToggle extends StatefulWidget {
  final MusicPlayerController ctrl;
  const NowPlayingToggle({required this.ctrl, super.key});

  @override
  State<NowPlayingToggle> createState() => _NowPlayingToggleState();
}

class _NowPlayingToggleState extends State<NowPlayingToggle> {
  @override
  Widget build(BuildContext context) {
    try {
      final shellCtrl = context.watch<AppShellController?>();
      final bool isActive = shellCtrl?.isRightSidebarDetail ?? false;

      return IconButton(
        onPressed: () {
          if (shellCtrl != null) {
            widget.ctrl.toggleNowPlayingDetail(context);
          }
        },
        icon: SvgPicture.asset(
          'assets/icons/now playing view.svg',
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            BlendMode.srcIn,
          ),
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    } catch (_) {
      // Provider not available; show disabled icon
      return IconButton(
        onPressed: null,
        icon: SvgPicture.asset(
          'assets/icons/now playing view.svg',
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurfaceVariant,
            BlendMode.srcIn,
          ),
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }
  }
}
