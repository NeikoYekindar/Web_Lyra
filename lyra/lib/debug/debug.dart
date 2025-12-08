import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lyra/screens/dashboard_screen.dart';
import 'package:lyra/providers/auth_provider.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:lyra/providers/theme_provider.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/models/user.dart';
import 'package:lyra/models/current_user.dart';

final mockUser = UserModel(
  userId: 'user_123',
  displayName: 'Trùm UIT',
  userType: 'user',
  email: 'trumuit@example.com',
  dateOfBirth: DateTime(2004, 5, 7),
  gender: 'Male',
  profileImageUrl: 'assets/images/avatar.png',
  dateCreated: DateTime.now().toIso8601String(),
  favoriteGenres: ['Folk', 'Pop', 'Latin'],
);

// Đăng nhập và lưu persistent will be performed in async main
Future<void> main() async {
  // login and persist mock user for debug
  CurrentUser.instance.login(mockUser);
  await CurrentUser.instance.saveToPrefs();

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Lyra - Spotify Clone',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const DashboardScreen(),
        );
      },
    );
  }
}
