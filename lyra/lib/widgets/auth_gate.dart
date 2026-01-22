import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider_v2.dart';
import '../shell/app_shell.dart';
import '../screens/welcome_screen.dart';

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
        // If logged in, show main app
        if (authProvider.isLoggedIn) {
          return const AppShell();
        }

        // If not logged in, show welcome/login screen
        return const WelcomeScreen();
      },
    );
  }
}
