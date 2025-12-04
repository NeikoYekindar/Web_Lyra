import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lyra/widgets/common/circle_icon_container.dart';
import 'package:lyra/widgets/common/custom_button.dart';
import 'package:lyra/widgets/reset_pass/fp_enter_new_password.dart';

class WelcomeVerifyEmail extends StatefulWidget {
  final String? initialEmail;

  WelcomeVerifyEmail({Key? key, this.initialEmail}) : super(key: key);

  @override
  _WelcomeVerifyEmailScreenState createState() =>
      _WelcomeVerifyEmailScreenState();
}

class _WelcomeVerifyEmailScreenState extends State<WelcomeVerifyEmail> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _resendSecondsLeft = 0;
  Timer? _resendTimer;
  List<TextEditingController> _codeControllers = [];
  List<FocusNode> _codeFocusNodes = [];
  bool _suppressOnChanged = false;
  bool _isCodeComplete = false;

  Future<bool> _sendVerificationEmail() async {
    if (!_formKey.currentState!.validate()) return false;

    setState(() {
      _isLoading = true;
    });

    try {
      // await Provider.of<AuthProvider>(context, listen: false)
      //     .sendEmailVerification(_emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email sent. Please check your inbox.'),
        ),
      );
      // mock verification: accept code '123456'
      final entered = _codeControllers.map((c) => c.text.trim()).join();
      if (entered == '123456') {
        return true;
      } else {
        // For mock, show error if code incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid code (mock). Try 123456 for testing.'),
          ),
        );
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email. Please try again.'),
        ),
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startResendCountdown([int seconds = 60]) {
    _resendTimer?.cancel();
    setState(() {
      _resendSecondsLeft = seconds;
    });

    // persist expiry to SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      final expiry = DateTime.now()
          .add(Duration(seconds: seconds))
          .millisecondsSinceEpoch;
      prefs.setInt('resend_expiry', expiry);
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() {
        if (_resendSecondsLeft > 0) {
          _resendSecondsLeft--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(6, (_) => TextEditingController());
    _codeFocusNodes = List.generate(6, (_) => FocusNode());
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
    }

    // restore resend timer if saved
    SharedPreferences.getInstance().then((prefs) {
      final expiry = prefs.getInt('resend_expiry');
      if (expiry != null) {
        final left = ((expiry - DateTime.now().millisecondsSinceEpoch) / 1000)
            .ceil();
        if (left > 0) {
          _startResendCountdown(left);
        }
      }
    });

    // watch code controllers for completeness
    for (final c in _codeControllers) {
      c.addListener(_updateCodeComplete);
    }
  }

  void _updateCodeComplete() {
    final complete = _codeControllers.every((c) => c.text.trim().isNotEmpty);
    if (complete != _isCodeComplete) setState(() => _isCodeComplete = complete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A), // hoặc Color(0xFF0A0A0A)
        foregroundColor: Colors.white, // text/icon color
        elevation: 3,
        leading: BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Container(
                width: 500,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 32.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(10),
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
                        size: 80,
                        child: Icon(
                          Icons.email,
                          color: const Color(0xFFDA0707),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Verify Your Email',
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We sent a verification code to your email. Please enter your inbox and fill it into boxes below.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFFB3B3B3),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Didn\'t receive the email? Check your spam folder.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFFB3B3B3),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Verification code inputs - one digit per box, numeric only, auto-advance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 60,
                            height: 60,
                            child: TextFormField(
                              controller: _codeControllers[index],
                              focusNode: _codeFocusNodes[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 36,
                                height: 1.0,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFFDA0707),
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                if (_suppressOnChanged) return;

                                // If user pasted multiple characters, distribute them into fields
                                // but do NOT change focus (no auto-advance).
                                if (val.length > 1) {
                                  final chars = val
                                      .replaceAll(RegExp(r'[^0-9]'), '')
                                      .split('');
                                  _suppressOnChanged = true;
                                  for (
                                    int i = 0;
                                    i < chars.length &&
                                        (index + i) < _codeControllers.length;
                                    i++
                                  ) {
                                    _codeControllers[index + i].text = chars[i];
                                  }
                                  Future.microtask(
                                    () => _suppressOnChanged = false,
                                  );
                                  return;
                                }

                                // Do not auto-advance or move focus on single digit input or backspace.
                                // Leave focus management to the user.
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 40),

                      // Action buttons
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlineButtonCustom(
                            onPressed: _resendSecondsLeft == 0 && !_isLoading
                                ? () async {
                                    // Trigger resend action here (call provider API if implemented)
                                    // For now we show a snackbar and start countdown
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Resend code requested'),
                                      ),
                                    );
                                    _startResendCountdown(60);
                                  }
                                : null,
                            child: Text(
                              _resendSecondsLeft > 0
                                  ? 'RESEND CODE IN - ${_resendSecondsLeft}s'
                                  : 'RESEND CODE',
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : PrimaryButton(
                                  onPressed: !_isCodeComplete || _isLoading
                                      ? null
                                      : () async {
                                          final ok =
                                              await _sendVerificationEmail();
                                          if (ok && mounted) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const EnterNewPasswordScreen(),
                                              ),
                                            );
                                          }
                                        },

                                  child: Text(
                                    'VERIFY EMAIL',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14,
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _emailController.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _codeFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}
