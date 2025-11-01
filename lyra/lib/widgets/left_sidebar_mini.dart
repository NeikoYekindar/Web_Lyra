import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeftSidebarMini extends StatefulWidget {
  final VoidCallback? onLibraryIconPressed;
  
  const LeftSidebarMini({
    super.key,
    this.onLibraryIconPressed,
  });

  @override
  State<LeftSidebarMini> createState() => _LeftSidebarMiniState();
}

class _LeftSidebarMiniState extends State<LeftSidebarMini> {
  List<String> albumImages = [];
  List<Map<String, dynamic>> PlaylistsUserImages = [];
  bool _isLoadingPlaylistsUser = true;
  bool _isLoadingAlbums = true;

  @override
  void initState() {
    super.initState();
    _loadAlbumImages();
    _loadPlayListUser();
  }
  Future<void> _loadPlayListUser() async {
    try {
      // Giả lập API call
      await Future.delayed(const Duration(milliseconds: 800));
      
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
        // Thêm các bài hát khác tương tự
      ];
      
      if (mounted) {
        setState(() {
          PlaylistsUserImages = apiResponse;
          _isLoadingPlaylistsUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          PlaylistsUserImages = [];
        });
      }
      print('Error loading playlists user: $e');
    }
  }


  // Giả lập API call để lấy danh sách album
  Future<void> _loadAlbumImages() async {
    try {
      // Giả lập API call với delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final List<String> apiResponse = [
        'assets/images/album_1.png',
        'assets/images/album_2.png',
        'assets/images/album_3.png',
        'assets/images/album_3.png',
      ];
      
      if (mounted) {
        setState(() {
          albumImages = apiResponse;
          _isLoadingAlbums = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          albumImages = [];
          _isLoadingAlbums = false;
        });
      }
      print('Error loading albums: $e');
    }
  }

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
          _buildCustomIconMenuItemLibrary('assets/icons/library_icon.svg', true, 60, widget.onLibraryIconPressed),
          const SizedBox(height: 8),
          _buildCustomIconMenuItem('assets/icons/library_add_icon.svg', false, 60),
          const SizedBox(height: 16),
          
          // Hiển thị danh sách album icons
          Expanded(
            child: _isLoadingAlbums
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : ListView.separated(
                  itemCount: PlaylistsUserImages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _buildAlbumIconPNG(PlaylistsUserImages[index]['image'], false);
                  },
                ),
          ),
        ],
      ),
    );
  }
    Widget _buildCustomIconMenuItemLibrary(String svgPath, bool isActive, double size, VoidCallback? onPressed) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed ?? () {},
        style: IconButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
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
        style: IconButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
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
        style: IconButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
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
}