import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';


class SearchResultCenter extends StatefulWidget {
  const SearchResultCenter({super.key});

  @override
  State<SearchResultCenter> createState() => _SearchResultCenterState();
}

class _SearchResultCenterState extends State<SearchResultCenter> {
  // Mock Data giả lập
  final List<String> _filters = ['All', 'Artists', 'Songs', 'Playlists', 'Albums', 'Podcasts'];
  int _selectedFilterIndex = 0;

  final List<Map<String, String>> _artists = [
    {'name': 'Sơn Tùng M-TP', 'image': 'assets/images/HTHT.png'},
    {'name': 'SOOBIN', 'image': 'assets/images/HTHT.png'},
    {'name': 'Shiki', 'image': 'assets/images/HTHT.png'}, 
    {'name': 'Saabirose', 'image': 'assets/images/HTHT.png'},
    {'name': 'Seachains', 'image': 'assets/images/HTHT.png'},
  ];

  // ĐÃ SỬA: Thêm trường 'album' vào data
  final List<Map<String, String>> _songs = [
    {'id': '1', 'title': 'SO ĐẬM', 'artist': 'EM XINH "SAY HI"', 'album': 'EM XINH EP.7', 'duration': '3:40', 'image': 'assets/images/HTHT.png'},
    {'id': '2', 'title': 'Sinh Ra Đã Là Thứ Đối Lập', 'artist': 'Emcee L (Da LAB)', 'album': 'Single', 'duration': '3:54', 'image': 'assets/images/HTHT.png'},
    {'id': '3', 'title': 'Say Yes (Ver)', 'artist': 'OgeNus, PiaLinh', 'album': 'Say Yes', 'duration': '3:43', 'image': 'assets/images/HTHT.png'},
    {'id': '4', 'title': 'Sau Cơn Mưa', 'artist': 'CoolKid, RHYDER', 'album': 'Sau Cơn Mưa', 'duration': '2:34', 'image': 'assets/images/HTHT.png'},
    {'id': '5', 'title': 'Chúng Ta Của Tương Lai', 'artist': 'Sơn Tùng M-TP', 'album': 'Single', 'duration': '4:09', 'image': 'assets/images/HTHT.png'},
    {'id': '6', 'title': 'Đừng Làm Trái Tim Anh Đau', 'artist': 'Sơn Tùng M-TP', 'album': 'Single', 'duration': '5:12', 'image': 'assets/images/HTHT.png'},
  ];

