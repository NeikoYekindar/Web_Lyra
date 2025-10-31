import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/theme/app_theme.dart';


class LeftSidebar extends StatefulWidget {
  final VoidCallback? onCollapsePressed;
  
  const LeftSidebar({
    super.key,
    this.onCollapsePressed,
  });

  @override
  State<LeftSidebar> createState() => _LeftSidebarState();
}






class _LeftSidebarState extends State<LeftSidebar> {

  List<String> albumImages = [];
  List<String> categories = [];
  List<Map<String, dynamic>> PlaylistsUser = [];
  int _selectedCategoryIndex = 0;
  bool _isLoadingAlbums = true; 
  bool _isLoadingCategories = true;
  bool _isLoadingPlaylistsUser  = true;
  @override
  void initState() {
    super.initState();
    _loadAlbumImages();
    _loadLeftSidebarCategories();
    _loadPlayListUser(); 
  }



  Future<void> _loadLeftSidebarCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final List<String> apiResponse = [
        'Playlists',
        'Artists',
        'Albums',
      ];
      if (mounted) {
        setState(() {
          categories = apiResponse;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          categories = [];
          _isLoadingCategories = false;
        });
      }
    }
  }

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


  Future<void> _loadPlayListUser() async {
    try {
      // Giả lập API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      final List<Map<String, dynamic>> apiResponse = [
        {
          'id': '1',
          'name': 'KhongBuon_PL',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '2', 
          'name': 'EM XIN "SAY HI" 2025',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '3', 
          'name': 'Playlist Sơn Tùng M-TP',
          'image': 'assets/images/playlist_mtp.png',
        },
        // Thêm các bài hát khác tương tự
      ];
      
      if (mounted) {
        setState(() {
          PlaylistsUser = apiResponse;
          _isLoadingPlaylistsUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          PlaylistsUser = [];
        });
      }
      print('Error loading playlists user: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 8, bottom: 10, left: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCustomIconMenuItemLibrary('assets/icons/closetominisize_icon.svg', false, 40, 40, widget.onCollapsePressed),
                const SizedBox(width: 8),
                Text(
                  'Your Library',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
                const Spacer(),
                _buildCustomIconMenuItemLibraryCreate('assets/icons/create.svg', false, 120, 60),
                const SizedBox(width: 2),
                _buildCustomIconMenuItemLibraryCreate('assets/icons/expand.svg', false, 35, 35),
              ]
              ),
          ),
          const SizedBox(height: 10),
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
                    height: 30,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index){
                        final isSelected = index == _selectedCategoryIndex;
                        return ElevatedButton(
                          onPressed: (){
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.onBackground
                            : AppTheme.darkSurfaceButton,
                            foregroundColor: isSelected
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.onBackground,
                            minimumSize: Size(
                            categories[index].length * 10.0 + 20,
                            40
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: isSelected ? 3 : 1,
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),

                        );
                      }
                    )
                  
                ),
            ),


            const SizedBox(height: 20),
            Container(
              width: double.infinity, 
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.all(8),

              child: Row(
              children: [
                _buildCustomIconMenuItemLibraryCreate('assets/icons/SearchLeftSiteBar.svg', false, 38, 38),
                 const SizedBox(width: 8),

                const Spacer(),
                Text('Recent'
                  ,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    
                  ),
                ),
                const SizedBox(width: 8),
                _buildCustomIconMenuItemLibraryCreate('assets/icons/MenuLeftSiteBar.svg', false, 45, 45),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: Container(
                width: double.infinity,
                
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: _isLoadingPlaylistsUser
                  ? const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        strokeWidth: 2,
                      ),
                  )
                  : ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: PlaylistsUser.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final playlists = PlaylistsUser[index];
                        return PlaylistUserCard(
                          playlists: playlists,
                          // onTap: () => _onPlaylistUserTapped(playlists),
                        );
                      }
                    )
              ),
            ),     
        ],
      ),
    );
      
  }

  

  


  Widget _buildCustomIconMenuItemLibrary(String svgPath, bool isActive, double sizeWidth, double sizeHeight, VoidCallback? onPressed) {
    return Container(
      width: sizeWidth,
      height: sizeHeight,
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
  Widget _buildCustomIconMenuItemLibraryCreate(String svgPath, bool isActive, double sizeWidth, double sizeHeight) {
    return Container(
      width: sizeWidth,
      height: sizeHeight,
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
}

class PlaylistUserCard extends StatefulWidget{
  final Map<String, dynamic> playlists;
  final VoidCallback? onTap;

  const PlaylistUserCard({
    super.key,
    required this.playlists,
    this.onTap,
  });

  @override
  State<PlaylistUserCard> createState() => _PlaylistUserCardState();
}


class _PlaylistUserCardState extends State<PlaylistUserCard> {
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
          padding: const EdgeInsets.all(8),
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: _isHovered 
              ? const Color(0xFF2A2A2A)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: double.infinity,
            // padding: EdgeInsets.all(_isHovered ? 8 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
              Stack(children: [

                
                
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.playlists['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ), 

              
                // if (_isHovered)
                //     Positioned(
                //       bottom: 8,
                //       right: 8,
                //       child: Container(
                //         width: 48,
                //         height: 48,
                //         decoration: BoxDecoration(
                //           color: const Color(0xFFE62429), 
                //           shape: BoxShape.circle,
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black.withOpacity(0.3),
                //               blurRadius: 8,
                //               offset: const Offset(0, 4),
                //             ),
                //           ],
                //         ),
                //         child: const Icon(
                //           Icons.play_arrow,
                //           color: Colors.black,
                //           size: 28,
                //         ),
                //       ),
                //     ),
                
              ],
              ),
              const SizedBox(width: 8),
                Text(
                  widget.playlists['name'],
                  style: TextStyle(
                    color: _isHovered ? Colors.white : Colors.white.withOpacity(0.95),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 4),
                // Text(
                //   widget.playlists['role'],
                //   style: TextStyle(
                //     color: Colors.grey[400],
                //     fontSize: 12,
                //   ),
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
              
            ),
          ),
        ),
      ),
    );
  }
}





