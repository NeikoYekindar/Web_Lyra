class LeftSidebarService {
  // Giả lập API call để lấy danh sách categories
  static Future<List<String>> getCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final List<String> apiResponse = [
        'Playlists',
        'Artists',
        'Albums',
      ];
      
      return apiResponse;
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  // Giả lập API call để lấy danh sách albums
  static Future<List<String>> getAlbumImages() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final List<String> apiResponse = [
        'assets/images/album_1.png',
        'assets/images/album_2.png',
        'assets/images/album_3.png',
        'assets/images/album_3.png',
      ];
      
      return apiResponse;
    } catch (e) {
      print('Error loading albums: $e');
      return [];
    }
  }

  // Giả lập API call để lấy danh sách playlists của user
  static Future<List<Map<String, dynamic>>> getPlaylistsUser() async {
    try {
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
          'id': '4',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '5', 
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '6', 
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '7',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '8', 
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '9', 
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '10',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '11', 
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '12', 
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '13',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '14', 
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '15', 
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
        {
          'id': '16',
          'name': 'KhongBuon_PL',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/khongbuon.png',
        },
        {
          'id': '17', 
          'name': 'EM XIN "SAY HI" 2025',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/emxinsayhi_2025.png',
        },
        {
          'id': '18', 
          'name': 'Playlist Sơn Tùng M-TP',
          'type': 'Playlist',
          'owner': 'TrumUIT',
          'image': 'assets/images/playlist_mtp.png',
        },
      ];
      
      return apiResponse;
    } catch (e) {
      print('Error loading playlists user: $e');
      return [];
    }
  }
}
