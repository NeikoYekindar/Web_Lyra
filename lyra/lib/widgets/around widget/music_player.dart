import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/providers/music_player_provider.dart';
import '/models/track.dart';
import 'package:lyra/shell/app_shell_controller.dart';
import 'package:lyra/widgets/around%20widget/music_player_controller.dart';
import 'package:lyra/shell/app_nav.dart';
import 'package:lyra/shell/app_routes.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final shell = context.watch<AppShellController>();
    final ctrl = MusicPlayerController();
    return Container(
      height: 86,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        image: track != null && track.albumArtUrl.isNotEmpty
                            ? DecorationImage(
                                image: track.albumArtUrl.startsWith('http')
                                    ? NetworkImage(track.albumArtUrl)
                                    : AssetImage(track.albumArtUrl)
                                          as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: track == null || track.albumArtUrl.isEmpty
                          ? Icon(
                              Icons.music_note,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              size: 30,
                            )
                          : null,
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
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            track?.artist ?? "Nghệ sĩ chưa rõ",
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
                            _icon(context, "assets/icons/shuffle.svg"),
                            const SizedBox(width: 20),
                            _icon(
                              context,
                              "assets/icons/back_music_player.svg",
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
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
                            _icon(
                              context,
                              "assets/icons/next_music_player.svg",
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
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 5,
                                  ),
                                  thumbColor: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  overlayShape: SliderComponentShape.noOverlay,
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
                // Now-playing detail toggle (colors when active)
                NowPlayingToggle(ctrl: ctrl),
                const SizedBox(width: 10),

                // Lyrics button
                Builder(
                  builder: (ctx) {
                    final shellLocal = ctx.watch<AppShellController>();
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
                              : Theme.of(ctx).colorScheme.onSurfaceVariant,
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
                            final player = ctx.watch<MusicPlayerProvider>();
                            final muted = player.isMuted;
                            final vol = player.volume;

                            String assetPath;
                            if (muted || vol <= 0) {
                              assetPath = 'assets/icons/muted.svg';
                            } else if (vol < 0.5) {
                              assetPath = 'assets/icons/Smallvolume.svg';
                            } else {
                              assetPath = 'assets/icons/Fullvolume.svg';
                            }

                            return IconButton(
                              onPressed: () =>
                                  ctx.read<MusicPlayerProvider>().toggleMute(),
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
                                          ? Theme.of(
                                              ctx,
                                            ).colorScheme.onSurfaceVariant
                                          : Theme.of(ctx).colorScheme.onSurface,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
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
                              overlayShape: SliderComponentShape.noOverlay,
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
                // Maximize player button — use AppShellController (dashboard logic moved)
                IconButton(
                  onPressed: () {
                    final shellCtrl = Provider.of<AppShellController?>(
                      context,
                      listen: false,
                    );
                    if (shellCtrl != null) {
                      shellCtrl.toggleMaximizePlayer();
                    }
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/maximise-02.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurfaceVariant,
                      BlendMode.srcIn,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(BuildContext context, String path) {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        path,
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

  String _fmt(int ms) {
    final total = (ms / 1000).floor();
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
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
