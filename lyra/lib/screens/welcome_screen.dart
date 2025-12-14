import 'package:flutter/material.dart';

import '../widgets/welcome/welcome_intro.dart';
import '../widgets/welcome/welcome_login.dart';
import '../widgets/welcome/welcome_signup.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
