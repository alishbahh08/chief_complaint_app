import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens — same palette/feel as the web prototype,
/// so the Flutter app and the artifact look like the same product.
class AppColors {
  static const ink = Color(0xFF1E2B28);
  static const paper = Color(0xFFEEF0E9);
  static const panel = Color(0xFFFFFFFF);
  static const teal = Color(0xFF2B6E62);
  static const tealInk = Color(0xFF173F38);
  static const amber = Color(0xFFB8792E);
  static const red = Color(0xFFA6402F);
  static const line = Color(0xFFD3D6CB);
  static const lineSoft = Color(0xFFE2E4DB);
}

class AppTheme {
  static ThemeData get light {
    final serif = GoogleFonts.spectralTextTheme();
    final sans = GoogleFonts.ibmPlexSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.teal,
        secondary: AppColors.amber,
        error: AppColors.red,
        surface: AppColors.panel,
      ),
      textTheme: sans.copyWith(
        headlineSmall: serif.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink),
        titleLarge: serif.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink),
        titleMedium: serif.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.paper,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.line),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.panel,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
    );
  }
}
