import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lyra/shell/app_nav.dart';
import 'package:lyra/shell/app_routes.dart';
import 'package:lyra/shell/app_shell_controller.dart';

class AppCenterNavigator extends StatefulWidget {
  const AppCenterNavigator({super.key});

  @override
  State<AppCenterNavigator> createState() => _AppCenterNavigatorState();
}

class _AppCenterNavigatorState extends State<AppCenterNavigator> {
  late final _observer = _CenterRouteObserver();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: AppNav.key,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppNav.onGenerateRoute,
      observers: [_observer],
    );
  }
}

class _CenterRouteObserver extends NavigatorObserver {
  void _syncToRoute(Route<dynamic>? route) {
    final name = route?.settings.name;
    final navCtx = navigator?.context;
    if (navCtx == null) return;

    // Always close maximize player when navigating to any route
    // This ensures navigation works even when maximize player is open
    try {
      final shell = Provider.of<AppShellController>(navCtx, listen: false);
      if (shell.showMaximizedPlayer) {
        shell.minimizePlayer();
      }
    } catch (_) {}

    try {
      final shell = Provider.of<AppShellController>(navCtx, listen: false);
      if (name == AppRoutes.lyrics) {
        if (!shell.showLyrics) shell.toggleLyrics();
      } else {
        if (shell.showLyrics) shell.closeLyrics();
      }
    } catch (_) {}

    try {
      final shell = Provider.of<AppShellController>(navCtx, listen: false);
      if (name == AppRoutes.browseAll) {
        if (!shell.isBrowseAllExpanded) shell.BrowseAllExpand();
      } else {
        if (shell.isBrowseAllExpanded) shell.BrowseAllCollapse();
      }
    } catch (_) {}

    try {
      final shell = Provider.of<AppShellController>(navCtx, listen: false);
      if (name == AppRoutes.search) {
        if (!shell.isSearchActive) shell.openSearch(shell.searchText);
      } else {
        if (shell.isSearchActive) shell.closeSearch();
      }
    } catch (_) {}
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _syncToRoute(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _syncToRoute(newRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _syncToRoute(previousRoute);
  }
}
