import 'package:flutter/material.dart';
import 'package:lyra/widgets/common/custom_button.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/widgets/reset_pass/fp_enter_code.dart';

class EnterEmailScreen extends StatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  _EnterEmailScreenState createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _sendResetOtp(String email) async {
    try {
      setState(() => _isLoading = true);
      final userService = ServiceLocator().userService;
      // sendVerifyEmail may return void; don't depend on its return value
      await userService.sendVerifyEmail(email);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A), // hoặc Color(0xFF0A0A0A)
        foregroundColor: Colors.white,
        elevation: 3,
        leading: BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40.0),
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
                          Text(
                            'Reset Your Password',
                            style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your email address and we\'ll send you a code to reset your password.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFFB3B3B3),
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.inter(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white70,
                              ),
                              labelText: 'Email Address',
                              labelStyle: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              hintText: 'Enter your email address',
                              hintStyle: GoogleFonts.inter(
                                color: const Color(0xFFB3B3B3),
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF0A0A0A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: const Color(0xFF262626),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : PrimaryButton(
                                  onPressed: () async {
                                    final response = await _sendResetOtp(
                                      _emailController.text.trim(),
                                    );
                                    // Nếu thành công -> chuyển màn hình nhập mã
                                    if ( mounted) {
                                      final email = _emailController.text
                                          .trim();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EnterResetCode(email: email),
                                        ),
                                      );
                                    } else {
                                      // Hiển thị lỗi nếu cần
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Code sending failed. Please try again.',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },

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
}

class SendResponse {
  final String? message;

  SendResponse({this.message});
}
