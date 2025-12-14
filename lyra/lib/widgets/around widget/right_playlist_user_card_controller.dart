import 'package:flutter/material.dart';

class RightPlaylistUserCardController extends ChangeNotifier {
  bool _isHovered = false;
  bool get isHovered => _isHovered;

  void setHovered(bool hovered) {
    if (_isHovered != hovered) {
      _isHovered = hovered;
      notifyListeners();
    }
  }

    void onMorePressed() {
    // TODO: open more menu or actions
  }
}