import 'package:flutter/material.dart';
import 'package:lyra/widgets/center widget/lyric_wid.dart';
import 'package:provider/provider.dart';
import 'package:lyra/widgets/around widget/left_sidebar_mini.dart';
import '../widgets/around widget/left_sidebar.dart';
import '../widgets/around widget/app_header.dart';
import '../widgets/around widget/music_player.dart';
// dashboard controller logic moved into AppShellController
import '../widgets/around widget/right_sidebar.dart' as dashboard_right;
import '../widgets/around widget/right_sidebar_detail_song.dart'
    as dashboard_right_detail;
// Removed unused imports user_profile.dart, right_sidebar.dart, welcome_intro.dart
import '../providers/music_player_provider.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/shell/app_center_navigator.dart';
import 'package:lyra/widgets/around widget/browse_all.dart';
// removed duplicate dashboard_controller import
import 'package:lyra/shell/app_shell_controller.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isLeftSidebarExpanded = false; // State để quản lý sidebar
  // Overlay-only mode; controllers are read directly where needed.
  @override
  void initState() {
    super.initState();
    // Post-frame to ensure provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicPlayerProvider>().restoreLastTrack();
      // Wire up listeners after first frame when providers should be available
      // Providers are accessed directly where needed; no local fields kept.

      // Using overlay-only approach — controller flags control overlays.
      // The AppCenterNavigator observer handles sync between routes and controllers.
    });
  }

  @override
  void dispose() {
    // No listeners to remove in overlay-only mode.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showLyrics = context.watch<AppShellController>().showLyrics;
    final track = context.watch<MusicPlayerProvider>().currentTrack;
    final extra = Theme.of(context).extension<AppExtraColors>();
    return Scaffold(
      backgroundColor:
          extra?.headerAndAll ?? Theme.of(context).colorScheme.onTertiary,
      body: Column(
        children: [
          // Header
          const AppHeader(),
          // Main content
          Flexible(
            child: Row(
              children: [
                // Left Sidebar - chuyển đổi giữa Mini và Full
                _isLeftSidebarExpanded
                    ? Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: LeftSidebar(
                          onCollapsePressed: () {
                            setState(() {
                              _isLeftSidebarExpanded = false;
                            });
                          },
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: LeftSidebarMini(
                          onLibraryIconPressed: () {
                            setState(() {
                              _isLeftSidebarExpanded = true;
                            });
                          },
                        ),
                      ),
                // Main Content Area
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Stack(
                      children: [
                        // Always keep the nested navigator active so navigation works
                        const AppCenterNavigator(),

                        // Overlays on top of the navigator: Lyrics and BrowseAll.
                        // They don't replace the navigator; they just visually overlay it.
                        Builder(
                          builder: (ctx) {
                            final shell = ctx.watch<AppShellController?>();
                            final showBrowse =
                                shell?.isBrowseAllExpanded ?? false;
                            if (showLyrics && track != null) {
                              return Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Theme.of(ctx).colorScheme.surface,
                                  ),
                                  child: const ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                    child: LyricWidget(),
                                  ),
                                ),
                              );
                            }
                            return showBrowse
                                ? const Positioned.fill(
                                    child: BrowseAllCenter(),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Sidebar — only present when dashboard requests it.
                // When present we provide a fixed width which naturally shrinks the middle column.
                Builder(
                  builder: (ctx) {
                    AppShellController? shell;
                    try {
                      shell = ctx.watch<AppShellController>();
                    } catch (_) {
                      shell = null;
                    }

                    final bool showDetail =
                        shell?.isRightSidebarDetail ?? false;

                    // Animate the sidebar width explicitly to avoid complex layer
                    // transitions that can trigger rendering assertions.
                    final double targetWidth = showDetail ? 360.0 : 0.0;
                    return ClipRect(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: targetWidth,
                        curve: Curves.easeInOut,
                        child: targetWidth > 0
                            ? Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child:
                                    dashboard_right_detail.RightSidebarDetailSong(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Music Player at bottom
          const MusicPlayer(),
        ],
      ),
    );
  }
}
