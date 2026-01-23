import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lyra/providers/locale_provider.dart';

import 'package:lyra/providers/auth_provider_v2.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:lyra/providers/theme_provider.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/shell/app_shell.dart';
import 'package:lyra/shell/app_shell_controller.dart';

// Localization
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lyra/l10n/app_localizations.dart';

// 🔥 ADD
import 'package:lyra/models/current_user.dart';
import 'package:lyra/models/user.dart';

// Microservices
import 'package:lyra/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // 🔥 INITIALIZE MICROSERVICES (BẮT BUỘC)
  // ============================================================
  await ServiceLocator().initialize();

  // ============================================================
  // 🔥 RESTORE / INIT CURRENT USER (BẮT BUỘC)
  // ============================================================
  await CurrentUser.instance.restoreFromPrefs();

  // 👉 DEV MODE: nếu chưa có user → set mock
  if (CurrentUser.instance.user == null) {
    CurrentUser.instance.login(
      UserModel(
        userId: 'user_123',
        displayName: 'Trùm UIT',
        userType: 'user',
        email: 'trumuit@example.com',
        gender: 'Male',
        dateOfBirth: DateTime(2004, 5, 7),
        profileImageUrl: 'assets/images/avatar.png',
        favoriteGenres: ['Folk', 'Pop', 'Latin'],
        dateCreated: DateTime.now().toIso8601String(),
      ),
    );

    await CurrentUser.instance.saveToPrefs();
  }

  // ============================================================
  // RUN APP
  // ============================================================
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviderV2()),
        ChangeNotifierProvider(create: (_) => MusicPlayerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AppShellController()),
      ],
      child: const _DebugApp(),
    ),
  );
}

class _DebugApp extends StatelessWidget {
  const _DebugApp();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lyra Debug',
          locale: context.watch<LocaleProvider>().locale,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          // Localization: match the main app so AppLocalizations.of(context) works
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          // 🔥 AppShell giữ nguyên
          home: const AppShell(),
        );
      },
    );
  }
}
