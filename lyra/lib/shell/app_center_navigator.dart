import 'package:flutter/material.dart';
import 'package:lyra/shell/app_nav.dart';
import 'package:lyra/shell/app_routes.dart';

class AppCenterNavigator extends StatelessWidget {
  const AppCenterNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: AppNav.key,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppNav.onGenerateRoute,
    );
  }
}
