import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/widgets/common/header_info_section.dart';
import 'package:lyra/widgets/common/silver_app_bar.dart';
import 'package:lyra/widgets/common/playlist_card.dart';
import 'package:lyra/widgets/common/media_card.dart';
import 'package:lyra/widgets/common/trackItem.dart';
import 'package:lyra/models/current_user.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/services/playlist_service_v2.dart';
import 'package:lyra/models/track.dart';
import 'package:lyra/models/artist.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../shell/app_shell_controller.dart';

class ArtistPage extends StatefulWidget {
  final Artist artist;
  const ArtistPage({super.key, required this.artist});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final ValueNotifier<double> scrollOffset = ValueNotifier(0);
  List<Playlist>? _artistPlaylists;
  bool _isLoadingPlaylists = true;
  List<Track>? _artistTracks;
  bool _isLoadingTracks = true;

  @override
  void initState() {
    super.initState();

    //_loadArtistTracks();
  }

  Future<void> _loadArtistPlaylists() async {
    try {
      final playlists = await serviceLocator.playlistService.getUserPlaylists();
      if (mounted) {
        setState(() {
          _artistPlaylists = playlists;
          _isLoadingPlaylists = false;
        });
      }
    } catch (e) {
      print('Error loading user playlists: $e');
      if (mounted) {
        setState(() {
          _artistPlaylists = [];
          _isLoadingPlaylists = false;
        });
      }
    }
  }

  Future<void> _loadArtistTracks() async {
    try {
      print('Loading tracks for artist: ${widget.artist.artistId}');
      final tracks = await serviceLocator.musicService.getTracksByArtist(
        widget.artist.artistId,
        limit: 20,
      );
      if (mounted) {
        setState(() {
          _artistTracks = tracks;
          _isLoadingTracks = false;
        });
        print('Loaded ${tracks.length} tracks for artist');
      }
    } catch (e) {
      print('Error loading artist tracks: $e');
      if (mounted) {
        setState(() {
          _artistTracks = [];
          _isLoadingTracks = false;
        });
      }
    }
  }

  void _onTrackTapped(Track track) async {
    try {
      final musicPlayerProvider = Provider.of<MusicPlayerProvider>(
        context,
        listen: false,
      );
      final shellController = Provider.of<AppShellController>(
        context,
        listen: false,
      );

      // Load track with artist tracks as queue
      await musicPlayerProvider.setTrack(track, queue: _artistTracks ?? []);
      musicPlayerProvider.play();

      // Show player if not shown
      if (!shellController.isPlayerMaximized) {
        shellController.toggleMaximizePlayer();
      }
    } catch (e) {
      print('Error playing track: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlists = _artistPlaylists ?? [];
    final tracks = _artistTracks ?? [];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notif) {
          if (notif.metrics.axis == Axis.vertical) {
            scrollOffset.value = notif.metrics.pixels;
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height:
                    240, // Set explicit height for Stack-based HeaderInfoSection
                child: HeaderInfoSection(
                  imageSize: 180,
                  imageShape: BoxShape.circle,
                  image:
                      widget.artist.imageUrl != null &&
                          widget.artist.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.artist.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/images/avatar.png',
                                fit: BoxFit.cover,
                              ),
                        )
                      : Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                        ),
                  type: Text(
                    "Artist",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                  title: Text(
                    widget.artist.nickname,
                    style: GoogleFonts.inter(
                      fontSize: 60,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        "${widget.artist.totalFollowers} Followers",
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "  •  ",
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "${widget.artist.totalStreams} Streams",
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () {
                        if (tracks.isNotEmpty) {
                          _onTrackTapped(tracks[0]);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Follow",
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    height: 50,
                    child: IconButton(
                      icon: Icon(Icons.shuffle),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            //Playlists Section - only show if there are playlists
            if (_isLoadingTracks || (!tracks.isNotEmpty)) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Popular tracks",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _isLoadingTracks
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Loading tracks...',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          height: 260,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                              },
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              primary: false,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: tracks.length,
                              itemBuilder: (context, i) => Container(
                                width: 180,
                                margin: const EdgeInsets.only(right: 16),
                                child: MediaCard(
                                  item: tracks[i],
                                  onTap: () => _onTrackTapped(tracks[i]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
            // Following section is hidden until backend API is available
            // Top Tracks / Recently Played section
            if (_isLoadingTracks ||
                (_artistTracks != null && _artistTracks!.isNotEmpty)) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)?.recentlyPlayed ??
                        'Recently Played',
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (_isLoadingTracks)
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Loading tracks...',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final track = _artistTracks![index];
                    return TrackItem(
                      index: index + 1,
                      title: track.title,
                      artist: track.artist,
                      albumArtist: 'Album',
                      duration: _formatDuration(track.durationMs),
                      image: track.albumArtUrl,
                    );
                  }, childCount: _artistTracks!.length),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(int durationMs) {
    final seconds = durationMs ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
