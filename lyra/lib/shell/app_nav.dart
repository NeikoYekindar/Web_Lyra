import 'package:flutter/material.dart';

// routes
import 'package:lyra/shell/app_routes.dart';

// center screens / widgets
import 'package:lyra/screens/dashboard_screen.dart';
import 'package:lyra/screens/profile_screen.dart';
import 'package:lyra/widgets/center%20widget/settings.dart';
import 'package:lyra/widgets/around%20widget/browse_all.dart';
import 'package:lyra/widgets/center%20widget/lyric_wid.dart';

class AppNav {
  /// Navigator key cho CENTER (nested navigator)
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

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
        return _page(const SettingsWid());

      // =========================
      // SUPPORT (NẾU CÓ)
      // =========================
      case AppRoutes.support:
        return _page(const DashboardScreen()); // hoặc SupportScreen nếu có

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
