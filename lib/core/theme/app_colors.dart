import 'package:flutter/material.dart';
import 'theme_provider.dart';

class AppColors {
  AppColors._();

  // Dark Theme Tokens (from Stitch) - Base Purple
  static const Color primary = Color(0xFFC9BFFF);
  static const Color onPrimary = Color(0xFF2E009C);
  static const Color primaryContainer = Color(0xFF917EFF);
  static const Color onPrimaryContainer = Color(0xFF28008A);
  
  static const Color secondary = Color(0xFFB9C8DE);
  static const Color onSecondary = Color(0xFF233143);
  static const Color secondaryContainer = Color(0xFF39485A);
  static const Color onSecondaryContainer = Color(0xFFA7B6CC);
  
  static const Color tertiary = Color(0xFFA4C9FF);
  static const Color onTertiary = Color(0xFF00315D);
  static const Color tertiaryContainer = Color(0xFF4D93E5);
  static const Color onTertiaryContainer = Color(0xFF002A51);
  
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
  
  static const Color background = Color(0xFF131314);
  static const Color onBackground = Color(0xFFE5E2E3);
  static const Color surface = Color(0xFF131314);
  static const Color onSurface = Color(0xFFE5E2E3);
  static const Color surfaceVariant = Color(0xFF353436);
  static const Color onSurfaceVariant = Color(0xFFC9C4D8);
  static const Color outline = Color(0xFF928EA1);
  static const Color outlineVariant = Color(0xFF484555);
  
  static const Color inverseSurface = Color(0xFFE5E2E3);
  static const Color inverseOnSurface = Color(0xFF303031);
  static const Color inversePrimary = Color(0xFF5D3FE0);

