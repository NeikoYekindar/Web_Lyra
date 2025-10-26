import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeftSidebarMini extends StatelessWidget {
  const LeftSidebarMini({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 8, bottom: 10, left: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomIconMenuItemLibrary('assets/icons/library_icon.svg', true, 60),
          const SizedBox(height: 8),
          _buildCustomIconMenuItem('assets/icons/library_add_icon.svg', false, 60),
          const SizedBox(height: 16),
          _buildAlbumIconPNG('assets/images/album_1.png', false),
          const SizedBox(height: 8),
          _buildAlbumIconPNG('assets/images/album_2.png', false),
          const SizedBox(height: 8),
          _buildAlbumIconPNG('assets/images/album_3.png', false),

        ],
      ),
    );
  }
    Widget _buildCustomIconMenuItemLibrary(String svgPath, bool isActive, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          svgPath,
          width: 25,
          height: 25
          // colorFilter: ColorFilter.mode(
          //   isActive ? Colors.white : Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }
  

  Widget _buildCustomIconMenuItem(String svgPath, bool isActive, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          svgPath,
          width: 45,
          height: 45,
          // colorFilter: ColorFilter.mode(
          //   isActive ? Colors.white : Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }

  Widget _buildAlbumIconPNG(String pngPath, bool isActive) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {
          print('Clicked album: $pngPath'); // Debug log
        },
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            pngPath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback widget khi không load được PNG
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getAlbumColor(pngPath),
                      _getAlbumColor(pngPath).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Icon(
                    Icons.album,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getAlbumColor(String pngPath) {
    // Trả về màu khác nhau dựa trên tên file
    if (pngPath.contains('album1')) return Colors.red;
    if (pngPath.contains('album2')) return Colors.blue;
    if (pngPath.contains('album3')) return Colors.green;
    return Colors.orange; // Default color
  }

  // Hàm tổng quát để load cả PNG và SVG
  Widget _buildAlbumIcon(String imagePath, bool isActive, {String? tooltip, double size = 40.0}) {
    bool isPng = imagePath.toLowerCase().endsWith('.png') || 
                imagePath.toLowerCase().endsWith('.jpg') || 
                imagePath.toLowerCase().endsWith('.jpeg');
    
    if (isPng) {
      return _buildAlbumIconPNG(imagePath, isActive);
    } else {
      return _buildCustomIconMenuItem(imagePath, isActive, size);
    }
  }
}