import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
class HomeCenter extends StatefulWidget {
  const HomeCenter({super.key});
  
  @override
  State<HomeCenter> createState() => _HomeCenterState();
}

class _HomeCenterState extends State<HomeCenter> {
  bool _isPlaying = false;
  int _selectedCategoryIndex = 0; // Index của category được chọn
  List<String> _categories = []; // Danh sách categories từ API
  List<Map<String, dynamic>> _trendingSongs = [];
  List<Map<String, dynamic>> _popularArtists = [];
  bool _isLoadingCategories = true;
  bool _isLoadingTrendingSongs = true;
  List<Map<String, dynamic>> _favoriteItems = []; // Danh sách yêu thích
  bool _isLoadingFavorites = true;
  int _selectedTrendingSongIndex = -1; // Index của bài hát đang được chọn

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadFavoriteItems();
    _loadTrendingSongs();
    _loadPopularArtists();
  }

  Future<void> _loadPopularArtists() async {
    try {
      // Giả lập API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      final List<Map<String, dynamic>> apiResponse = [
        {
          'id': '1',
          'name': 'Sơn Tùng M-TP',
          'image': 'assets/images/artists_mtp.png',
          'role': 'Singer',
        },
        {
          'id': '2', 
          'name': 'Seachains',
          'image': 'assets/images/seachains.png',
          'role': 'Singer',
        },
        {
          'id': '3', 
          'name': 'Soobin',
          'image': 'assets/images/soobin.png',
          'role': 'Singer',
        },
        {
          'id': '4', 
          'name': 'Saabirose',
          'image': 'assets/images/saabirose.png',
          'role': 'Singer',
        },
        // Thêm các nghệ sĩ khác tương tự
      ];
      
      if (mounted) {
        setState(() {
          _popularArtists = apiResponse;
          _isLoadingTrendingSongs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _popularArtists = [];
        });
      }
      print('Error loading popular artists: $e');
    }
  }

  
  Future<void> _loadTrendingSongs() async {
    try {
      // Giả lập API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      final List<Map<String, dynamic>> apiResponse = [
        {
          'id': '1',
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2', 
          'title': 'EM XIN "SAY HI" 2025',
          'artist': 'Cao Dân',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3', 
          'title': 'Playlist Sơn Tùng M-TP',
          'artist': 'Trần Mai Trung Kiên',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '4', 
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '5', 
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '6', 
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '7', 
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '8', 
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '9', 
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
        },
        // Thêm các bài hát khác tương tự
      ];
      
      if (mounted) {
        setState(() {
          _trendingSongs = apiResponse;
          _isLoadingTrendingSongs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _trendingSongs = [];
        });
      }
      print('Error loading trending songs: $e');
    }
  }


  // Gọi API 
  Future<void> _loadCategories() async {
    try {
      // final List<String> apiResponse = await CategoryService.getCategories();
      
      // fake API
      await Future.delayed(const Duration(seconds: 1)); // Giả lập network delay
      final List<String> apiResponse = [
        'All',
        'Music', 
        'Podcasts',
        'Audiobooks',
        'Playlists',
        'Artists',
        'Albums',
        'Live Radio'
      ];
      
      if (mounted) {
        setState(() {
          _categories = apiResponse;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _categories = ['All', 'Music', 'Podcasts']; // Fallback data
          _isLoadingCategories = false;
        });
      }
      print('Error loading categories: $e');
    }
  }

  // Gọi API để lấy danh sách yêu thích (tối đa 8 items)
  Future<void> _loadFavoriteItems() async {
    try {
      // Giả lập API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      final List<Map<String, dynamic>> apiResponse = [
        {
          'id': '1',
          'title': 'Thiền Hạ Nghe Gì',
          'subtitle': 'Daily Mix',
          'image': 'assets/images/thienhanghegi.png',
          'type': 'playlist'
        },
        {
          'id': '2', 
          'title': 'B Ray Radio',
          'subtitle': 'Daily',
          'image': 'assets/images/brayradio.png',
          'type': 'radio'
        },
        {
          'id': '3',
          'title': 'HIEUTHUHAI Radio', 
          'subtitle': 'HIEUTHUHAI',
          'image': 'assets/images/HTH_radio.png',
          'type': 'radio'
        },
        {
          'id': '4',
          'title': 'Hoàng Dũng',
          'subtitle': 'Artist',
          'image': 'assets/images/hoangdung.png', 
          'type': 'artist'
        },
        {
          'id': '5',
          'title': 'Have a sip',
          'subtitle': 'Playlist • 24 songs',
          'image': 'assets/images/haveasip.png',
          'type': 'playlist'
        },
        {
          'id': '6',
          'title': 'Vũ.',
          'subtitle': 'Artist • 2.1M followers',
          'image': 'assets/images/vu.png',
          'type': 'artist'
        },
        {
          'id': '7',
          'title': 'Ballad buồn',
          'subtitle': 'Made for you',
          'image': 'assets/images/balladbuon.png',
          'type': 'playlist'
        },
        {
          'id': '8',
          'title': 'Indie Việt',
          'subtitle': 'Playlist • 156 songs', 
          'image': 'assets/images/indieviet.png',
          'type': 'playlist'
        }
      ];
      
      if (mounted) {
        setState(() {
          _favoriteItems = apiResponse.take(8).toList(); // Chỉ lấy tối đa 8 items
          _isLoadingFavorites = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _favoriteItems = [];
          _isLoadingFavorites = false;
        });
      }
      print('Error loading favorite items: $e');
    }
  }

  // Method để xử lý khi user chọn category
  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    
    // Gọi API để lấy nội dung theo category đã chọn
    _loadContentByCategory(_categories[index]);
    print('Selected category: ${_categories[index]}');
  }

  // Method để xử lý khi user tap vào favorite item
  void _onFavoriteItemTapped(Map<String, dynamic> item) {
    print('Tapped favorite item: ${item['title']} (${item['type']})');
    
    // TODO: Implement navigation based on item type
    switch (item['type']) {
      case 'playlist':
        // Navigate to playlist detail
        break;
      case 'artist':
        // Navigate to artist profile
        break;
      case 'radio':
        // Start playing radio
        break;
      default:
        // Default action
        break;
    }
  }

  // Method để xử lý khi user tap vào trending song
  void _onTrendingSongTapped(Map<String, dynamic> song) {
    print('Tapped trending song: ${song['title']} by ${song['artist']}');
    // TODO: Implement play song or navigate to song detail
  }
  void _onPopularArtistTapped(Map<String, dynamic> artist) {
    print('Tapped popular artist: ${artist['name']}');
  }

  // Gọi API để lấy nội dung theo category
  Future<void> _loadContentByCategory(String category) async {
    try {
      // OPTION 1:
      // final content = await CategoryService.getContentByCategory(category);
      
      // OPTION 2: Giả lập API call
      await Future.delayed(const Duration(milliseconds: 500));
      print('Loading content for category: $category');
      
      // TODO: Update UI với dữ liệu mới từ API
      // Ví dụ: setState(() { _contentList = content; });
      
    } catch (e) {
      print('Error loading content for category $category: $e');
    }
  }


  Widget _buildCustomIcon(String svgPath, bool isActive, double sizeWidth, double sizeHeight) {
    return Container(
      width: sizeWidth,
      height: sizeHeight,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          svgPath,
          width: sizeWidth,
          height: sizeHeight,
          // colorFilter: ColorFilter.mode(
          //   isActive ? Colors.white : Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        // color: const Color(0xFF1A1A1A),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 71, 1, 1),
            const Color(0xFF1A1A1A),
            
          ],
          stops: [0.0, 0.3], // 0-30% màu đỏ đen, 30-100% màu xám đen
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF040404),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Căn trái
              crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
              children: [
                // Left Side - Image
                Container(
                  width: 200,
                  height: 200,  
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Image(
                              image: AssetImage('assets/images/HTH.png'),
                              fit: BoxFit.cover,
                            ),
                  
                ),

                // Right Side - Text Info
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30), // Space for close button
                            Text(
                              'Album',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            
                          ),
                          
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Ai Cũng Phải Bắt Đầu Từ Đâu Đó',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Text(
                        //   'Sơn Tùng M-TP • Single',
                        //   style: TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        const Spacer(), // Đẩy container xuống dưới cùng
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green,
                                ),
                                child: Image(image: AssetImage('assets/images/HTH_icon.png'),fit: BoxFit.fill,),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'HIEUTHUHAI • 2023 • 13 songs, 39 min 44 sec ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: (){
                                  setState((){
                                    _isPlaying = !_isPlaying;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE62429),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(95, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(  
                                  _isPlaying ? 'Pause' : 'Play',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button positioned at top right
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        )
      ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
            
            ),
            child: _isLoadingCategories
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                    strokeWidth: 2,
                  ),
                )
              : SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedCategoryIndex;
                      return ElevatedButton(
                        onPressed: () => _onCategorySelected(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected 
                            ? Theme.of(context).colorScheme.onBackground
                            : AppTheme.darkSurfaceButton,
                          foregroundColor: isSelected
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.onBackground,
                          minimumSize: Size(
                            _categories[index].length * 10.0 + 20, // Dynamic width based on text length
                            40
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: isSelected ? 3 : 1,
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ),
          const SizedBox(height: 24),
          
          
          // Favorite items grid (2 rows x 4 columns)
          _isLoadingFavorites
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                  strokeWidth: 2,
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 columns
                  childAspectRatio: 6, // Tỷ lệ rộng hơn để items thấp hơn
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 8, // Giảm spacing giữa các hàng
                ),
                  itemCount: _favoriteItems.length > 8 ? 8 : _favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = _favoriteItems[index];
                    return _FavoriteItemCard(
                      item: item,
                      onTap: () => _onFavoriteItemTapped(item),
                    );
                  },
                ),
          const SizedBox(height: 16),

          Text(
            'Trending songs',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              
            ),
          ),
          const SizedBox(height: 16),



          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: _isLoadingTrendingSongs
              ? const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                    strokeWidth: 2,
                  ),
              ):
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _trendingSongs.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final song = _trendingSongs[index];
                    return _TrendingSongCard(
                      song: song,
                      onTap: () => _onTrendingSongTapped(song),
                    );
                  }
                )
                
              )
          ),
          const SizedBox(height: 16),

          Text(
            'Popular artists',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              
            ),
          ),

          const SizedBox(height: 16),


          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: _isLoadingTrendingSongs
              ? const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                    strokeWidth: 2,
                  ),
              ):
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _popularArtists.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final artist = _popularArtists[index];
                    return _PopularArtistCard(
                      artist: artist,
                      onTap: () => _onPopularArtistTapped(artist),
                    );
                    
                    

                  }
                )
                
              )
          ),
        ],
        ),
      ),
    );
  }
}

