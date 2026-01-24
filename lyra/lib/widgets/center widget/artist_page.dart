import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/services/music_service_v2.dart' as music_service;
import 'package:lyra/widgets/common/header_info_section.dart';
import 'package:lyra/widgets/common/playlist_card.dart';
import 'package:lyra/widgets/common/trackItem.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/services/playlist_service_v2.dart';
import 'package:lyra/core/config/api_config.dart';

import 'package:lyra/models/track.dart';
import 'package:lyra/models/artist.dart';
import 'package:lyra/models/album.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../providers/artist_follow_provider.dart';
import '../../shell/app_shell_controller.dart';
import 'package:lyra/models/search_response.dart';

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
  List<Album>? _artistAlbums;
  bool _isLoadingAlbums = true;
  @override
  void initState() {
    super.initState();
    _loadArtistData();
    // Check follow status using provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArtistFollowProvider>(
        context,
        listen: false,
      ).checkFollowStatus(widget.artist.artistId);
    });
  }

  Future<void> _loadArtistData() async {
    // Load all artist data in parallel
    await Future.wait([
      _loadArtistTracks(),
      _loadArtistPlaylists(),
      _loadArtistAlbum(),
    ]);
  }

  Future<void> _loadArtistPlaylists() async {
    try {
      print('Loading playlists for artist: ${widget.artist.artistId}');
      final playlists = await serviceLocator.artistService.getArtistPlaylists(
        artistId: widget.artist.artistId,
      );
      if (mounted) {
        setState(() {
          _artistPlaylists = playlists;
          _isLoadingPlaylists = false;
        });
        print('Loaded ${playlists.length} playlists for artist');
      }
    } catch (e) {
      print('Error loading artist playlists: $e');
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
      final tracks = await serviceLocator.artistService.getArtistTracks(
        artistId: widget.artist.artistId,
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

  Future<void> _loadArtistAlbum() async {
    try {
      print('Loading albums for artist: ${widget.artist.artistId}');
      final albums = await serviceLocator.artistService.getArtistAlbums(
        artistId: widget.artist.artistId,
      );
      if (mounted) {
        setState(() {
          _artistAlbums = albums;
          _isLoadingAlbums = false;
        });
        print('Loaded albums for artist: ${widget.artist.artistId}');
        print('Loaded ${albums.length} albums for artist');
        print('Albums: ${albums.map((a) => a.albumName).toList()}');
      }
    } catch (e) {
      print('Error loading artist albums: $e');
      if (mounted) {
        setState(() {
          _artistAlbums = [];
          _isLoadingAlbums = false;
        });
      }
    }
  }

  Future<void> _toggleFollow() async {
    final followProvider = Provider.of<ArtistFollowProvider>(
      context,
      listen: false,
    );
    await followProvider.toggleFollow(widget.artist.artistId);
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

      // Prepare queue with artist tracks and ensure artistObj is set
      List<Track> queue = (_artistTracks ?? []).map((t) {
        // Ensure each track has the artist object
        return t.artistObj == null ? t.copyWith(artistObj: widget.artist) : t;
      }).toList();

      // Check if queue size is sufficient (use defaultPageSize as minimum)
      const minQueueSize = ApiConfig.defaultPageSize;
      if (queue.length < minQueueSize) {
        try {
          // Load trending songs to fill the queue
          final trendingSongs = await serviceLocator.musicService
              .getTrendingTracks(limit: minQueueSize);

          // Remove duplicates and add trending songs
          final existingIds = queue.map((t) => t.trackId).toSet();
          final additionalSongs = trendingSongs
              .where((t) => !existingIds.contains(t.trackId))
              .toList();

          queue.addAll(additionalSongs);

          print(
            'Queue enhanced: ${_artistTracks?.length ?? 0} artist tracks + '
            '${additionalSongs.length} trending songs = ${queue.length} total',
          );
        } catch (e) {
          print('Error loading trending songs for queue: $e');
          // Continue with just artist tracks if trending fetch fails
        }
      }

      // Ensure the current track also has artistObj
      final trackWithArtist = track.artistObj == null
          ? track.copyWith(artistObj: widget.artist)
          : track;

      // Load track with enhanced queue; prefer recommended queue when available
      await musicPlayerProvider.setTrackWithRecommended(
        trackWithArtist,
        fallbackQueue: queue,
      );
      musicPlayerProvider.play();
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
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
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
                    Consumer<ArtistFollowProvider>(
                      builder: (context, followProvider, child) {
                        final isFollowing = followProvider.isFollowing(
                          widget.artist.artistId,
                        );
                        final isLoading = followProvider.isLoading(
                          widget.artist.artistId,
                        );

                        return OutlinedButton(
                          onPressed: isLoading ? null : _toggleFollow,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isFollowing
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            backgroundColor: isFollowing
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                )
                              : Text(
                                  isFollowing ? "Following" : "Follow",
                                  style: GoogleFonts.inter(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontSize: 17,
                                  ),
                                ),
                        );
                      },
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      height: 50,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/shuffle.svg',
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Playlists Section
            if (_isLoadingPlaylists || playlists.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Playlists",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _isLoadingPlaylists
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
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
                              itemCount: playlists.length,
                              itemBuilder: (context, i) => Container(
                                width: 180,
                                margin: const EdgeInsets.only(right: 16),
                                child: PlaylistCard(
                                  item: PlaylistItem(
                                    title: playlists[i].name,
                                    author: playlists[i].ownerName,
                                    coverUrl: playlists[i].coverUrl,
                                    songCount: playlists[i].trackCount,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
            // Albums Section
            if (_isLoadingAlbums ||
                (_artistAlbums != null && _artistAlbums!.isNotEmpty)) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Albums",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _isLoadingAlbums
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
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
                              itemCount: _artistAlbums!.length,
                              itemBuilder: (context, i) {
                                final album = _artistAlbums![i];
                                return Container(
                                  width: 180,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: PlaylistCard(
                                    item: PlaylistItem(
                                      title: album.albumName,
                                      author: album.artistName,
                                      coverUrl: album.albumImageUrl,
                                      songCount: album.totalTrack,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
            // All Tracks Section
            if (_isLoadingTracks ||
                (_artistTracks != null && _artistTracks!.isNotEmpty)) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "All Tracks",
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
                      artist: widget.artist.nickname,
                      albumArtist: 'Track',
                      duration: _formatDuration(track.durationMs),
                      image: track.albumArtUrl,
                      onTap: () => _onTrackTapped(track),
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
