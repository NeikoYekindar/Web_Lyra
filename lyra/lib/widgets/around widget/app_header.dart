import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme_toggle_button.dart';
import '../../screens/theme_test_screen.dart';
import 'package:lyra/theme/app_theme.dart';
import 'app_header_controller.dart';
import 'package:provider/provider.dart';
import '../popup/ava_button.dart';
import 'package:lyra/shell/app_nav.dart';
import 'package:lyra/shell/app_routes.dart';
import 'package:lyra/shell/app_shell_controller.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onBrowseAllPressed;
  final Function(String)? onSearchChanged;

  const AppHeader({super.key, this.onBrowseAllPressed, this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    final extra = Theme.of(context).extension<AppExtraColors>();
    return Container(
      height: 70,
      // Use custom header color from ThemeExtension; fallback to background.
      color: extra?.headerAndAll ?? Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 32),

          // Logo (use the PNG asset)
          Expanded(
            flex: 2,
            child: Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/logos/Lyra.png',
                  width: 120,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Search bar (supports dashboard SVG icons and a browse toggle)
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icons/SearchLeftSideBar.svg',
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'What do you want to play?',
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/LineInHeader.svg',
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                        Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 2),
                    IconButton(
                      onPressed: () {
                        // Toggle the controller flag only; AppShell will
                        // show/hide the overlay. Avoid navigator manipulations.
                        try {
                          final shell = context.read<AppShellController>();
                          if (shell.isBrowseAllExpanded) {
                            shell.BrowseAllCollapse();
                          } else {
                            shell.BrowseAllExpand();
                          }
                        } catch (_) {
                          // ignore if controller not provided
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/Soundwave.svg',
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Right side icons
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    size: 24,
                  ),
                ),

                // Theme Toggle Button
                const ThemeToggleButton(showLabel: false, iconSize: 24),

                const SizedBox(width: 10),

                // Theme Test Button
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThemeTestScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.science,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    size: 24,
                  ),
                  tooltip: 'Test Theme',
                ),

                const SizedBox(width: 10),

                // User avatar (interactive)
                const AvatarButton(),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
