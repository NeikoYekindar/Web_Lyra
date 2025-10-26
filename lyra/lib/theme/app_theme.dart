import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Màu chính của ứng dụng
  static const Color primaryColor = Color(0xFF1DB954); // Spotify Green
  static const Color secondaryColor = Color(0xFF1ED760); // Light Green
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2A2A2A);
  static const Color darkText = Colors.white;
  static const Color darkSecondaryText = Color(0xFFB3B3B3);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color.fromARGB(255, 189, 188, 188);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF000000);
  static const Color lightSecondaryText = Color(0xFF666666);
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      
      // Card Theme
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkText,
        elevation: 0,
      ),
      
      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkSecondaryText,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: darkText,
        size: 24,
      ),
      
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Text Theme with Google Fonts
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(color: darkText, fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(color: darkText, fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(color: darkText, fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(color: darkText, fontWeight: FontWeight.w600),
          headlineMedium: const TextStyle(color: darkText, fontWeight: FontWeight.w600),
          headlineSmall: const TextStyle(color: darkText, fontWeight: FontWeight.w600),
          titleLarge: const TextStyle(color: darkText, fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(color: darkText, fontWeight: FontWeight.w500),
          titleSmall: const TextStyle(color: darkText, fontWeight: FontWeight.w500),
          bodyLarge: const TextStyle(color: darkText),
          bodyMedium: const TextStyle(color: darkText),
          bodySmall: const TextStyle(color: darkSecondaryText),
          labelLarge: const TextStyle(color: darkText, fontWeight: FontWeight.w500),
          labelMedium: const TextStyle(color: darkSecondaryText),
          labelSmall: const TextStyle(color: darkSecondaryText),
        ),
      ),
      
      fontFamily: GoogleFonts.inter().fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurface,
        background: darkBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText,
        onBackground: darkText,
      ),
    );
  }
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      
      // Card Theme
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightText,
        elevation: 0,
      ),
      
      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightSecondaryText,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: lightText,
        size: 24,
      ),
      
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Text Theme with Google Fonts
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(color: lightText, fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(color: lightText, fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(color: lightText, fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(color: lightText, fontWeight: FontWeight.w600),
          headlineMedium: const TextStyle(color: lightText, fontWeight: FontWeight.w600),
          headlineSmall: const TextStyle(color: lightText, fontWeight: FontWeight.w600),
          titleLarge: const TextStyle(color: lightText, fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(color: lightText, fontWeight: FontWeight.w500),
          titleSmall: const TextStyle(color: lightText, fontWeight: FontWeight.w500),
          bodyLarge: const TextStyle(color: lightText),
          bodyMedium: const TextStyle(color: lightText),
          bodySmall: const TextStyle(color: lightSecondaryText),
          labelLarge: const TextStyle(color: lightText, fontWeight: FontWeight.w500),
          labelMedium: const TextStyle(color: lightSecondaryText),
          labelSmall: const TextStyle(color: lightSecondaryText),
        ),
      ),
      
      fontFamily: GoogleFonts.inter().fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
        background: lightBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText,
        onBackground: lightText,
      ),
    );
  }
}

// Theme Colors Helper - để dễ dàng truy cập màu trong components
class AppColors {
  static bool _isDark = true;
  
  static void setTheme(bool isDark) {
    _isDark = isDark;
  }
  
  // Dynamic colors dựa trên theme hiện tại
  static Color get background => _isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
  static Color get surface => _isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
  static Color get card => _isDark ? AppTheme.darkCard : AppTheme.lightCard;
  static Color get text => _isDark ? AppTheme.darkText : AppTheme.lightText;
  static Color get secondaryText => _isDark ? AppTheme.darkSecondaryText : AppTheme.lightSecondaryText;
  
  // Static colors (không đổi theo theme)
  static const Color primary = AppTheme.primaryColor;
  static const Color secondary = AppTheme.secondaryColor;
}