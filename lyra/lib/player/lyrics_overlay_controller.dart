import 'package:flutter/material.dart';
import 'lyrics_overlay.dart';

class LyricsOverlayController {
  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  static void toggle(BuildContext context) {
    if (isShowing) {
      hide();
    } else {
      show(context);
    }
  }

  static void show(BuildContext context) {
    if (_entry != null) return;

    _entry = OverlayEntry(builder: (_) => const LyricsOverlay());

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
