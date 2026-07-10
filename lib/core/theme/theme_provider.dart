import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NovaThemeType {
  light,
  dark,
  amoled,
  system,
}

enum NovaThemeVariant {
  defaultNova,
  softGlass,
  graphite,
  pureAmoled,
}

enum NovaAccentColor {
  purple,
  blue,
  green,
  orange,
  rose,
  monochrome,
  custom,
}

enum GlassIntensity {
  off,
  low,
  medium,
  high,
}

class NovaThemeConfig {
  final NovaThemeType type;
  final NovaThemeVariant variant;
  final NovaAccentColor accent;
  final GlassIntensity glassIntensity;
  final Color customColor;
  final bool reduceMotion;

  const NovaThemeConfig({
    this.type = NovaThemeType.light,
    this.variant = NovaThemeVariant.defaultNova,
    this.accent = NovaAccentColor.purple,
    this.glassIntensity = GlassIntensity.low,
    this.customColor = const Color(0xFF6750A4),
    this.reduceMotion = false,
  });

  NovaThemeConfig copyWith({
    NovaThemeType? type,
    NovaThemeVariant? variant,
    NovaAccentColor? accent,
    GlassIntensity? glassIntensity,
    Color? customColor,
    bool? reduceMotion,
  }) {
    return NovaThemeConfig(
      type: type ?? this.type,
      variant: variant ?? this.variant,
      accent: accent ?? this.accent,
      glassIntensity: glassIntensity ?? this.glassIntensity,
      customColor: customColor ?? this.customColor,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }

  bool get isAmoled => variant == NovaThemeVariant.pureAmoled || type == NovaThemeType.amoled;
  bool get enableGlass => glassIntensity != GlassIntensity.off;
}

class ThemeNotifier extends Notifier<NovaThemeConfig> {
  @override
  NovaThemeConfig build() => const NovaThemeConfig();

  void setType(NovaThemeType type) {
    state = state.copyWith(type: type);
  }

  void setVariant(NovaThemeVariant variant) {
    state = state.copyWith(
      variant: variant,
      glassIntensity: variant == NovaThemeVariant.pureAmoled ? GlassIntensity.off : state.glassIntensity,
    );
  }

  void setAccent(NovaAccentColor accent) {
    state = state.copyWith(accent: accent);
  }

  void setCustomColor(Color color) {
    state = state.copyWith(customColor: color, accent: NovaAccentColor.custom);
  }

  void setGlassIntensity(GlassIntensity intensity) {
    state = state.copyWith(glassIntensity: intensity);
  }

  void setReduceMotion(bool reduce) {
    state = state.copyWith(reduceMotion: reduce);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, NovaThemeConfig>(
  ThemeNotifier.new,
);
