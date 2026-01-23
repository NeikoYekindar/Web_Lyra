import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/widgets/welcome/welcome_signup.dart';
import 'package:lyra/providers/auth_provider_v2.dart';
import 'package:lyra/shell/app_shell.dart';
import 'package:lyra/widgets/reset_pass/fp_enter_email.dart';
import 'package:lyra/l10n/app_localizations.dart';

class WelcomeLogin extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSignupPressed;

  const WelcomeLogin({super.key, this.onBackPressed, this.onSignupPressed});

  @override
  State<WelcomeLogin> createState() => _WelcomeLoginState();
}

class _WelcomeLoginState extends State<WelcomeLogin> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0B0B0B),
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 600,
              height: double.infinity,
              padding: const EdgeInsets.only(left: 24, bottom: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),

                image: DecorationImage(
                  image: AssetImage('assets/images/bg_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'Your Music',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Your Way',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.loginDescribe1,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 600,
              height: double.infinity,
              padding: const EdgeInsets.only(left: 48, right: 48),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed:
                              widget.onBackPressed ??
                              () => Navigator.maybePop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            overlayColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.welcomeBack,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 13),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppLocalizations.of(context)!.loginContLis,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    Text(
                      'Email or username',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      style: GoogleFonts.inter(color: Colors.white),
                      cursorColor: const Color(0xFFDC0404),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        // labelText: 'Email or Username',
                        // labelStyle: GoogleFonts.inter(
                        //   color: Colors.grey[400],
                        //   fontSize: 14,
                        // ),
                        hintText: 'Enter your email or username',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color(0xFF2A2A2A),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color(0xFFDC0404),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.red[400]!,
                            width: 1,
                          ),
                        ),
                      ),
                      controller: _emailController,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.password,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: GoogleFonts.inter(color: Colors.white),
                      cursorColor: const Color(0xFFDC0404),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        // labelText: 'Password',
                        // labelStyle: GoogleFonts.inter(
                        //   color: Colors.grey[400],
                        //   fontSize: 14,
                        // ),
                        hintText: AppLocalizations.of(context)!.enterPass,
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color(0xFF2A2A2A),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color(0xFFDC0404),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.red[400]!,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.red[400]!,
                            width: 2,
                          ),
                        ),
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFFDC0404),
                                checkColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.grey[600]!,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.rememberMe,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EnterEmailScreen(),
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword + '?',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFDC0404),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Consumer<AuthProviderV2>(
                      builder: (context, auth, _) => ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final email = _emailController.text.trim();
                                final password = _passwordController.text;

                                if (email.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please enter email and password",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Validate email format
                                final emailRegex = RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                );
                                if (!emailRegex.hasMatch(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please enter a valid email address",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final ok = await context
                                    .read<AuthProviderV2>()
                                    .login(email, password);
                                if (ok && mounted) {
                                  // Wait for current frame to complete and state to propagate
                                  await Future.delayed(
                                    const Duration(milliseconds: 100),
                                  );

                                  if (mounted) {
                                    // Navigate to AppShell after successful login
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const AppShell(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } else if (mounted) {
                                  final msg =
                                      context.read<AuthProviderV2>().error ??
                                      AppLocalizations.of(context)!.loginFailed;
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(msg)));
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC0404),
                          minimumSize: const Size(double.infinity, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.logIn,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Flexible(
                          child: Divider(color: Colors.grey[700], thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppLocalizations.of(context)!.continueWith,
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Divider(color: Colors.grey[700], thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _SocialButton(
                            icon: 'assets/icons/google_icon.svg',
                            label: 'Google',
                            size: 24,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _SocialButton(
                            icon: 'assets/icons/facebook_icon.svg',
                            label: 'Facebook',
                            size: 24,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dontHaveAccount,
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onSignupPressed != null) {
                                widget.onSignupPressed!.call();
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => WelcomeSignup(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFDC0404),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final double size;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: size, height: size),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
