import 'package:flutter/material.dart';
import 'package:lyra/widgets/center%20widget/lyric_wid.dart';
import 'lyrics_overlay_controller.dart';

class LyricsOverlay extends StatelessWidget {
  const LyricsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.92),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(onTap: LyricsOverlayController.hide),
          ),
          const Center(child: LyricWidget()),
        ],
      ),
    );
  }
}
