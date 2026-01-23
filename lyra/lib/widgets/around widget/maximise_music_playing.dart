import 'package:flutter/material.dart';
import 'package:lyra/widgets/common/trackItem.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/theme/app_theme.dart';
import '../../providers/music_player_provider.dart';
import '../../providers/auth_provider_v2.dart';
import '../../providers/artist_follow_provider.dart';
import '../../core/di/service_locator.dart';
import '../../shell/app_shell_controller.dart';
import '../../models/current_user.dart';
import 'package:lyra/models/track.dart';
import 'package:lyra/models/artist.dart';

class MaximiseMusicPlaying extends StatefulWidget {
  const MaximiseMusicPlaying({super.key});

  @override
  State<MaximiseMusicPlaying> createState() => _MaximiseMusicPlayingState();
}

class _MaximiseMusicPlayingState extends State<MaximiseMusicPlaying>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // rotation period in seconds (smaller = faster)
  // default: 0.25x speed => 4.0 seconds per rotation
  double _rotationSeconds = 4.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_rotationSeconds * 1000).toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    // Nhớ dispose controller khi widget không còn sử dụng để tránh memory leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double albumSize = 300.0;
    const double vinylSize = 380.0;
    const double vinylOffset = 90.0;

    // Lấy thông tin track hiện tại từ MusicPlayerProvider
    final player = context.watch<MusicPlayerProvider>();
    final track = player.currentTrack;

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // AppTheme.redPrimaryDark,
            Color(0xFF737272),
            Color(0xFF3C3434),
          ],
          stops: const [0.0, 1],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: ScrollConfiguration(
        behavior: _NoScrollbarBehavior(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track?.title ?? "Chưa chọn bài hát",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              track?.artist ?? "Nghệ sĩ chưa rõ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Đóng maximize player bằng controller
                          final shellCtrl = Provider.of<AppShellController?>(
                            context,
                            listen: false,
                          );
                          if (shellCtrl != null) {
                            shellCtrl.closeMaximizedPlayer();
                          }
                        },
                        // Thay thế Icon bằng SvgPicture.asset
                        icon: SvgPicture.asset(
                          'assets/icons/closeExpanded.svg', // Đường dẫn đến file svg của bạn
                          width: 25, // Kích thước tương đương size: 30 cũ
                          height: 25,
                          // Để đổi màu SVG sang trắng giống như icon cũ (color: Colors.white)
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: albumSize + vinylOffset + 100,
                  height: 500,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Đĩa than nằm dưới
                      Positioned(
                        left: vinylOffset,
                        child: RotationTransition(
                          turns: _controller,
                          child: Container(
                            width: vinylSize,
                            height: vinylSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent, // Màu nền đĩa
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0), // Viền đĩa
                              child: Image.asset(
                                'assets/images/vinyl_record.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Album Art nằm trên
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildAlbumArt(
                            track?.albumArtUrl ?? 'assets/images/HTH.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Sử dụng LayoutBuilder để responsive
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Tính toán width dựa trên space available
                    final availableWidth = constraints.maxWidth - 40;
                    final bool isWide = availableWidth > 1000;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: isWide
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Artist Info Card
                                if (track != null)
                                  Flexible(
                                    flex: 5,
                                    child: _ArtistInfoCardMaximized(
                                      artist: track.artistObj,
                                    ),
                                  ),
                                const SizedBox(width: 20),
                                // Next in queue
                                Flexible(flex: 4, child: _NextQueueSection()),
                              ],
                            )
                          : Column(
                              children: [
                                // Artist Info Card
                                if (track != null)
                                  _ArtistInfoCardMaximized(
                                    artist: track.artistObj,
                                  ),
                                const SizedBox(height: 20),
                                // Next in queue
                                const _NextQueueSection(),
                              ],
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.music_note, color: Colors.white, size: 60);
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/HTH.png',
          width: 300,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.music_note, color: Colors.white, size: 60),
        ),
      );
    }

    final assetPath = imageUrl.startsWith('assets/')
        ? imageUrl
        : 'assets/$imageUrl';
    return Image.asset(
      assetPath,
      width: 300,
      height: 300,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/HTH.png',
        width: 300,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.music_note, color: Colors.white, size: 60),
      ),
    );
  }
}

// Widget hiển thị thông tin artist với nút follow
class _ArtistInfoCardMaximized extends StatefulWidget {
  final Artist? artist;
  const _ArtistInfoCardMaximized({required this.artist});

  @override
  State<_ArtistInfoCardMaximized> createState() =>
      _ArtistInfoCardMaximizedState();
}

class _ArtistInfoCardMaximizedState extends State<_ArtistInfoCardMaximized> {
  @override
  void initState() {
    super.initState();
    // Check follow status using provider
    if (widget.artist != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ArtistFollowProvider>(
          context,
          listen: false,
        ).checkFollowStatus(widget.artist!.artistId);
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (widget.artist == null) return;
    final followProvider = Provider.of<ArtistFollowProvider>(
      context,
      listen: false,
    );
    await followProvider.toggleFollow(widget.artist!.artistId);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.artist == null) {
      return const SizedBox.shrink();
    }

    return Consumer<ArtistFollowProvider>(
      builder: (context, followProvider, child) {
        final isFollowing = followProvider.isFollowing(widget.artist!.artistId);
        final isLoading = followProvider.isLoading(widget.artist!.artistId);

        return Container(
          height: 400,
          width: 550,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF2C2C2C),
          ),
          child: Stack(
            children: [
              // Ảnh nền
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/image 18.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey.shade800),
                  ),
                ),
              ),

              // Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Tiêu đề
              const Positioned(
                top: 20,
                left: 20,
                child: Text(
                  "About the artist",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Thông tin chi tiết
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.artist?.nickname ?? 'Unknown artist',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.artist?.totalStreams ?? 0} listeners",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.artist?.bio ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: isLoading ? null : _toggleFollow,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isFollowing ? Colors.grey : Colors.white,
                        ),
                        backgroundColor: isFollowing
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isFollowing ? "Following" : "Follow",
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
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

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

// Widget hiển thị Next in Queue
class _NextQueueSection extends StatelessWidget {
  const _NextQueueSection();

  @override
  Widget build(BuildContext context) {
    final player = context.watch<MusicPlayerProvider>();
    final queue = player.queue;
    final currentTrack = player.currentTrack;

    // Lấy các track tiếp theo (không bao gồm track hiện tại)
    // Tìm vị trí của track hiện tại trong queue
    final currentIndex = currentTrack != null
        ? queue.indexWhere((track) => track.id == currentTrack.id)
        : -1;

    final upcomingTracks = currentIndex >= 0 && currentIndex < queue.length - 1
        ? queue.sublist(currentIndex + 1)
        : <Track>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Next in queue",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                final shellCtrl = Provider.of<AppShellController?>(
                  context,
                  listen: false,
                );
                shellCtrl?.openQueue();
              },
              child: const Text(
                "Open queue",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          constraints: const BoxConstraints(maxHeight: 440),
          height: 400,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: upcomingTracks.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Queue is empty",
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: upcomingTracks.length > 15
                      ? 15
                      : upcomingTracks.length,
                  itemBuilder: (context, index) {
                    final track = upcomingTracks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TrackItem(
                        title: track.title,
                        artist: track.artist,
                        image: track.albumArtUrl,
                        onTap: () async {
                          // Play track từ queue
                          await player.setTrack(track);
                          player.play();
                          // Đóng maximize player
                          final shellCtrl = Provider.of<AppShellController?>(
                            context,
                            listen: false,
                          );
                          shellCtrl?.closeMaximizedPlayer();
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
