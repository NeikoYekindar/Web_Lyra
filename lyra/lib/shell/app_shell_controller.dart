import 'package:flutter/foundation.dart';

class AppShellController extends ChangeNotifier {
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
}
