import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lyra/widgets/common/circle_icon_container.dart';
import 'package:lyra/widgets/common/custom_button.dart';
import 'package:lyra/widgets/welcome/welcome_create_profile.dart';
import 'package:lyra/models/current_user.dart';

class WelcomeVerifyEmail extends StatefulWidget {
  final String? initialEmail;
  final VoidCallback? onBackPressed;
  final String? createdUserId;

  WelcomeVerifyEmail({
    Key? key,
    this.initialEmail,
    this.onBackPressed,
    this.createdUserId,
  }) : super(key: key);

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
      final code = _codeControllers.map((c) => c.text.trim()).join();
      if (code.length != 6) {
        throw Exception('Please enter all 6 digits');
      }

      final userService = ServiceLocator().userService;
      final email = widget.initialEmail ?? _emailController.text.trim();

      await userService.verifyOtp(email: email, otp: code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return true;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

      // Auto-send OTP when screen loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendInitialOtp();
      });
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

  Future<void> _sendInitialOtp() async {
    try {
      setState(() => _isLoading = true);
      final userService = ServiceLocator().userService;
      final email = widget.initialEmail ?? _emailController.text.trim();

      await userService.sendVerifyEmail(email);

      if (mounted) {
        _startResendCountdown(60);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to $email'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send code: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBackPressed ?? () => Navigator.maybePop(context),
        ),
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
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (event) {
                                if (event is RawKeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.backspace &&
                                    _codeControllers[index].text.isEmpty &&
                                    index > 0) {
                                  _codeFocusNodes[index - 1].requestFocus();
                                  _codeControllers[index - 1].clear();
                                }
                              },
                              child: TextFormField(
                                controller: _codeControllers[index],
                                focusNode: _codeFocusNodes[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 36,
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: '',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFDA0707),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length > 1) {
                                    final digits = value
                                        .replaceAll(RegExp(r'\D'), '')
                                        .split('');
                                    for (
                                      int i = 0;
                                      i < digits.length && i < 6;
                                      i++
                                    ) {
                                      _codeControllers[i].text = digits[i];
                                    }
                                    _codeFocusNodes.last.requestFocus();
                                    return;
                                  }

                                  if (value.isNotEmpty && index < 5) {
                                    _codeFocusNodes[index + 1].requestFocus();
                                  }
                                },
                              ),
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
                                    try {
                                      setState(() => _isLoading = true);
                                      final userService =
                                          ServiceLocator().userService;
                                      final email =
                                          widget.initialEmail ??
                                          _emailController.text.trim();

                                      await userService.sendVerifyEmail(email);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Verification code sent! Please check your inbox.',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      _startResendCountdown(60);
                                    } catch (error) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to resend code: $error',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
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
                                          // Prevent double-tap by checking _isLoading again
                                          if (_isLoading) return;

                                          final ok =
                                              await _sendVerificationEmail();
                                          if (ok && mounted) {
                                            // Get userId from CurrentUser or use email-based placeholder
                                            final user =
                                                CurrentUser.instance.user;
                                            final userId =
                                                user?.userId ?? 'temp_user';

                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    WelcomeCreateProfile(
                                                      onBackPressed: () {
                                                        // Skip and go to dashboard
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      userId:
                                                          widget.createdUserId,
                                                    ),
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
