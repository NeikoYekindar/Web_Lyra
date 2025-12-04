import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/music_player_provider.dart';
import '../../services/left_sidebar_service.dart';
import 'right_sidebar_detail_song.dart';
import '/screens/dashboard/dashboard_controller.dart';

class MusicPlayerController {


  void toggleNowPlayingDetail(BuildContext context){
    final dashboard = Provider.of<DashboardController>(context, listen: false);
    if (dashboard.isRightSidebarDetail){
      dashboard.closeNowPlayingDetail();
    } else {
      dashboard.openNowPlayingDetail();
    }
  }


  void openNowPlayingDetail(BuildContext context) {
    final player = Provider.of<MusicPlayerProvider>(context, listen: false);
    final track = player.currentTrack;


    Provider.of<DashboardController>(context, listen: false).openNowPlayingDetail();
      
  }



}


  