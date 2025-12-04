import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lyra/providers/auth_provider.dart';
import 'package:lyra/screens/dashboard_screen.dart';

/// LoginController: tách toàn bộ logic ra khỏi file UI.
class LoginController extends ChangeNotifier {
  // State
  bool obscurePassword = true;
  bool rememberMe = false;

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Toggle hiển thị / ẩn mật khẩu
  void toggleObscure() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  /// Toggle "Remember me"
  void toggleRemember(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  /// Thực hiện login qua AuthProvider
  Future<void> submit(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack(context, 'Please enter email and password');
      return;
    }

    final ok = await auth.login(email, password);
    if (ok && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (context.mounted) {
      final msg = auth.error ?? 'Login failed';
      _showSnack(context, msg);
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
