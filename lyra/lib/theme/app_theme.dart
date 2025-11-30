import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // New palette based on provided image
  // Core brand reds
  static const Color redPrimary = Color(0xFFE62429); // main brand color
  static const Color redPrimaryDark = Color(0xFF801417); // darker container / pressed state

  // Neutral scale
  static const Color black = Color(0xFF000000);
  static const Color neutral900 = Color(0xFF1F1F1F); // dark background
  static const Color neutral800 = Color(0xFF303030); // surfaces / cards
 
  static const Color neutral500 = Color(0xFF909090); // disabled / hint
  static const Color neutral400 = Color(0xFFB3B3B3); // secondary text on dark
  static const Color white = Color(0xFFFFFFFF);

  // Dark Theme Colors (mapped)
  static const Color darkBackground = neutral900;
  static const Color darkSurface = neutral800;
  static const Color darkSurfaceSite = neutral900;
  static const Color darkCard = neutral800;
  static const Color darkText = white;
  static const Color darkSecondaryText = neutral400;
  static const Color rcmsong = Color(0xFF040404);

  // Light Theme Colors (mapped)
  static const Color lightBackground = white;
  // NOTE: Previous value 0xFFFEFEFEF had 9 hex digits (invalid). Adjusted to near-white.
  static const Color lightSurface = Color(0xFFF5F5F5); // subtle light surface
  static const Color lightCard = white;
  static const Color lightText = black;
  static const Color lightSecondaryText = neutral800; // use dark gray for secondary
  static const Color lightrcmsong = Color(0xFFD13F43);
  
  
  // Dark Theme
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: redPrimary,
      onPrimary: white,
      primaryContainer: redPrimaryDark,
      onPrimaryContainer: white,
      secondary: neutral500,
      onSecondary: white,
      secondaryContainer: darkSurface,
      onSecondaryContainer: white,
      tertiary: neutral400,
      onTertiary: black,
      tertiaryContainer: rcmsong,
      onTertiaryContainer: white,
      error: Colors.red,
      onError: white,
      background: darkBackground,
      onBackground: white,
      surface: darkSurfaceSite,
      onSurface: white,
      surfaceVariant: darkCard,
      onSurfaceVariant: neutral400,
      outline: neutral500,
      outlineVariant: darkSurface,
      shadow: black,
      scrim: Colors.black54,
      inverseSurface: redPrimaryDark,
      onInverseSurface: white,
      inversePrimary: redPrimaryDark,
      
    );
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: colorScheme,
      useMaterial3: true,
      extensions: const <ThemeExtension<dynamic>>[
        AppExtraColors(
          headerAndAll: AppTheme.black,
          playerControlsBackground: Color(0xFF1A1A1A),
          miniPlayerBackground: Color(0xFF0F0F0F),
          playlistItemHover: Color(0xFF2A2A2A),
          lyricsSectionBackground: Color(0xFF151515),
          equalizer: Color(0xFF4CAF50),
        ),
      ],
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: redPrimary,
        unselectedItemColor: neutral500,
      ),
      iconTheme: const IconThemeData(color: white, size: 24),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: redPrimary,
          foregroundColor: white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          headlineLarge: const TextStyle(fontWeight: FontWeight.w700, color: white),
          headlineMedium: const TextStyle(fontWeight: FontWeight.w700, color: white),
          titleLarge: const TextStyle(fontWeight: FontWeight.w600, color: white),
          titleMedium: const TextStyle(fontWeight: FontWeight.w500, color: white),
          bodyLarge: const TextStyle(color: white),
          bodyMedium: const TextStyle(color: white),
          bodySmall: TextStyle(color: neutral400),
          labelLarge: const TextStyle(fontWeight: FontWeight.w600, color: white),
          labelMedium: TextStyle(color: neutral400),
          labelSmall: TextStyle(color: neutral400),
        ),
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
    );
  }
  
  // Light Theme
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: black,
      onPrimary: white,
      primaryContainer: redPrimaryDark,
      onPrimaryContainer: white,
      secondary: neutral800,
      onSecondary: white,
      secondaryContainer: lightSurface,
      onSecondaryContainer: black,
      tertiary: neutral500,
      onTertiary: black,
      tertiaryContainer: lightrcmsong,
      onTertiaryContainer: black,
      error: Colors.red,
      onError: white,
      background: lightBackground,
      onBackground: black,
      surface: lightSurface,
      onSurface: black,
  // Use full light background for variant to ensure clear difference from surface in widgets
      surfaceVariant: lightBackground,
      onSurfaceVariant: neutral800,
      outline: neutral500,
      outlineVariant: neutral400,
      shadow: neutral500,
      scrim: Colors.black54,
      inverseSurface: neutral800,
      onInverseSurface: white,
      inversePrimary: redPrimaryDark,
    );
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: colorScheme,
      useMaterial3: true,
      extensions: const <ThemeExtension<dynamic>>[
        AppExtraColors(
          headerAndAll: AppTheme.white,
          playerControlsBackground: Color(0xFFF5F5F5),
          miniPlayerBackground: Color(0xFFFFFFFF),
          playlistItemHover: Color(0xFFF0F0F0),
          lyricsSectionBackground: Color(0xFFFAFAFA),
          equalizer: Color(0xFF4CAF50),
        ),
      ],
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: black,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: redPrimary,
        unselectedItemColor: neutral800,
      ),
      iconTheme: const IconThemeData(color: black, size: 24),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: redPrimary,
          foregroundColor: white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.copyWith(
          headlineLarge: const TextStyle(fontWeight: FontWeight.w700, color: black),
          headlineMedium: const TextStyle(fontWeight: FontWeight.w700, color: black),
          titleLarge: const TextStyle(fontWeight: FontWeight.w600, color: black),
          titleMedium: const TextStyle(fontWeight: FontWeight.w500, color: black),
          bodyLarge: const TextStyle(color: black),
          bodyMedium: const TextStyle(color: black),
          bodySmall: TextStyle(color: neutral800),
          labelLarge: const TextStyle(fontWeight: FontWeight.w600, color: black),
          labelMedium: TextStyle(color: neutral800),
          labelSmall: TextStyle(color: neutral800),
        ),
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
    );
  }
}

