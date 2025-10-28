import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực

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
          'title': 'Không Buông',
          'artist': 'hngle, Ari',
          'image': 'assets/images/khongbuon.png',
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
          'image': 'assets/images/HTH.png',
          'type': 'radio'
        },
        {
          'id': '4',
          'title': 'Hoàng Dũng',
          'subtitle': 'Artist',
          'image': 'assets/images/HTH.png', 
          'type': 'artist'
        },
        {
          'id': '5',
          'title': 'Have a sip',
          'subtitle': 'Playlist • 24 songs',
          'image': 'assets/images/HTH.png',
          'type': 'playlist'
        },
        {
          'id': '6',
          'title': 'Vũ.',
          'subtitle': 'Artist • 2.1M followers',
          'image': 'assets/images/HTH.png',
          'type': 'artist'
        },
        {
          'id': '7',
          'title': 'Ballad buồn',
          'subtitle': 'Made for you',
          'image': 'assets/images/HTH.png',
          'type': 'playlist'
        },
        {
          'id': '8',
          'title': 'Indie Việt',
          'subtitle': 'Playlist • 156 songs', 
          'image': 'assets/images/HTH.png',
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
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Album',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            
                          ),
                          
                        ),
                        SizedBox(height: 45),
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
                    return GestureDetector(
                      onTap: () => _onFavoriteItemTapped(item),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: AppTheme.darkSurfaceButton,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Image container - tràn ra viền
                            Container(
                              width: 60,
                              height: 60,
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
                                child: item['image'] != null
                                  ? Image.asset(
                                      item['image'],
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
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item['subtitle'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    return GestureDetector(
                      // onTap: () => _
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          
                          borderRadius: BorderRadius.circular(8),
                          
                          
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      song['image'],
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ), 
                                  const SizedBox(height: 8),
                                  Text(
                                    song['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    song['artist'],
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
                          ],
                        ),
                      )
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
                    return GestureDetector(
                      // onTap: () => _
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          
                          borderRadius: BorderRadius.circular(8),
                          
                          
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image.asset(
                                      artist['image'],
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ), 
                                  const SizedBox(height: 8),
                                  Text(
                                    artist['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    artist['role'],
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
                          ],
                        ),
                      )
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
