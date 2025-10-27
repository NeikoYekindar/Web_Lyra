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
  bool _isLoadingCategories = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Gọi API để lấy danh sách categories
  Future<void> _loadCategories() async {
    try {
      // OPTION 1: Sử dụng API thực (uncomment dòng dưới và import service)
      // final List<String> apiResponse = await CategoryService.getCategories();
      
      // OPTION 2: Giả lập API call (hiện tại)
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
      // Xử lý lỗi API
      if (mounted) {
        setState(() {
          _categories = ['All', 'Music', 'Podcasts']; // Fallback data
          _isLoadingCategories = false;
        });
      }
      print('Error loading categories: $e');
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
  
  // Gọi API để lấy nội dung theo category
  Future<void> _loadContentByCategory(String category) async {
    try {
      // OPTION 1: Sử dụng API thực (uncomment dòng dưới)
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
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
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
                            fontSize: 24,
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
                                  minimumSize: const Size(90, 40),
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
          
          
        ],
      )
    );
  }
}
