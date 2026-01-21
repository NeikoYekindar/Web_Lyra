import 'package:flutter/material.dart';

/// Controller to manage RightSidebar logic & events (hover, actions)
class RightSidebarController extends ChangeNotifier {
  bool _nowPlayingHovered = false;
  bool get nowPlayingHovered => _nowPlayingHovered;

  void setNowPlayingHover(bool hovered) {
    if (_nowPlayingHovered != hovered) {
      _nowPlayingHovered = hovered;
      notifyListeners();
    }
  }

  void onMorePressed() {
    // TODO: open more menu or actions
  }

  void onClosePressed() {
    // TODO: close sidebar or trigger a callback via higher-level controller
  }

  bool isLoadingNextPlaylist = false;
  List<Map<String, dynamic>> playlistsUser = [];

  void setPlaylists(List<Map<String, dynamic>> playlists) {
    playlistsUser = playlists;
    isLoadingNextPlaylist = false;
    notifyListeners();
  }

  Future<void> fetchUserPlaylists(
    Future<List<Map<String, dynamic>>> Function() fetcher,
  ) async {
    isLoadingNextPlaylist = true;
    notifyListeners();
    try {
      final data = await fetcher();
      playlistsUser = data;
    } catch (e) {
      // Handle error: could integrate a toast or logger
      playlistsUser = [];
    } finally {
      isLoadingNextPlaylist = false;
      notifyListeners();
    }
  }

  void onPlaylistUserTapped(Map<String, dynamic> playlist) {
    // TODO: navigate to playlist or start play
  }
}