  // Light Theme Tokens
  static const Color lightPrimary = Color(0xFF5D3FE0);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFE5DEFF);
  static const Color lightOnPrimaryContainer = Color(0xFF1A0063);
  
  static const Color lightSecondary = Color(0xFF516073);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFD4E4FA);
  static const Color lightOnSecondaryContainer = Color(0xFF0D1C2D);
  
  static const Color lightTertiary = Color(0xFF005FA8);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFD4E3FF);
  static const Color lightOnTertiaryContainer = Color(0xFF001C39);
  
  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnErrorContainer = Color(0xFF410002);
  
  static const Color lightBackground = Color(0xFFFDFBFF);
  static const Color lightOnBackground = Color(0xFF1A1B1F);
  static const Color lightSurface = Color(0xFFFDFBFF);
  static const Color lightOnSurface = Color(0xFF1A1B1F);
  static const Color lightSurfaceVariant = Color(0xFFE6E0EC);
  static const Color lightOnSurfaceVariant = Color(0xFF48454E);
  static const Color lightOutline = Color(0xFF79747E);
  static const Color lightOutlineVariant = Color(0xFFCAC4D0);

  // AMOLED Theme Tokens
  static const Color amoledBackground = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF050505);
  static const Color amoledSurfaceVariant = Color(0xFF111111);

  // Glassmorphism exact opacities
  static Color getGlassPanel(Brightness brightness, GlassIntensity intensity) {
    if (intensity == GlassIntensity.off) return Colors.transparent;
    final base = brightness == Brightness.dark ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);
    switch (intensity) {
      case GlassIntensity.low:
        return base.withValues(alpha: brightness == Brightness.dark ? 0.08 : 0.75);
      case GlassIntensity.medium:
        return base.withValues(alpha: brightness == Brightness.dark ? 0.12 : 0.60);
      case GlassIntensity.high:
        return base.withValues(alpha: brightness == Brightness.dark ? 0.18 : 0.45);
      case GlassIntensity.off:
        return base;
    }
  }

  static Color getGlassBorder(Brightness brightness, GlassIntensity intensity) {
    if (intensity == GlassIntensity.off) return Colors.transparent;
    final base = brightness == Brightness.dark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    switch (intensity) {
      case GlassIntensity.low:
        return base.withValues(alpha: 0.10);
      case GlassIntensity.medium:
        return base.withValues(alpha: 0.20);
      case GlassIntensity.high:
        return base.withValues(alpha: 0.30);
      case GlassIntensity.off:
        return Colors.transparent;
    }
  }

  static Color getPrimary(NovaAccentColor accent, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (accent) {
      case NovaAccentColor.blue:
        return isDark ? const Color(0xFFA4C9FF) : const Color(0xFF005FA8);
      case NovaAccentColor.green:
        return isDark ? const Color(0xFF82D99A) : const Color(0xFF006D3A);
      case NovaAccentColor.orange:
        return isDark ? const Color(0xFFFFB48C) : const Color(0xFF904D00);
      case NovaAccentColor.rose:
        return isDark ? const Color(0xFFFFB1C8) : const Color(0xFF980036);
      case NovaAccentColor.monochrome:
        return isDark ? const Color(0xFFE5E2E3) : const Color(0xFF1A1B1F);
      case NovaAccentColor.purple:
        return isDark ? primary : lightPrimary;
      case NovaAccentColor.custom:
        return isDark ? primary : lightPrimary;
    }
  }
  
  static Color getOnPrimary(NovaAccentColor accent, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (accent) {
      case NovaAccentColor.blue:
        return isDark ? const Color(0xFF00315D) : const Color(0xFFFFFFFF);
      case NovaAccentColor.green:
        return isDark ? const Color(0xFF00391B) : const Color(0xFFFFFFFF);
      case NovaAccentColor.orange:
        return isDark ? const Color(0xFF4D2700) : const Color(0xFFFFFFFF);
      case NovaAccentColor.rose:
        return isDark ? const Color(0xFF5E001E) : const Color(0xFFFFFFFF);
      case NovaAccentColor.monochrome:
        return isDark ? const Color(0xFF131314) : const Color(0xFFFFFFFF);
      case NovaAccentColor.purple:
        return isDark ? onPrimary : lightOnPrimary;
      case NovaAccentColor.custom:
        return isDark ? onPrimary : lightOnPrimary;
    }
  }
  
  static Color getPrimaryContainer(NovaAccentColor accent, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (accent) {
      case NovaAccentColor.blue:
        return isDark ? const Color(0xFF4D93E5) : const Color(0xFFD4E3FF);
      case NovaAccentColor.green:
        return isDark ? const Color(0xFF00522B) : const Color(0xFFC0F9D0);
      case NovaAccentColor.orange:
        return isDark ? const Color(0xFF6E3A00) : const Color(0xFFFFDCC5);
      case NovaAccentColor.rose:
        return isDark ? const Color(0xFF7A002A) : const Color(0xFFFFD9E2);
      case NovaAccentColor.monochrome:
        return isDark ? const Color(0xFF353436) : const Color(0xFFE5E2E3);
      case NovaAccentColor.purple:
        return isDark ? primaryContainer : lightPrimaryContainer;
      case NovaAccentColor.custom:
        return isDark ? primaryContainer : lightPrimaryContainer;
    }
  }
  
  static Color getOnPrimaryContainer(NovaAccentColor accent, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (accent) {
      case NovaAccentColor.blue:
        return isDark ? const Color(0xFF002A51) : const Color(0xFF001C39);
      case NovaAccentColor.green:
        return isDark ? const Color(0xFF00210E) : const Color(0xFF00210E);
      case NovaAccentColor.orange:
        return isDark ? const Color(0xFF2E1500) : const Color(0xFF2E1500);
      case NovaAccentColor.rose:
        return isDark ? const Color(0xFF3E0010) : const Color(0xFF3E0010);
      case NovaAccentColor.monochrome:
        return isDark ? const Color(0xFFE5E2E3) : const Color(0xFF131314);
      case NovaAccentColor.purple:
        return isDark ? onPrimaryContainer : lightOnPrimaryContainer;
      case NovaAccentColor.custom:
        return isDark ? const Color(0xFFE5E2E3) : const Color(0xFF131314);
    }
  }

  static ColorScheme getColorScheme(Brightness brightness, NovaAccentColor accent, {bool isAmoled = false, Color? customColor}) {
    if (brightness == Brightness.dark) {
      return ColorScheme.dark(
        primary: accent == NovaAccentColor.custom ? (customColor ?? primary) : getPrimary(accent, brightness),
        onPrimary: accent == NovaAccentColor.custom ? const Color(0xFFFFFFFF) : getOnPrimary(accent, brightness),
        primaryContainer: accent == NovaAccentColor.custom ? (customColor ?? primary).withValues(alpha: 0.3) : getPrimaryContainer(accent, brightness),
        onPrimaryContainer: accent == NovaAccentColor.custom ? const Color(0xFFFFFFFF) : getOnPrimaryContainer(accent, brightness),
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: isAmoled ? amoledSurface : surface,
        onSurface: onSurface,
        surfaceContainerHighest: isAmoled ? amoledSurfaceVariant : surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        inversePrimary: inversePrimary,
      );
    } else {
      return ColorScheme.light(
        primary: accent == NovaAccentColor.custom ? (customColor ?? lightPrimary) : getPrimary(accent, brightness),
        onPrimary: accent == NovaAccentColor.custom ? const Color(0xFFFFFFFF) : getOnPrimary(accent, brightness),
        primaryContainer: accent == NovaAccentColor.custom ? (customColor ?? lightPrimary).withValues(alpha: 0.2) : getPrimaryContainer(accent, brightness),
        onPrimaryContainer: accent == NovaAccentColor.custom ? (customColor ?? lightPrimary) : getOnPrimaryContainer(accent, brightness),
        secondary: lightSecondary,
        onSecondary: lightOnSecondary,
        secondaryContainer: lightSecondaryContainer,
        onSecondaryContainer: lightOnSecondaryContainer,
        tertiary: lightTertiary,
        onTertiary: lightOnTertiary,
        tertiaryContainer: lightTertiaryContainer,
        onTertiaryContainer: lightOnTertiaryContainer,
        error: lightError,
        onError: lightOnError,
        errorContainer: lightErrorContainer,
        onErrorContainer: lightOnErrorContainer,
        surface: lightSurface,
        onSurface: lightOnSurface,
        surfaceContainerHighest: lightSurfaceVariant,
        onSurfaceVariant: lightOnSurfaceVariant,
        outline: lightOutline,
        outlineVariant: lightOutlineVariant,
        inverseSurface: onSurface,
        onInverseSurface: surface,
        inversePrimary: primary,
      );
    }
  }

  // Legacy getters mapped to new function
  static ColorScheme get darkColorScheme => getColorScheme(Brightness.dark, NovaAccentColor.purple);
  static ColorScheme get lightColorScheme => getColorScheme(Brightness.light, NovaAccentColor.purple);
  static ColorScheme get amoledColorScheme => getColorScheme(Brightness.dark, NovaAccentColor.purple, isAmoled: true);
}
