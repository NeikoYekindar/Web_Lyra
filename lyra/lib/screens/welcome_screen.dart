import 'package:flutter/material.dart';
import 'package:lyra/widgets/home_center.dart';
import 'package:lyra/widgets/left_sidebar_mini.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/app_header.dart';
import '../widgets/user_profile.dart';
import '../widgets/right_sidebar.dart';
import '../widgets/music_player.dart';
import '../widgets/welcome/welcome_intro.dart';
import '../widgets/welcome/welcome_login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const WelcomeLogin(),
    );
  }
}