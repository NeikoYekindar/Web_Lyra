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
import 'package:lyra/widgets/dashboard/maximise_music_playing.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:lyra/widgets/dashboard/right_sidebar_detail_song.dart';
import 'package:lyra/widgets/dashboard/browse_all.dart';
import 'package:lyra/widgets/dashboard/search_result_center.dart';

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
          AppHeader(
            onSearchChanged: (text) {
              controller.updateSearchText(text);
            },
          ),
          Expanded(
            // Dùng AnimatedSwitcher để chuyển đổi mượt mà (Fade effect)
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.isPlayerMaximized
                  ? MaximiseMusicPlaying(
                      // Truyền hàm đóng vào widget con
                      onClose: controller.minimizePlayer, 
                      key: const ValueKey('MaximiseView'), // Key giúp Animation nhận diện
                    )
                  : Row(
                      key: const ValueKey('NormalView'), // Key giúp Animation nhận diện
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
                          child: Builder(
                            builder: (context) {
                              // Ưu tiên 1: Đang tìm kiếm -> Hiện Search Result
                              if (controller.searchText.isNotEmpty) {
                                return const SearchResultCenter(key: ValueKey('SearchResult'));
                              }
                              // Ưu tiên 2: Đang ở chế độ Browse -> Hiện Browse All
                              else if (controller.isBrowseAllExpanded) {
                                return const BrowseAllCenter(key: ValueKey('BrowseAll'));
                              }
                              // Mặc định: Hiện Home
                              else {
                                return const HomeCenter(key: ValueKey('Home'));
                              }
                            },
                          ),
                        ),
                        controller.isRightSidebarDetail
                            ? const RightSidebarDetailSong()
                            : const RightSidebar(),
                      ],
                    ),
            ),
          ),
          // Expanded(
          //   child: const BrowseAllCenter(),
          // ),
          
          const MusicPlayer(),
        ],
      ),
    );
  }
}
