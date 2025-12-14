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

  // --- Dashboard state moved here ---
  bool _isLeftSidebarExpanded = false;
  bool _isRightSidebarDetail = false;
  bool get isRightSidebarDetail => _isRightSidebarDetail;
  bool get isLeftSidebarExpanded => _isLeftSidebarExpanded;

  bool _isPlayerMaximized = false;
  bool get isPlayerMaximized => _isPlayerMaximized;

  bool _isBrowseAllExpanded = false;
  bool get isBrowseAllExpanded => _isBrowseAllExpanded;

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
    _isPlayerMaximized = !_isPlayerMaximized;
    notifyListeners();
  }

  void minimizePlayer() {
    if (_isPlayerMaximized) {
      _isPlayerMaximized = false;
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

  /// Called after first frame to load initial data.
  void init(BuildContext context) {
    context.read<MusicPlayerProvider>().loadDemoTrack();
  }
}
