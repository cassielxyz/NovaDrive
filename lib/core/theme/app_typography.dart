import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static String get fontFamily => GoogleFonts.plusJakartaSans().fontFamily ?? 'Inter';

  static TextTheme get textTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme(
      const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 28 / 22),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16, letterSpacing: 0.15),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14, letterSpacing: 0.1),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16, letterSpacing: 0.15),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, letterSpacing: 0.25),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12, letterSpacing: 0.4),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14, letterSpacing: 0.1),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 16 / 12, letterSpacing: 0.5),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 16 / 11, letterSpacing: 0.5),
      ),
    );

    final displayTheme = GoogleFonts.outfitTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w700, height: 64 / 57, letterSpacing: -0.02 * 57),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, height: 52 / 45),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, height: 44 / 36),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, height: 40 / 32, letterSpacing: 0),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, height: 36 / 28),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 32 / 24),
      ),
    );

    return baseTextTheme.copyWith(
      displayLarge: displayTheme.displayLarge,
      displayMedium: displayTheme.displayMedium,
      displaySmall: displayTheme.displaySmall,
      headlineLarge: displayTheme.headlineLarge,
      headlineMedium: displayTheme.headlineMedium,
      headlineSmall: displayTheme.headlineSmall,
    );
  }
}