// Widget riêng để xử lý hover effect cho favorite items
class _FavoriteItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _FavoriteItemCard({
    required this.item,
    required this.onTap,
  });

  @override
  State<_FavoriteItemCard> createState() => _FavoriteItemCardState();
}





class _FavoriteItemCardState extends State<_FavoriteItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered 
              ? AppTheme.darkSurfaceButton.withOpacity(0.7)
              : AppTheme.darkSurfaceButton,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.2),
                blurRadius: _isHovered ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            
            children: [
             
              // Image container - tràn ra viền
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.grey[800],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: widget.item['image'] != null
                    ? Image.asset(
                        widget.item['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[700],
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white54,
                              size: 20,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[700],
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                ),
              ),
              
              // Text container - bên phải của hình
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Text(
                        widget.item['title'] ?? '',
                        style: TextStyle(
                          color: _isHovered ? Colors.white : Colors.white.withOpacity(0.95),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.item['subtitle'] ?? '',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if(_isHovered )
                          
                            Container(
                                width: 48,
                                height: 48,
                                
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE62429), 
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
            
              const SizedBox(width: 8), // Khoảng cách bên phải icon
            ],
          ),
        ),
      ),
    );
  }
}


class _PopularArtistCard extends StatefulWidget {
  final Map<String, dynamic> artist;
  final VoidCallback onTap;

