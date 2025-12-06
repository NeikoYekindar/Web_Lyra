import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../services/left_sidebar_service.dart';
import 'right_sidebar_detail_song.dart';
import '/screens/dashboard/dashboard_controller.dart';

class AppHeaderController {


  void toggleBrowserAll(BuildContext context){
    final dashboard = Provider.of<DashboardController>(context, listen: false);
    if (dashboard.isBrowseAllExpanded){
      dashboard.BrowseAllCollapse();
    } else {
      dashboard.BrowseAllExpand();
    }
  }




}
