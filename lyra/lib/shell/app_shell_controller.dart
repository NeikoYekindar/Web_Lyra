import 'package:flutter/material.dart';

class AppShellController extends ChangeNotifier {
  // Lyrics overlay
  bool _showLyrics = false;
  bool get showLyrics => _showLyrics;
  void toggleLyrics() {
    _showLyrics = !_showLyrics;
    notifyListeners();
  }

  void closeLyrics() {
    _showLyrics = false;
    notifyListeners();
  }

  // Maximize player overlay
  bool _showMaximizedPlayer = false;
  bool get showMaximizedPlayer => _showMaximizedPlayer;
  void toggleMaximizedPlayer() {
    _showMaximizedPlayer = !_showMaximizedPlayer;
    notifyListeners();
  }

  void closeMaximizedPlayer() {
    _showMaximizedPlayer = false;
    notifyListeners();
  }

  // Queue overlay
  bool _showQueue = false;
  bool get showQueue => _showQueue;
  void toggleQueue() {
    _showQueue = !_showQueue;
    notifyListeners();
  }

  void openQueue() {
    if (!_showQueue) {
      _showQueue = true;
      notifyListeners();
    }
  }

  void closeQueue() {
    _showQueue = false;
    notifyListeners();
  }

  // --- Dashboard state moved here ---
  bool _isLeftSidebarExpanded = false;
  bool _isRightSidebarDetail = false;
  bool get isRightSidebarDetail => _isRightSidebarDetail;
  bool get isLeftSidebarExpanded => _isLeftSidebarExpanded;

  final bool _isPlayerMaximized = false;
  bool get isPlayerMaximized => _isPlayerMaximized;

  bool _isBrowseAllExpanded = false;
  bool get isBrowseAllExpanded => _isBrowseAllExpanded;

  bool _isSearchActive = false;
  bool get isSearchActive => _isSearchActive;

  String searchText = '';

  void toggleSidebar() {
    _isLeftSidebarExpanded = !_isLeftSidebarExpanded;
    notifyListeners();
  }

  void expandSidebar() {
    if (!_isLeftSidebarExpanded) {
      _isLeftSidebarExpanded = true;
      notifyListeners();
    }
  }

  void collapseSidebar() {
    if (_isLeftSidebarExpanded) {
      _isLeftSidebarExpanded = false;
      notifyListeners();
    }
  }

  void openNowPlayingDetail() {
    if (!_isRightSidebarDetail) {
      _isRightSidebarDetail = true;
      notifyListeners();
    }
  }

  void closeNowPlayingDetail() {
    if (_isRightSidebarDetail) {
      _isRightSidebarDetail = false;
      notifyListeners();
    }
  }

  void toggleMaximizePlayer() {
    _showMaximizedPlayer = !_showMaximizedPlayer;
    notifyListeners();
  }

  void minimizePlayer() {
    if (_showMaximizedPlayer) {
      _showMaximizedPlayer = false;
      notifyListeners();
    }
  }

  void BrowseAllExpand() {
    if (!_isBrowseAllExpanded) {
      _isBrowseAllExpanded = true;
      notifyListeners();
    }
  }

  void BrowseAllCollapse() {
    if (_isBrowseAllExpanded) {
      _isBrowseAllExpanded = false;
      notifyListeners();
    }
  }

  void updateSearchText(String text) {
    searchText = text;
    notifyListeners();
  }

  bool get isSearchingText => searchText.isNotEmpty;

  void openSearch(String query) {
    print('=== AppShellController.openSearch ===');
    print('Received query: "$query"');
    searchText = query;
    _isSearchActive = true;
    print('searchText set to: "$searchText"');
    print('isSearchActive: $_isSearchActive');
    print('====================================');
    notifyListeners();
  }

  void closeSearch() {
    _isSearchActive = false;
    searchText = '';
    notifyListeners();
  }

  // Center content overlay (for album/playlist detail, etc.)
  Widget? _centerContentWidget;
  Widget? get centerContentWidget => _centerContentWidget;

  void showCenterContent(Widget content) {
    _centerContentWidget = content;
    notifyListeners();
  }

  void closeCenterContent() {
    _centerContentWidget = null;
    notifyListeners();
  }

  // Saved artists and albums lists (for left sidebar)
  final List<Map<String, dynamic>> _savedArtists = [];
  final List<Map<String, dynamic>> _savedAlbums = [];
  
  List<Map<String, dynamic>> get savedArtists => List.unmodifiable(_savedArtists);
  List<Map<String, dynamic>> get savedAlbums => List.unmodifiable(_savedAlbums);

  void addArtist(Map<String, dynamic> artist) {
    // Check if already exists
    final artistId = artist['artist_id'] ?? artist['id'] ?? '';
    final exists = _savedArtists.any((a) => 
        (a['artist_id'] ?? a['id']) == artistId);
    if (!exists && artistId.isNotEmpty) {
      _savedArtists.add(artist);
      notifyListeners();
    }
  }

  void removeArtist(String artistId) {
    _savedArtists.removeWhere((a) => 
        (a['artist_id'] ?? a['id']) == artistId);
    notifyListeners();
  }

  void addAlbum(Map<String, dynamic> album) {
    // Check if already exists
    final albumId = album['album_id'] ?? album['id'] ?? '';
    final exists = _savedAlbums.any((a) => 
        (a['album_id'] ?? a['id']) == albumId);
    if (!exists && albumId.isNotEmpty) {
      _savedAlbums.add(album);
      notifyListeners();
    }
  }

  void removeAlbum(String albumId) {
    _savedAlbums.removeWhere((a) => 
        (a['album_id'] ?? a['id']) == albumId);
    notifyListeners();
  }

  /// Called after first frame to load initial data.
  void init(BuildContext context) {
    // No longer loading demo track - will restore last played track instead
  }
}
