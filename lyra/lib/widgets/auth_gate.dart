import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider_v2.dart';
import '../shell/app_shell.dart';
import '../screens/welcome_screen.dart';

// Minimal CurrentUser singleton to restore user data from persistent storage.
// This fixes the undefined name error when CurrentUser is referenced.
class CurrentUser {
  CurrentUser._();
  static final CurrentUser instance = CurrentUser._();

  /// Restore user data from preferences/storage. Implement as needed.
  Future<void> restoreFromPrefs() async {
    // noop: implement actual restore logic or replace with project's CurrentUser
    await Future.delayed(Duration.zero);
  }
}

/// Auth gate - Check authentication status before showing main app
/// Prevents redirect to login on page refresh (F5)
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Restore user data from SharedPreferences first
    await CurrentUser.instance.restoreFromPrefs();

    final authProvider = context.read<AuthProviderV2>();

    // Try to restore session from saved tokens
    await authProvider.restoreSession();

    setState(() {
      _isCheckingAuth = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth
    if (_isCheckingAuth) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang kiểm tra phiên đăng nhập...'),
            ],
          ),
        ),
      );
    }

    // Watch auth state
    return Consumer<AuthProviderV2>(
      builder: (context, authProvider, _) {
        final isLoggedIn = authProvider.isLoggedIn;

        // Debug: Print auth state
        print('🔍 AuthGate check:');
        print('  - isLoggedIn: $isLoggedIn');

        // If logged in, show main app
        if (isLoggedIn) {
          print('✅ Showing main app');
          return const AppShell();
        }

        // If not logged in, show welcome/login screen
        print('↩️ Showing welcome screen');
        return const WelcomeScreen();
      },
    );
  }
}