// Extra theme colors that are not part of ColorScheme
@immutable
class AppExtraColors extends ThemeExtension<AppExtraColors> {
  final Color headerAndAll;
  final Color playerControlsBackground;
  final Color miniPlayerBackground;
  final Color playlistItemHover;
  final Color lyricsSectionBackground;
  final Color equalizer;

  const AppExtraColors({
    required this.headerAndAll,
    required this.playerControlsBackground,
    required this.miniPlayerBackground,
    required this.playlistItemHover,
    required this.lyricsSectionBackground,
    required this.equalizer,
  });

  @override
  AppExtraColors copyWith({
    Color? headerAndAll,
    Color? playerControlsBackground,
    Color? miniPlayerBackground,
    Color? playlistItemHover,
    Color? lyricsSectionBackground,
    Color? equalizer,
  }) {
    return AppExtraColors(
      headerAndAll: headerAndAll ?? this.headerAndAll,
      playerControlsBackground: playerControlsBackground ?? this.playerControlsBackground,
      miniPlayerBackground: miniPlayerBackground ?? this.miniPlayerBackground,
      playlistItemHover: playlistItemHover ?? this.playlistItemHover,
      lyricsSectionBackground: lyricsSectionBackground ?? this.lyricsSectionBackground,
      equalizer: equalizer ?? this.equalizer,
    );
  }

  @override
  AppExtraColors lerp(ThemeExtension<AppExtraColors>? other, double t) {
    if (other is! AppExtraColors) return this;
    return AppExtraColors(
      headerAndAll: Color.lerp(headerAndAll, other.headerAndAll, t)!,
      playerControlsBackground: Color.lerp(playerControlsBackground, other.playerControlsBackground, t)!,
      miniPlayerBackground: Color.lerp(miniPlayerBackground, other.miniPlayerBackground, t)!,
      playlistItemHover: Color.lerp(playlistItemHover, other.playlistItemHover, t)!,
      lyricsSectionBackground: Color.lerp(lyricsSectionBackground, other.lyricsSectionBackground, t)!,
      equalizer: Color.lerp(equalizer, other.equalizer, t)!,
    );
  }
}

// Theme Colors Helper - để dễ dàng truy cập màu trong components
class AppColors {
  static bool _isDark = true;

  static void setTheme(bool isDark) => _isDark = isDark;

  // Dynamic getters using new palette
  static Color get background => _isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
  static Color get surface => _isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
  static Color get card => _isDark ? AppTheme.darkCard : AppTheme.lightCard;
  static Color get textPrimary => _isDark ? AppTheme.darkText : AppTheme.lightText;
  static Color get textSecondary => _isDark ? AppTheme.darkSecondaryText : AppTheme.lightSecondaryText;
  static Color get divider => _isDark ? AppTheme.neutral800 : AppTheme.neutral400;
  static Color get muted => _isDark ? AppTheme.neutral500 : AppTheme.neutral500;
  static Color get onTertiary => _isDark ?AppTheme.lightText  :AppTheme.darkText ;
  static Color get surfaceVariant => _isDark ? AppTheme.neutral800 : AppTheme.lightBackground;
  static Color get tertiaryContainer => _isDark ? AppTheme.rcmsong : AppTheme.lightrcmsong;
  static Color get primary => _isDark ? AppTheme.redPrimary : const Color.fromARGB(255, 255, 255, 255);
  // Static brand colors
  static const Color red = AppTheme.redPrimary;
  static const Color redDark = AppTheme.redPrimaryDark;
  static const Color white = AppTheme.white;
  static const Color black = AppTheme.black;
  
  // Custom colors - Bạn có thể thêm bao nhiêu tùy thích với tên tùy chỉnh
  static const Color musicPlayerBackground = Color(0xFF1A1A1A);
  static const Color sidebarBackground = Color(0xFF0F0F0F);
  static const Color playButtonColor = Color(0xFF00E676);
  static const Color volumeSlider = Color(0xFF4CAF50);
  static const Color favoriteIcon = Color(0xFFFF5722);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color infoColor = Color(0xFF2196F3);
  static const Color gradientStart = Color(0xFFE62429);
  static const Color gradientEnd = Color(0xFF801417);
  // static const Color colortextrcmbutton = Color(0xFFFFFFFF);
  
  // Dynamic custom colors (thay đổi theo theme)
  static Color get musicCardHover => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);
  static Color get searchBarBackground => _isDark ? const Color(0xFF252525) : const Color(0xFFFFFFFF);
  static Color get buttonHover => _isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0);
  static Color get borderColor => _isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0);
  static Color get shadowColor => _isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2);
  static Color textrcmbutton(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFFFFF) : const Color(0xFFE62429); // white for dark, red for light
  static Color get colortextrcmbutton => _isDark ? const Color(0xFFFFFFFF) : const Color(0xFFE62429);
  static Color bgrcmbutton(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFE62429) : const Color(0xFFFFFFFF); // white for dark, red for light
  static Color bg_left_sidebar(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1F1F1F) : const Color(0xFFFFFFFF); // dark for dark, light for light
}

// Extension để dễ dàng truy cập AppExtraColors
extension AppExtraColorsExtension on BuildContext {
  AppExtraColors get extraColors => Theme.of(this).extension<AppExtraColors>()!;
}