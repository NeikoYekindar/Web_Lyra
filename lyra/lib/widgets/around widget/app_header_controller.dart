import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../services/left_sidebar_service.dart';
import 'right_sidebar_detail_song.dart';
import '../../shell/app_shell_controller.dart';

class AppHeaderController {
  void toggleBrowserAll(BuildContext context) {
    final shell = Provider.of<AppShellController>(context, listen: false);
    if (shell.isBrowseAllExpanded) {
      shell.BrowseAllCollapse();
    } else {
      shell.BrowseAllExpand();
    }
  }
}
