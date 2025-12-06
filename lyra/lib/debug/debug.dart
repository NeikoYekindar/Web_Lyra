import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lyra/screens/profile_screen.dart';
import 'package:lyra/providers/auth_provider.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:lyra/providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(baseUrl: 'https://example.com'),
        ),
        ChangeNotifierProvider(create: (_) => MusicPlayerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const _DebugApp(),
    ),
  );
}

class _DebugApp extends StatelessWidget {
  const _DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verify Email Debug',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const ProfileScreen(),
    );
  }
}
