import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lyra/widgets/home_center.dart';
import 'package:lyra/widgets/left_sidebar_mini.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/app_header.dart';
import '../widgets/music_player.dart';
// Removed unused imports user_profile.dart, right_sidebar.dart, welcome_intro.dart
import '../providers/music_player_provider.dart';
import 'package:lyra/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLeftSidebarExpanded = false; // State để quản lý sidebar

  @override
  void initState() {
    super.initState();
    // Post-frame to ensure provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicPlayerProvider>().loadDemoTrack();
    });
  }

  @override
  Widget build(BuildContext context) {
      final extra = Theme.of(context).extension<AppExtraColors>();
    return Scaffold(
      backgroundColor: extra?.headerAndAll ?? Theme.of(context).colorScheme.onTertiary,
      body: Column(
        children: [
          // Header
          const AppHeader(),
          // Main content
          Expanded(
            child: Row(
              children: [
                // Left Sidebar - chuyển đổi giữa Mini và Full
                _isLeftSidebarExpanded
                  ? LeftSidebar(
                      onCollapsePressed: () {
                        setState(() {
                          _isLeftSidebarExpanded = false;
                        });
                      },
                    )
                  : LeftSidebarMini(
                      onLibraryIconPressed: () {
                        setState(() {
                          _isLeftSidebarExpanded = true;
                        });
                      },
                    ),
                // Main Content Area
                // Expanded(
                //   flex: 2,
                //   child: Container(
                //     color: const Color(0xFF121212),
                //     child: const UserProfile(),
                //   ),
                // ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: const HomeCenter(),
                  ),
                ),

                // Right Sidebar
                // const RightSidebar(),
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