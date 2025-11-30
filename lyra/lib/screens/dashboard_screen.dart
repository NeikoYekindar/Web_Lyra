import 'package:flutter/material.dart';
import 'package:lyra/widgets/dashboard/right_sidebar.dart';
import 'package:provider/provider.dart';
import 'package:lyra/widgets/dashboard/home_center.dart';
import 'package:lyra/widgets/dashboard/left_sidebar_mini.dart';
import '../widgets/dashboard/left_sidebar.dart';
import '../widgets/dashboard/app_header.dart';
import '../widgets/dashboard/music_player.dart';
import 'package:lyra/theme/app_theme.dart';
import 'dashboard/dashboard_controller.dart';
import 'package:lyra/services/now_playing_service.dart';
import 'package:lyra/providers/auth_provider.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:lyra/widgets/dashboard/right_sidebar_detail_song.dart';

/// DashboardScreen chỉ lo phần dựng UI, logic state nằm ở DashboardController.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardController>(
      create: (ctx) {
        final controller = DashboardController();
        // Post-frame init (tương đương initState cũ)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.init(ctx);
          // Fetch now-playing and set into MusicPlayerProvider
          final auth = ctx.read<AuthProvider>();
          final player = ctx.read<MusicPlayerProvider>();
          final service = NowPlayingService(baseUrl: auth.baseUrl);
          player.loadNowPlaying(() => service.fetchNowPlaying());
        });
        return controller;
      },
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final extra = Theme.of(context).extension<AppExtraColors>();
    final controller = context.watch<DashboardController>();
    return Scaffold(
      backgroundColor: extra?.headerAndAll ?? Theme.of(context).colorScheme.onTertiary,
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Row(
              children: [
                controller.isLeftSidebarExpanded
                    ? LeftSidebar(
                        onCollapsePressed: controller.collapseSidebar,
                      )
                    : LeftSidebarMini(
                        onLibraryIconPressed: controller.expandSidebar,
                      ),
                Expanded(
                  flex: 2,
                  child: const HomeCenter(),
                ),
                // Có thể thêm RightSidebar ở đây nếu cần
                controller.isRightSidebarDetail ?
                  const RightSidebarDetailSong()
                  : const RightSidebar(),

              ],
            ),
          ),
          const MusicPlayer(),
        ],
      ),
    );
  }
}