  final List<Map<String, String>> _playlists = [
    {'title': 'EM XINH "SAY HI"', 'creator': 'Cao Dân', 'image': 'assets/images/HTHT.png'},
    {'title': 'Playlist Sơn Tùng M-TP', 'creator': 'Trần Mai Trung Kiên', 'image': 'assets/images/HTHT.png'},
    {'title': 'Sleep', 'creator': 'Spotify', 'image': 'assets/images/HTHT.png'},
    {'title': 'Anh Hào Nhạc Việt', 'creator': 'Spotify', 'image': 'assets/images/HTHT.png'},
    {'title': 'Study with me', 'creator': 'elaine', 'image': 'assets/images/HTHT.png'},
    {'title': 'Nhạc Remix HOT', 'creator': 'Lộc music', 'image': 'assets/images/HTHT.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Background màu tối
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column( // Dùng Column thay vì SingleChildScrollView bao ngoài để fix layout
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Filter Chips Area
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              color: Theme.of(context).colorScheme.surface, 
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (ctx, index) => const SizedBox(width: 10),
                  itemBuilder: (ctx, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return ChoiceChip(
                      label: Text(_filters[index]),
                      selected: isSelected,
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      backgroundColor: Colors.transparent,
                      selectedColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : Colors.grey.shade800, 
                          width: 0.5
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // 2. Content Body (Dynamic)
            Expanded(
              child: _buildContentByFilter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentByFilter(){
    String currentFilter = _filters[_selectedFilterIndex];
    switch (currentFilter) {
      case 'All':
        return _buildAllSection();
      case 'Songs':
        return _buildSongsListDetailed();
      case 'Artists':
        return _buildArtistsGrid();
      case 'Playlists':
        return _buildPlaylistsGrid();
      default:
        return Center(
          child: Text('Chưa có dữ liệu cho $currentFilter', 
            style: const TextStyle(color: Colors.white54)),
        );
    }
  }

  Widget _buildAllSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Text('Artists', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           SizedBox(
             height: 220,
             child: ListView.separated(
               scrollDirection: Axis.horizontal,
               itemCount: _artists.length,
               separatorBuilder: (ctx, index) => const SizedBox(width: 24),
               itemBuilder: (ctx, index) => _buildArtistItem(_artists[index]),
             ),
           ),

           const SizedBox(height: 24),
           const Text('Songs', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           
           // Chỉ hiển thị 4 bài hát đầu
           ListView.builder(
             shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
             itemCount: _songs.length > 4 ? 4 : _songs.length,
             itemBuilder: (ctx, index) => _buildSongRowSimple(_songs[index]),
           ),

           const SizedBox(height: 24),
           const Text('Playlists', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           SizedBox(
             height: 240, 
             child: ListView.separated(
               scrollDirection: Axis.horizontal,
               itemCount: _playlists.length,
               separatorBuilder: (ctx, index) => const SizedBox(width: 20),
               itemBuilder: (ctx, index) => _buildPlaylistItem(_playlists[index]),
             ),
           ),
           const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSongsListDetailed() {
    return Column(
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 30, child: Text('#', style: TextStyle(color: Colors.grey))),
              const Expanded(flex: 4, child: Text('Title', style: TextStyle(color: Colors.grey))),
              const Expanded(flex: 3, child: Text('Album', style: TextStyle(color: Colors.grey))),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
            ],
          ),
        ),
        const Divider(color: Colors.white10, height: 1),
        
        // List Body
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _songs.length,
            itemBuilder: (context, index) {
              final song = _songs[index];
              return InkWell(
                onTap: () {},
                hoverColor: Colors.white10,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      // Index
                      SizedBox(width: 30, child: Text('${index + 1}', style: const TextStyle(color: Colors.grey))),
                      
                      // Title & Image
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(song['image']!, width: 40, height: 40, fit: BoxFit.cover,
                                errorBuilder: (_,__,___) => Container(color: Colors.grey[800], width: 40, height: 40),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(song['title']!, 
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                  Text(song['artist']!, 
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Album - ĐÃ FIX: Có thể gọi song['album'] an toàn
                      Expanded(
                        flex: 3,
                        child: Text(song['album'] ?? 'Unknown', // Fallback nếu null
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                      
                      // Duration
                      Text(song['duration']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtistsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid count
        int crossAxisCount = (constraints.maxWidth / 160).floor();
        if (crossAxisCount < 2) crossAxisCount = 2;

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: _artists.length,
          itemBuilder: (context, index) {
            return _buildArtistItem(_artists[index]);
          },
        );
      }
    );
  }

  Widget _buildPlaylistsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth / 180).floor();
        if (crossAxisCount < 2) crossAxisCount = 2;

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75, 
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: _playlists.length,
          itemBuilder: (context, index) {
            return _buildPlaylistItem(_playlists[index], isGrid: true);
          },
        );
      }
    );
  }

  // --- Helper Widgets ---

  Widget _buildArtistItem(Map<String, String> artist) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(artist['image']!),
              backgroundColor: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          artist['name']!,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Text('Artist', style: TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildSongRowSimple(Map<String, String> song) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(song['image']!, width: 48, height: 48, fit: BoxFit.cover,
          errorBuilder: (_,__,___) => Container(width: 48, height: 48, color: Colors.grey[800]),
        ),
      ),
      title: Text(song['title']!, 
        maxLines: 1, overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text(song['artist']!, 
        maxLines: 1, overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: Text(song['duration']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      onTap: () {},
    );
  }

  Widget _buildPlaylistItem(Map<String, String> playlist, {bool isGrid = false}) {
    return Container(
      width: isGrid ? null : 160, 
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(playlist['image']!, fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => Container(color: Colors.grey[800], child: const Icon(Icons.music_note, color: Colors.white54, size: 40))),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(playlist['title']!, 
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text('By ${playlist['creator']}', 
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}