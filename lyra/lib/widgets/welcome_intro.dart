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

class _WelcomeIntroState extends State<WelcomeIntro>{
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
          Text(
            'Your Music, Your Way',
            style: GoogleFonts.montserrat(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Stream millions of songs with Lyra. Discover new artists, create',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Text(
            'playlists, and enjoy your favorite music anywhere.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 65),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút Get Started
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC0404),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8
                    ),
                  ),
                ),
                child: const Text(
                  'Get started free',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút Get Started
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111111),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8
                    ),
                    
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                      width: 1, 
                    ),
                  ),
                  
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),

              
            ],
          ),
          const SizedBox(height: 20),
              Text('No credit card required • Free plan available',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/music_welcome_icon.svg',
                      width: 60,
                      height: 60,
                      
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Millions of Songs',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access a vast library of music from',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      'artists around the world',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(width: 90),
              Container(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/heart_welcome_icon.svg',
                      width: 60,
                      height: 60,
                      
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Personalized',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get recommendations based on',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      'your unique musical taste',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(width: 90),
              Container(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/anywhere_welcome_icon.svg',
                      width: 60,
                      height: 60,
                      
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Anywhere',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Listen on any device, online or offline',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      'wherever you go',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'By continuing, you agree to Lyra\'s ',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFFDC0404),
                  fontWeight: FontWeight.w800,
                  
                ),
              ),
              Text(
                ' and ',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFFDC0404),
                  fontWeight: FontWeight.w800,
                  
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}