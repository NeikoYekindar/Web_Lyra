import 'package:flutter/material.dart';

// routes
import 'package:lyra/shell/app_routes.dart';

// models
import 'package:lyra/models/artist.dart';

// center screens / widgets
import 'package:lyra/screens/dashboard_screen.dart';
import 'package:lyra/screens/profile_screen.dart';
import 'package:lyra/screens/settings_screen.dart';
import 'package:lyra/widgets/around%20widget/browse_all.dart';
import 'package:lyra/widgets/center%20widget/lyric_wid.dart';
import 'package:lyra/screens/artist_screen.dart';

class AppNav {
  /// Navigator key cho CENTER (nested navigator)
  /// Use a getter to ensure a consistent key reference
  static GlobalKey<NavigatorState>? _key;
  static GlobalKey<NavigatorState> get key {
    _key ??= GlobalKey<NavigatorState>();
    return _key!;
  }

  /// Route generator cho CENTER
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // =========================
      // DASHBOARD / HOME
      // =========================
      case AppRoutes.home:
      case AppRoutes.account: // 🔁 ACCOUNT → DASHBOARD
        return _page(const DashboardScreen());

      // =========================
      // PROFILE
      // =========================
      case AppRoutes.profile:
        return _page(const ProfileScreen());

      // =========================
      // SETTINGS
      // =========================
      case AppRoutes.settings:
        return _page(const SettingsScreen());

      // =========================
      // BROWSE ALL
      // =========================
      case AppRoutes.browseAll:
        return _page(const BrowseAllCenter());

      // =========================
      // LYRICS (LYRIC OVERLAY)
      // =========================
      case AppRoutes.lyrics:
        return _page(const LyricWidget());
      case AppRoutes.artist:
        final artist = settings.arguments as Artist;
        return _page(ArtistScreen(artist: artist));
      // =========================
      // FALLBACK
      // =========================
      default:
        return _page(const DashboardScreen());
    }
  }

  /// Helper tạo MaterialPageRoute
  static PageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  // =============================================================
  // TIỆN ÍCH GỌI NAVIGATION
  // =============================================================

  static void go(String route) {
    key.currentState?.pushNamed(route);
  }

  static void replace(String route) {
    key.currentState?.pushReplacementNamed(route);
  }

  static void pop() {
    key.currentState?.pop();
  }
}
