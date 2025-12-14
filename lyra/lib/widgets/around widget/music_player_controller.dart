import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../services/left_sidebar_service.dart';
import 'right_sidebar_detail_song.dart';
import '../../shell/app_shell_controller.dart';

class MusicPlayerController {
  void toggleNowPlayingDetail(BuildContext context) {
    final shell = Provider.of<AppShellController>(context, listen: false);
    if (shell.isRightSidebarDetail) {
      shell.closeNowPlayingDetail();
    } else {
      shell.openNowPlayingDetail();
    }
  }

  void openNowPlayingDetail(BuildContext context) {
    final player = Provider.of<MusicPlayerProvider>(context, listen: false);
    final track = player.currentTrack;

    Provider.of<AppShellController>(
      context,
      listen: false,
    ).openNowPlayingDetail();
  }
}
