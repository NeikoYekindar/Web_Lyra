import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/widgets/common/header_info_section.dart';
import 'package:lyra/widgets/common/silver_app_bar.dart';
import 'package:lyra/widgets/common/playlist_card.dart';
import 'package:lyra/widgets/common/trackItem.dart';
import 'package:lyra/models/current_user.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/services/playlist_service_v2.dart';
import 'package:lyra/models/track.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ValueNotifier<double> scrollOffset = ValueNotifier(0);
  List<Playlist>? _userPlaylists;
  bool _isLoadingPlaylists = true;
  List<Track>? _recentTracks;
  bool _isLoadingTracks = true;

  @override
  void initState() {
    super.initState();
    //_loadUserPlaylists();
    _loadRecentTracks();
  }

  Future<void> _loadUserPlaylists() async {
    try {
      final playlists = await serviceLocator.playlistService.getUserPlaylists();
      if (mounted) {
        setState(() {
          _userPlaylists = playlists;
          _isLoadingPlaylists = false;
        });
      }
    } catch (e) {
      print('Error loading user playlists: $e');
      if (mounted) {
        setState(() {
          _userPlaylists = [];
          _isLoadingPlaylists = false;
        });
      }
    }
  }

  Future<void> _loadRecentTracks() async {
    try {
      final tracks = await serviceLocator.musicService.getRecentTracks();
      if (mounted) {
        setState(() {
          _recentTracks = tracks;
          _isLoadingTracks = false;
        });
      }
    } catch (e) {
      print('Error loading recent tracks: $e');
      if (mounted) {
        setState(() {
          _recentTracks = [];
          _isLoadingTracks = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CurrentUser.instance.userNotifier,
      builder: (context, user, _) {
        // Convert API playlists to PlaylistItems
        final playlists =
            _userPlaylists
                ?.map(
                  (playlist) => PlaylistItem(
                    title: playlist.name,
                    author: playlist.ownerName ?? 'Unknown',
                    coverUrl: playlist.coverUrl ?? '',
                    songCount: playlist.trackCount ?? 0,
                    duration: '${playlist.trackCount ?? 0} tracks',
                  ),
                )
                .toList() ??
            [];
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
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: CustomScrollView(
                slivers: [
                  ProfileSliverAppBar(offset: scrollOffset),
                  // Your Playlists Section - only show if there are playlists
                  if (_isLoadingPlaylists || (playlists.isNotEmpty)) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "Your Playlists",
                          style: GoogleFonts.inter(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _isLoadingPlaylists
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SizedBox(
                                height: 260,
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(
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
                                    itemCount: playlists.length,
                                    itemBuilder: (context, i) => Container(
                                      width: 180,
                                      margin: const EdgeInsets.only(right: 16),
                                      child: PlaylistCard(item: playlists[i]),
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
                      (_recentTracks != null && _recentTracks!.isNotEmpty)) ...[
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
                      const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final track = _recentTracks![index];
                          return TrackItem(
                            index: index + 1,
                            title: track.title,
                            artist: track.artist,
                            albumArtist: 'Songs',
                            duration: _formatDuration(track.durationMs),
                            image: track.albumArtUrl,
                          );
                        }, childCount: _recentTracks!.length),
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(int durationMs) {
    final seconds = durationMs ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
