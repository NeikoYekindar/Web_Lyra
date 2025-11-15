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

  // Light Theme Colors (mapped)
  static const Color lightBackground = white;
  // NOTE: Previous value 0xFFFEFEFEF had 9 hex digits (invalid). Adjusted to near-white.
  static const Color lightSurface = Color(0xFFF5F5F5); // subtle light surface
  static const Color lightCard = white;
  static const Color lightText = black;
  static const Color lightSecondaryText = neutral800; // use dark gray for secondary
  
  
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
      tertiaryContainer: darkCard,
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
        AppExtraColors(headerAndAll: AppTheme.black),
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
      primary: redPrimary,
      onPrimary: white,
      primaryContainer: redPrimaryDark,
      onPrimaryContainer: white,
      secondary: neutral800,
      onSecondary: white,
      secondaryContainer: lightSurface,
      onSecondaryContainer: black,
      tertiary: neutral500,
      onTertiary: black,
      tertiaryContainer: lightSurface,
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
        AppExtraColors(headerAndAll: AppTheme.white),
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

  const AppExtraColors({required this.headerAndAll});

  @override
  AppExtraColors copyWith({Color? headerAndAll}) {
    return AppExtraColors(headerAndAll: headerAndAll ?? this.headerAndAll);
  }

  @override
  AppExtraColors lerp(ThemeExtension<AppExtraColors>? other, double t) {
    if (other is! AppExtraColors) return this;
    return AppExtraColors(
      headerAndAll: Color.lerp(headerAndAll, other.headerAndAll, t)!,
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
  // Static brand colors
  static const Color red = AppTheme.redPrimary;
  static const Color redDark = AppTheme.redPrimaryDark;
  static const Color white = AppTheme.white;
  static const Color black = AppTheme.black;
}