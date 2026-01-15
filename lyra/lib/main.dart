import 'package:flutter/material.dart';
import 'package:lyra/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/music_player_provider.dart';
import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';
import 'shell/app_shell.dart';
import 'shell/app_shell_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MusicPlayerProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AppShellController()),
        // Backend base URL for login API
        ChangeNotifierProvider(
          create: (_) =>
              AuthProvider(baseUrl: 'https://3dd50a8c5b1c.ngrok-free.app'),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Lyra - Spotify Clone',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            locale: context.watch<LocaleProvider>().locale,
            localizationsDelegates: const [
              //AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('vi'),
            ],
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
