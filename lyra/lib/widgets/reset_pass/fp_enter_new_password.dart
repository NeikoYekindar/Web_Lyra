import 'package:flutter/material.dart';
import 'package:lyra/widgets/common/circle_icon_container.dart';
import 'package:lyra/widgets/common/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/widgets/welcome/welcome_login.dart';

class EnterNewPasswordScreen extends StatefulWidget {
  final String email;

  const EnterNewPasswordScreen({super.key, required this.email});

  @override
  _EnterNewPasswordScreenState createState() => _EnterNewPasswordScreenState();
}

class _EnterNewPasswordScreenState extends State<EnterNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isSuccess = false;
  late ConfettiController _confettiController;
  int _passwordScore = 0;
  String _passwordLabel = '';

  int _evaluatePassword(String p) {
    var score = 0;
    // Weight length more:
    if (p.length >= 12) {
      score += 2; // strong length bonus
    } else if (p.length >= 8) {
      score += 1;
    }

    // Digit presence
    if (RegExp(r'[0-9]').hasMatch(p)) score += 1;

    // Mixed case: require both upper and lower for the bonus
    final hasUpper = RegExp(r'[A-Z]').hasMatch(p);
    final hasLower = RegExp(r'[a-z]').hasMatch(p);
    if (hasUpper && hasLower) score += 1;

    // Symbol presence
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score += 1;

    // Map raw score into 0..4
    if (score <= 1) return 0;
    if (score == 2) return 1;
    if (score == 3) return 2;
    if (score == 4) return 3;
    return 4;
  }

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userService = ServiceLocator().userService;
      await userService.resetPassword(
        email: widget.email,
        newPassword: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
      _confettiController.play();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const WelcomeLogin(),
            ),
            (route) => false,
          );
        }
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset password: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
        elevation: 3,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40.0),
          child: Center(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _isSuccess
                        ? Container(
                            key: const ValueKey('success'),
                            width: 500,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 32.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0B8AEB), Color(0xFF22C55E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleIconContainer(
                                      size: 80,
                                      child: const Icon(
                                        Icons.celebration,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Password Reset!',
                                      style: GoogleFonts.inter(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Your password has been updated successfully. You can now login with your new password.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                                Positioned(
                                  top: 8,
                                  child: ConfettiWidget(
                                    confettiController: _confettiController,
                                    blastDirectionality:
                                        BlastDirectionality.explosive,
                                    shouldLoop: false,
                                    emissionFrequency: 0.02,
                                    numberOfParticles: 20,
                                    maxBlastForce: 20,
                                    minBlastForce: 8,
                                    colors: const [
                                      Colors.white,
                                      Colors.yellow,
                                      Colors.green,
                                      Colors.blue,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            key: const ValueKey('form'),
                            width: 500,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 32.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF121212),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleIconContainer(
                                    size: 64,
                                    child: const Icon(
                                      Icons.security,
                                      color: Color(0xFFDA0707),
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Reset Your Password',
                                    style: GoogleFonts.inter(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                        child: Icon(
                                          _obscurePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      labelText: 'New Password',
                                      labelStyle: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      hintText: 'Enter your new password',
                                      hintStyle: GoogleFonts.inter(
                                        color: const Color(0xFFB3B3B3),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF121212),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFD9D9D9),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    onChanged: (v) {
                                      final score = _evaluatePassword(v);
                                      setState(() {
                                        _passwordScore = score;
                                        if (score <= 1) {
                                          _passwordLabel = 'Weak';
                                        } else if (score == 2) {
                                          _passwordLabel = 'Fair';
                                        } else if (score == 3) {
                                          _passwordLabel = 'Good';
                                        } else {
                                          _passwordLabel = 'Strong';
                                        }
                                      });
                                    },
                                    validator: (v) =>
                                        (v == null || v.length < 8)
                                        ? 'Password must be at least 8 chars'
                                        : null,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        'Strength:',
                                        style: GoogleFonts.inter(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: PasswordStrengthIndicator(
                                          score: _passwordScore,
                                          label: _passwordLabel,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscurePassword,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                        child: Icon(
                                          _obscurePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      labelText: 'Confirm New Password',
                                      labelStyle: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      hintText: 'Re-enter your new password',
                                      hintStyle: GoogleFonts.inter(
                                        color: const Color(0xFFB3B3B3),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF121212),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFD9D9D9),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    validator: (v) =>
                                        (v != _passwordController.text)
                                        ? 'Passwords do not match'
                                        : null,
                                  ),

                                  const SizedBox(height: 32),
                                  _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : PrimaryButton(
                                          onPressed: _sendResetCode,
                                          child: Text(
                                            'SEND',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      size: 14,
                      color: Color(0xFFDA0707),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => WelcomeLogin()),
                          );
                        },

                        child: Text(
                          'Back to Login',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFDA0707),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordStrengthIndicator extends StatelessWidget {
  final int score; // 0..4
  final String label;

  const PasswordStrengthIndicator({
    super.key,
    required this.score,
    required this.label,
  });

  Color _colorForIndex(int idx) {
    if (score == 0) return Colors.red.shade400;
    if (idx >= score) return Colors.grey.shade800;
    if (score == 1) return Colors.orange.shade400;
    if (score == 2) return Colors.orange.shade300;
    if (score == 3) return Colors.yellow.shade600;
    if (score == 4) return Colors.green.shade400;
    return Colors.grey.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Expanded(
          child: Row(
            children: List.generate(4, (i) {
              final active = score > i;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(right: i < 3 ? 6.0 : 0.0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: active
                        ? _colorForIndex(i)
                        : Colors.grey.shade800.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  transform: Matrix4.diagonal3Values(
                    active ? 1.0 : 0.98,
                    1.0,
                    1.0,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