  const _PopularArtistCard({
    required this.artist,
    required this.onTap,
  });

  @override
  State<_PopularArtistCard> createState() => _PopularArtistCardState();
}

class _PopularArtistCardState extends State<_PopularArtistCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered 
              ? Colors.transparent
              : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 200,
            padding: EdgeInsets.all(_isHovered ? 8 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset(
                    widget.artist['image'],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ), 
                const SizedBox(height: 8),
                Text(
                  widget.artist['name'],
                  style: TextStyle(
                    color: _isHovered ? Colors.white : Colors.white.withOpacity(0.95),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.artist['role'],
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget riêng để xử lý hover effect cho trending songs
class _TrendingSongCard extends StatefulWidget {
  final Map<String, dynamic> song;
  final VoidCallback onTap;

  const _TrendingSongCard({
    required this.song,
    required this.onTap,
  });

  @override
  State<_TrendingSongCard> createState() => _TrendingSongCardState();
}

class _TrendingSongCardState extends State<_TrendingSongCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isHovered ? 216 : 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered 
              ? const Color(0xFF2A2A2A)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.song['image'],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (_isHovered)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE62429), 
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                ],
              ), 
              const SizedBox(height: 8),
              Text(
                widget.song['title'],
                style: TextStyle(
                  color: _isHovered ? Colors.white : Colors.white.withOpacity(0.95),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.song['artist'],
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
