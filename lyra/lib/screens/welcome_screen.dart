import 'package:flutter/material.dart';
import 'package:lyra/widgets/dashboard/home_center.dart';
import 'package:lyra/widgets/dashboard/left_sidebar_mini.dart';
import 'package:lyra/widgets/welcome/welcome_create_profile.dart';
import 'package:lyra/widgets/welcome/welcome_verify_email.dart';
import '../widgets/dashboard/left_sidebar.dart';
import '../widgets/dashboard/app_header.dart';
import '../widgets/user_profile.dart';
import '../widgets/dashboard/right_sidebar.dart';
import '../widgets/dashboard/music_player.dart';
import '../widgets/welcome/welcome_intro.dart';
import '../widgets/welcome/welcome_login.dart';
import '../widgets/welcome/welcome_signup.dart';
import '../widgets/welcome/welcome_create_profile.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{
  bool _showLogin = false;
  bool _showSignup = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _showSignup
          ? WelcomeSignup(
              onBackPressed: () {
                setState(() {
                  _showSignup = false;
                });
              },
            )
          : _showLogin 
              ? WelcomeLogin(
                  onBackPressed: () {
                    setState(() {
                      _showLogin = false;
                    });
                  },
                )
              : WelcomeIntro(
                  onLoginPressed: () {
                    setState(() {
                      _showLogin = true;
                      _showSignup = false;
                    });
                  },
                  onSignupPressed: () {
                    setState(() {
                      _showSignup = true;
                      _showLogin = false;
                    });
                  },
                ),
      // body: WelcomeVerifyEmail(

      // ),
    );
  }
}
