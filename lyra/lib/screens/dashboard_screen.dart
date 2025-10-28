import 'package:flutter/material.dart';
import 'package:lyra/widgets/home_center.dart';
import 'package:lyra/widgets/left_sidebar_mini.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/app_header.dart';
import '../widgets/user_profile.dart';
import '../widgets/right_sidebar.dart';
import '../widgets/music_player.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLeftSidebarExpanded = false; // State để quản lý sidebar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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