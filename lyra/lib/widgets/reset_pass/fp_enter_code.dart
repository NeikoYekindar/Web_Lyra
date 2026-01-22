import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/widgets/common/circle_icon_container.dart';
import 'package:lyra/widgets/common/custom_button.dart';
import 'package:lyra/widgets/reset_pass/fp_enter_new_password.dart';

class EnterResetCode extends StatefulWidget {
  final String email;

  const EnterResetCode({Key? key, required this.email}) : super(key: key);

  @override
  _EnterResetCodeScreenState createState() => _EnterResetCodeScreenState();
}

class _EnterResetCodeScreenState extends State<EnterResetCode> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _resendSecondsLeft = 0;
  Timer? _resendTimer;
  List<TextEditingController> _codeControllers = [];
  List<FocusNode> _codeFocusNodes = [];
  bool _suppressOnChanged = false;
  bool _isCodeComplete = false;
  List<String> _previousValues = [];

  void _clearCodeFields() {
    for (final c in _codeControllers) {
      c.clear();
    }
    FocusScope.of(context).requestFocus(_codeFocusNodes[0]);
  }

  Future<void> _resendVerificationCode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userService = ServiceLocator().userService;
      await userService.sendVerifyEmail(widget.email);

      _clearCodeFields();
      _startResendCountdown(60);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code resent. Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateCodeComplete() {
    final complete = _codeControllers.every((c) => c.text.trim().isNotEmpty);
    if (complete != _isCodeComplete) setState(() => _isCodeComplete = complete);
  }

  void _startResendCountdown([int seconds = 60]) {
    _resendTimer?.cancel();
    setState(() {
      _resendSecondsLeft = seconds;
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
    _previousValues = List.generate(6, (_) => '');

    // Watch code controllers for completeness
    for (final c in _codeControllers) {
      c.addListener(_updateCodeComplete);
    }

    // Start countdown timer since OTP was already sent from previous screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startResendCountdown(60);
    });
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
            child: Column(
              children: [
                ConstrainedBox(
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
                            'Check Your Email',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'We have sent a code to ',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFFB3B3B3),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.email,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Didn\'t receive the email? Check your spam folder.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w400,
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
                                      fontSize: 30,
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
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
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
                                        _codeFocusNodes[index + 1]
                                            .requestFocus();
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
                                onPressed:
                                    _resendSecondsLeft == 0 && !_isLoading
                                    ? _resendVerificationCode
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
                                              // Prevent double-tap
                                              if (_isLoading) return;
                                              final code = _codeControllers
                                                  .map((c) => c.text)
                                                  .join();

                                              // Check if all fields are filled
                                              if (code.length < 6) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Please enter all 6 digits',
                                                    ),
                                                    backgroundColor:
                                                        Colors.orange,
                                                  ),
                                                );
                                                return;
                                              }

                                              // Verify code with API
                                              try {
                                                setState(
                                                  () => _isLoading = true,
                                                );
                                                final userService =
                                                    ServiceLocator()
                                                        .userService;
                                                await userService.verifyOtp(
                                                  email: widget.email,
                                                  otp: code,
                                                );

                                                if (mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Verification successful!',
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );

                                                  // Navigate to reset password screen
                                                  Navigator.of(
                                                    context,
                                                  ).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          EnterNewPasswordScreen(
                                                            email: widget.email,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              } catch (error) {
                                                setState(
                                                  () => _isLoading = false,
                                                );
                                                // Clear all fields when code is wrong
                                                _clearCodeFields();
                                                if (mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Invalid verification code: $error',
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                      child: Text(
                                        'SUBMIT',
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
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 14,
                      color: const Color(0xFFDA0707),
                    ),
                    SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
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
