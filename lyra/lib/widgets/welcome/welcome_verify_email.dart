import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/providers/auth_provider.dart';

class WelcomeVerifyEmail extends StatefulWidget {
  const WelcomeVerifyEmail({super.key});

  @override
  State<WelcomeVerifyEmail> createState() => _WelcomeVerifyEmailState();
}

class _WelcomeVerifyEmailState extends State<WelcomeVerifyEmail> {
  @override
  Widget build(BuildContext context) {
    final extra = Theme.of(context).extension<AppExtraColors>();
    return Scaffold(
      backgroundColor: extra?.headerAndAll ?? Theme.of(context).colorScheme.onTertiary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/email_verification.svg',
                height: 150,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify Your Email',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'A verification link has been sent to your email address. Please check your inbox and click the link to verify your account.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to login or previous screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'Back to Login',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}