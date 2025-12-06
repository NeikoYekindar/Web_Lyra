import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';


class BrowseAllCenter extends StatefulWidget {
  const BrowseAllCenter({super.key});
  @override
  State<BrowseAllCenter> createState() => _BrowseAllCenterState();
}

class _BrowseAllCenterState extends State<BrowseAllCenter> {

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Nhạc', 'color': Color(0xFFDC148C), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Podcasts', 'color': Color(0xFF006450), 'image': 'assets/images/HTH.png'},
    {'title': 'Sự kiện trực tiếp', 'color': Color(0xFF8400E7), 'image': 'assets/images/khongbuon.png'},
    {'title': 'Điểm Nhấn Âm Nhạc 2025', 'color': Color(0xFFB06239), 'image': 'assets/images/sontung_chungtacuahientai.png'},
    {'title': 'Chuyện Podcast 2025', 'color': Color(0xFF7D9C08), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Dành Cho Bạn', 'color': Color(0xFF1E3264), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Mới phát hành', 'color': Color(0xFF608108), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Nhạc Việt', 'color': Color(0xFF477D95), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Pop', 'color': Color(0xFF477D95), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'K-Pop', 'color': Color(0xFFE61E32), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Hip-Hop', 'color': Color(0xFFBC5900), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Bảng xếp hạng', 'color': Color(0xFF8D67AB), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Tâm trạng', 'color': Color(0xFFE1118C), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Rock', 'color': Color(0xFFE91429), 'image': 'assets/images/emxinsayhi_2025.png'},
    {'title': 'Nhạc', 'color': Color(0xFFDC148C), 'image': 'assets/images/emxinsayhi_2025.png'},

  ];

    @override
    Widget build(BuildContext context){
      return Container(
        margin: const EdgeInsets.only(bottom: 10), // Khoảng cách dưới cùng
        width: double.infinity, // Lấp đầy chiều ngang
        height: double.infinity, // Lấp đầy chiều dọc
        decoration: BoxDecoration(
          // Màu nền: Dùng surface hoặc màu bạn muốn (ví dụ: Colors.black hoặc gradient)
          color: Theme.of(context).colorScheme.surface, 
          borderRadius: BorderRadius.circular(12), // Bo góc giống HomeCenter
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(
              builder: (context, constraints){
                double gridWidth = constraints.maxWidth;
                int crossAxisCount = 6; 
              // Đảm bảo ít nhất 2 cột
                if (crossAxisCount < 2) crossAxisCount = 2;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Browse all',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.4, // Tỷ lệ khung hình chữ nhật nằm ngang (giống ảnh)
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                      ),
                      itemBuilder: (context, index) {
                        return _CategoryCard(item: _categories[index]);
                      },
                    ),
                    // Khoảng trống dưới cùng để không bị che bởi player bar
                    const SizedBox(height: 100),
                  ],
                ),
              );
            },
          )
        ),
      );
      
  }
}
class _CategoryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          print("Tap category: ${item['title']}");
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: item['color'],
            ),
            child: Stack(
              children: [
                // --- PHẦN ẢNH (Đưa lên trước để vẽ trước) ---
                Positioned(
                  right: -20,
                  bottom: -10,
                  child: Transform.rotate(
                    angle: 25 * pi / 180,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: item['image'] != null 
                          ? Image.asset(
                              item['image'], 
                              fit: BoxFit.cover,
                              // Thêm xử lý lỗi nếu không tìm thấy ảnh
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.black12); // Màu placeholder
                              },
                            )
                          : Container(color: Colors.black12),
                      ),
                    ),
                  ),
                ),

                // --- PHẦN CHỮ (Đưa xuống sau để vẽ đè lên trên ảnh) ---
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align( // Thêm Align để giữ chữ ở góc trên trái
                    alignment: Alignment.topLeft,
                    child: Text(
                      item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}