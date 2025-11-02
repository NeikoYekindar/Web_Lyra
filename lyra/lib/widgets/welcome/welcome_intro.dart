import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeIntro extends StatefulWidget {
  const WelcomeIntro({super.key});

  @override
  State<WelcomeIntro> createState() => _WelcomeIntroState();
}

class _WelcomeIntroState extends State<WelcomeIntro> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
                'assets/images/bg_welcome.png'
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          const SizedBox(height: 200),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Text(
                'Your Music, Your Way',
                style: GoogleFonts.montserrat(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  'Stream millions of songs with Lyra. Discover new artists, create',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                Text(
                  'playlists, and enjoy your favorite music anywhere.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 65),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AnimatedButton(
                  text: 'Get started free',
                  isPrimary: true,
                  onPressed: () {
                    // Xử lý khi nhấn nút Get Started
                  },
                ),
                const SizedBox(width: 16),
                _AnimatedButton(
                  text: 'Log in',
                  isPrimary: false,
                  onPressed: () {
                    // Xử lý khi nhấn nút Log in
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              'No credit card required • Free plan available',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          const Spacer(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FeatureCard(
                  icon: 'assets/icons/music_welcome_icon.svg',
                  title: 'Millions of Songs',
                  description1: 'Access a vast library of music from',
                  description2: 'artists around the world',
                ),
                const SizedBox(width: 90),
                _FeatureCard(
                  icon: 'assets/icons/heart_welcome_icon.svg',
                  title: 'Personalized',
                  description1: 'Get recommendations based on',
                  description2: 'your unique musical taste',
                ),
                const SizedBox(width: 90),
                _FeatureCard(
                  icon: 'assets/icons/anywhere_welcome_icon.svg',
                  title: 'Anywhere',
                  description1: 'Listen on any device, online or offline',
                  description2: 'wherever you go',
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'By continuing, you agree to Lyra\'s ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Terms of Service
                  },
                  child: Text(
                    'Terms of Service',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFDC0404),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFDC0404),
                    ),
                  ),
                ),
              ),
              Text(
                ' and ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Privacy Policy
                  },
                  child: Text(
                    'Privacy Policy',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFDC0404),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFDC0404),
                    ),
                  ),
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}

// Animated Button Widget with Hover Effect
class _AnimatedButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _AnimatedButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isPrimary 
                ? (_isHovered ? const Color(0xFFFF0808) : const Color(0xFFDC0404))
                : (_isHovered ? const Color(0xFF2A2A2A) : const Color(0xFF111111)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            elevation: _isHovered ? 8 : 0,
            shadowColor: widget.isPrimary 
                ? const Color(0xFFDC0404).withOpacity(0.5)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: widget.isPrimary 
                  ? BorderSide.none
                  : BorderSide(
                      color: _isHovered 
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
            ),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// Feature Card Widget with Hover Effect
class _FeatureCard extends StatefulWidget {
  final String icon;
  final String title;
  final String description1;
  final String description2;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description1,
    required this.description2,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isHovered 
                    ? const Color(0xFFDC0404).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: _isHovered
                    ? Border.all(
                        color: const Color(0xFFDC0404).withOpacity(0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: SvgPicture.asset(
                widget.icon,
                width: 60,
                height: 60,
                colorFilter: ColorFilter.mode(
                  _isHovered ? const Color(0xFFDC0404) : const Color(0xFFFF4444),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description1,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Text(
              widget.description2,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}