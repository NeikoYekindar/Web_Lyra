import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';

class PlaylistDetailCenter extends StatefulWidget {
  final String playlistId; // Nhận ID để sau này load data thật
  const PlaylistDetailCenter({super.key, required this.playlistId});

  @override
  State<PlaylistDetailCenter> createState() => _PlaylistDetailCenterState();
}

class _PlaylistDetailCenterState extends State<PlaylistDetailCenter> {
  // Mock Data cho Playlist (giống ảnh image_fc471d.png)
  final List<Map<String, String>> _playlistSongs = [
    {'id': '1', 'title': 'SO ĐẬM', 'artist': 'EM XINH "SAY HI", Phương Ly...', 'album': 'EM XINH "SAY HI", TẬP 7', 'duration': '3:40', 'image': 'assets/images/HTHT.png'},
    {'id': '2', 'title': 'Sinh Ra Đã Là Thứ Đối Lập Nhau', 'artist': 'Emcee L (Da LAB), Badbies', 'album': 'Sinh Ra Đã Là Thứ Đối Lập Nhau', 'duration': '3:54', 'image': 'assets/images/HTHT.png'},
    {'id': '3', 'title': 'Say Yes (Vietnamese Version)', 'artist': 'OgeNus, PiaLinh', 'album': 'Say Yes (Vietnamese Version)', 'duration': '3:43', 'image': 'assets/images/HTHT.png'},
    {'id': '4', 'title': 'Sau Cơn Mưa', 'artist': 'CoolKid, RHYDER', 'album': 'Sau Cơn Mưa', 'duration': '2:34', 'image': 'assets/images/HTHT.png'},
    {'id': '5', 'title': 'SO ĐẬM', 'artist': 'EM XINH "SAY HI"', 'album': 'EM XINH "SAY HI", TẬP 7', 'duration': '3:40', 'image': 'assets/images/HTHT.png'},
    {'id': '6', 'title': 'Sinh Ra Đã Là Thứ Đối Lập Nhau', 'artist': 'Emcee L (Da LAB), Badbies', 'album': 'Sinh Ra Đã Là Thứ Đối Lập Nhau', 'duration': '3:54', 'image': 'assets/images/HTHT.png'},
    {'id': '7', 'title': 'Say Yes (Vietnamese Version)', 'artist': 'OgeNus, PiaLinh', 'album': 'Say Yes (Vietnamese Version)', 'duration': '3:43', 'image': 'assets/images/HTHT.png'},
    {'id': '8', 'title': 'Sau Cơn Mưa', 'artist': 'CoolKid, RHYDER', 'album': 'Sau Cơn Mưa', 'duration': '2:34', 'image': 'assets/images/HTHT.png'},
  ];

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo của Playlist (Ví dụ: Màu nâu đỏ như trong ảnh)
    final Color dominantColor = const Color(0xFF8B4040); 

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Màu nền mặc định bên dưới
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- 1. HEADER SECTION (Gradient Background) ---
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      dominantColor, // Màu đậm ở trên
                      Theme.of(context).colorScheme.surface, // Hoà vào nền ở dưới
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Row: Image + Text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Playlist Cover Image (Collage giả lập)
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 10))],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            // Dùng ảnh bìa playlist hoặc ghép 4 ảnh nhỏ
                            child: Image.asset('assets/images/HTHT.png', fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Public Playlist', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              // Tên Playlist LỚN
                              Text(
                                'My Playlist', 
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 60, // Size chữ cực lớn giống Spotify
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                  height: 1, // Line height thấp để chữ sát nhau
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Cuộc sống không thể thiếu âm nhạc',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              // Metadata Row: Avatar + Name + Stats
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 12,
                                    backgroundImage: AssetImage('assets/images/HTHT.png'), // Avatar user
                                  ),
                                  const SizedBox(width: 8),
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                      children: [
                                        TextSpan(text: 'Linh Pham Gia', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' • 13 songs, 39 min 44 sec', style: TextStyle(color: Colors.white70)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- 2. ACTION BAR (Play button row) ---
              Container(
                // Màu nền dần chuyển về đen hoàn toàn
                color: Theme.of(context).colorScheme.surface.withOpacity(0.3), 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    // Nút Play to màu đỏ/xanh
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE91429), // Màu đỏ thương hiệu
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.black, size: 32),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.grey, size: 28),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.grey, size: 28),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 28),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.grey, size: 24),
                      onPressed: () {},
                    ),
                    const Text('Custom order', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),

              // --- 3. SONG LIST (Header + Rows) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Table Header
                    const Row(
                      children: [
                        SizedBox(width: 40, child: Center(child: Text('#', style: TextStyle(color: Colors.grey)))),
                        Expanded(flex: 4, child: Text('Title', style: TextStyle(color: Colors.grey, fontSize: 13))),
                        Expanded(flex: 3, child: Text('Album', style: TextStyle(color: Colors.grey, fontSize: 13))),
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 16), // Padding for scrollbar spacing
                      ],
                    ),
                    const Divider(color: Colors.white10),
                    // List Songs
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _playlistSongs.length,
                      itemBuilder: (context, index) {
                        final song = _playlistSongs[index];
                        return _buildSongRow(index, song);
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongRow(int index, Map<String, String> song) {
    return InkWell(
      onTap: () {},
      hoverColor: Colors.white10,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 56, // Chiều cao cố định mỗi dòng
        padding: const EdgeInsets.symmetric(horizontal: 0), // Padding xử lý trong row
        child: Row(
          children: [
            // Index
            SizedBox(
              width: 40, 
              child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.grey, fontSize: 14))),
            ),
            
            // Image + Title + Artist
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(song['image']!, width: 40, height: 40, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(song['title']!, 
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        Text(song['artist']!, 
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Album
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(song['album']!, 
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            ),
            
            // Duration
            Text(song['duration']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}