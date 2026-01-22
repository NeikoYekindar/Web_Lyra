import 'package:flutter/material.dart';
import 'package:lyra/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/music_player_provider.dart';
import 'providers/auth_provider_v2.dart';
import 'theme/app_theme.dart';
import 'shell/app_shell_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/service_locator.dart';
import 'models/current_user.dart';
import 'widgets/auth_gate.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize microservices
  await ServiceLocator().initialize();

  // Load saved tokens before starting the app
  await ServiceLocator().apiClient.loadTokens();

  // Load saved user data from SharedPreferences
  await CurrentUser.instance.restoreFromPrefs();

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
        // New microservice-based auth provider
        ChangeNotifierProvider(create: (_) => AuthProviderV2()),
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
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('vi')],
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
