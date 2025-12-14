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
    {'name': 'Shiki', 'image': 'assets/images/HTHT.png'}, // Placeholder
    {'name': 'Saabirose', 'image': 'assets/images/HTHT.png'},
    {'name': 'Seachains', 'image': 'assets/images/HTHT.png'},
  ];

  final List<Map<String, String>> _songs = [
    {'title': 'SO ĐẬM', 'artist': 'EM XINH "SAY HI", Phương Ly...', 'image': 'assets/images/HTHT.png', 'duration': '3:40'},
    {'title': 'Sinh Ra Đã Là Thứ Đối Lập nhau', 'artist': 'Emcee L (Da LAB), Badbies', 'image': 'assets/images/HTHT.png', 'duration': '3:54'},
    {'title': 'Say Yes (Vietnamese Version)', 'artist': 'OgeNus, PiaLinh', 'image': 'assets/images/HTHT.png', 'duration': '3:43'},
    {'title': 'Sau Cơn Mưa', 'artist': 'CoolKid, RHYDER', 'image': 'assets/images/HTHT.png', 'duration': '2:34'},
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Filter Chips (All, Artists, Songs...)
              SizedBox(
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
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      backgroundColor: Colors.transparent,
                      selectedColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 30),

              // 2. Artists Section
              const Text('Artists', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 180, // Chiều cao cố định cho list ngang
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _artists.length,
                  separatorBuilder: (ctx, index) => const SizedBox(width: 20),
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(_artists[index]['image']!),
                          backgroundColor: Colors.grey[800],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _artists[index]['name']!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const Text('Artist', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    );
                  },
                ),
              ),

              // 3. Songs Section
              const Text('Songs', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _songs.length,
                itemBuilder: (ctx, index) {
                  final song = _songs[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(song['image']!, width: 50, height: 50, fit: BoxFit.cover,
                        errorBuilder: (_,__,___) => Container(width: 50, height: 50, color: Colors.grey[800]),
                      ),
                    ),
                    title: Text(song['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: Text(song['artist']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    trailing: Text(song['duration']!, style: const TextStyle(color: Colors.grey)),
                    onTap: () {},
                  );
                },
              ),

              const SizedBox(height: 30),

              // 4. Playlists Section (Placeholder giống ảnh)
              const Text('Playlists', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
               SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (ctx, index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.5),
                              ),
                              child: const Center(child: Icon(Icons.music_note, color: Colors.white, size: 40)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Playlist ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                const Text('By Lyra', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Spacer bottom
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}