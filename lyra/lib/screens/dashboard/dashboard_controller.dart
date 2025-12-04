import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';

/// Controller / Logic holder for DashboardScreen
/// Tách phần state & logic ra khỏi file UI.
class DashboardController extends ChangeNotifier {
  bool _isLeftSidebarExpanded = false;
  bool _isRightSidebarDetail= false;
  bool get isRightSidebarDetail => _isRightSidebarDetail;
  bool get isLeftSidebarExpanded => _isLeftSidebarExpanded;

  /// Toggle sidebar expand/collapse
  void toggleSidebar() {
    _isLeftSidebarExpanded = !_isLeftSidebarExpanded;
    notifyListeners();
  }

  /// Explicit actions for collapsing / expanding (nếu muốn rõ ràng hơn)
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
    if (!_isRightSidebarDetail){
      _isRightSidebarDetail = true;
      notifyListeners();

    }
  }
  void closeNowPlayingDetail() {
    if (_isRightSidebarDetail){
      _isRightSidebarDetail = false;
      notifyListeners();

    }
  }

  /// Called after first frame to load initial data.
  void init(BuildContext context) {
    // Load demo track from music player provider (giữ giống logic cũ)
    context.read<MusicPlayerProvider>().loadDemoTrack();
  }
}
