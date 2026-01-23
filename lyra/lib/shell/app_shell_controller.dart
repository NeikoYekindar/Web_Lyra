import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_player_provider.dart';

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

  bool _isPlayerMaximized = false;
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

  /// Called after first frame to load initial data.
  void init(BuildContext context) {
    // No longer loading demo track - will restore last played track instead
  }
}
