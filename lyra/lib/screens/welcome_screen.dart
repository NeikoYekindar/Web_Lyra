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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _showSignup
          ? WelcomeSignup(
              onBackPressed: () {
                setState(() {
                  _showSignup = false;
                });
              },
              onLoginPressed: () {
                setState(() {
                  _showSignup = false;
                  _showLogin = true;
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
              onSignupPressed: () {
                setState(() {
                  _showLogin = false;
                  _showSignup = true;
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
