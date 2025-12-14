import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/theme/app_theme.dart';

class MaximiseMusicPlaying extends StatefulWidget {
  final VoidCallback onClose;
  const MaximiseMusicPlaying({super.key, required this.onClose});

  @override
  State<MaximiseMusicPlaying> createState() => _MaximiseMusicPlayingState();
}

class _MaximiseMusicPlayingState extends State<MaximiseMusicPlaying>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
        child: Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Chúng Ta Của Tương Lai",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Sơn Tùng M-TP",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: widget.onClose,
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
                                  padding: const EdgeInsets.all(
                                    0.0,
                                  ), // Viền đĩa
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
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/sontung_chungtacuahientai.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Expanded(
                          //         flex: 5,
                          Container(
                            height: 422,
                            width: 550, // Chiều cao cố định cho card
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(
                                0xFF2C2C2C,
                              ), // Màu nền dự phòng
                            ),
                            // Dùng Stack để xếp chồng Ảnh (dưới) và Chữ (trên)
                            child: Stack(
                              children: [
                                // LỚP 1: ẢNH NỀN ZOOM (Nằm dưới cùng)
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Transform.scale(
                                      scale: 1, // Zoom ảnh to lên 1.2 lần
                                      child: Image.asset(
                                        'assets/images/image 18.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                // LỚP 2: GRADIENT ĐEN MỜ (Để chữ dễ đọc)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(
                                            0.0,
                                          ), // Trong suốt ở trên
                                          Colors.black.withOpacity(
                                            0.9,
                                          ), // Đen đậm ở dưới
                                        ],
                                        stops: const [0.5, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                // LỚP 3: TIÊU ĐỀ "About the artists" (Góc trái trên)
                                const Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Text(
                                    "About the artists",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // LỚP 4: THÔNG TIN CHI TIẾT (Ở dưới cùng)
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Sơn Tùng M-TP",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "2,044,507 monthly listener",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "Nguyễn Thanh Tùng, born in 1994, known professionally as Sơn Tùng M-TP...",
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
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                        ),
                                        child: const Text(
                                          "Follow",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ),
                          // ),
                          const SizedBox(width: 20),
                          //  Expanded(
                          //     flex: 4,
                          Container(
                            width: 400,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header của Queue
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      onPressed: () {},
                                      child: const Text(
                                        "Open queue",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Container chứa danh sách bài hát (Dùng FutureBuilder)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FutureBuilder<List<Map<String, dynamic>>>(
                                    future:
                                        LeftSidebarService.getPlaylistsUser(),
                                    builder: (context, snapshot) {
                                      // 1. Trạng thái Loading
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox(
                                          height: 100,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }

                                      // 2. Trạng thái Error
                                      if (snapshot.hasError) {
                                        return const SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              "Unable to load queue",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      // 3. Trạng thái Có dữ liệu
                                      final data = snapshot.data ?? [];
                                      if (data.isEmpty) {
                                        return const Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Center(
                                            child: Text(
                                              "Queue is empty",
                                              style: TextStyle(
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      // Lấy 5 bài đầu tiên để hiển thị
                                      final displayList = data.take(5).toList();

                                      return Column(
                                        children: displayList.map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                            ),
                                            child: QueueItem(
                                              // Map dữ liệu từ API vào Widget
                                              title:
                                                  item['name'] ??
                                                  'Unknown Song',
                                              subtitle:
                                                  item['owner'] ??
                                                  'Unknown Artist',
                                              coverUrl: item['image'] ?? '',
                                              onTap: () {
                                                print(
                                                  "Playing: ${item['name']}",
                                                );
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //  ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LeftSidebarService {
  static Future<List<Map<String, dynamic>>> getPlaylistsUser() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      // Dữ liệu giả lập bạn cung cấp
      final List<Map<String, dynamic>> apiResponse = [
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3',
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '4',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '5',
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
      ];
      return apiResponse;
    } catch (e) {
      print('Error loading playlists user: $e');
      return [];
    }
  }
}

class QueueItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String coverUrl;
  final VoidCallback onTap;

  const QueueItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.coverUrl,
    required this.onTap,
  });

  @override
  State<QueueItem> createState() => _QueueItemState();
}

class _QueueItemState extends State<QueueItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            // Hiệu ứng đổi màu nền khi hover
            color: isHovered
                ? Colors.white.withOpacity(0.1) // Màu sáng nhẹ khi hover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _AlbumArt(coverUrl: widget.coverUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // Chữ sáng hơn khi hover
                        color: isHovered
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isHovered
                              ? textColor
                              : textColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Thêm icon drag handle để giống list nhạc
              if (isHovered)
                const Icon(Icons.drag_handle, color: Colors.white54, size: 20),
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
        color: Theme.of(context).colorScheme.surface,
        image: hasImage
            ? (coverUrl.startsWith('http')
                  ? DecorationImage(
                      image: NetworkImage(coverUrl),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage(coverUrl),
                      fit: BoxFit.cover,
                    ))
            : null,
      ),
      child: hasImage
          ? null
          : const Icon(
              Icons
                  .music_note, // Dùng icon music note cho đúng ngữ cảnh bài hát
              color: Colors.white54,
              size: 24,
            ),
    );
  }
}
