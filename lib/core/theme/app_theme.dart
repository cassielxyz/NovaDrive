import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'theme_provider.dart';
import 'app_radius.dart';

class AppTheme {
  AppTheme._();

  static ThemeData getTheme(NovaThemeConfig config, Brightness systemBrightness) {
    Brightness brightness;
    if (config.type == NovaThemeType.system) {
      brightness = systemBrightness;
    } else {
      brightness = config.type == NovaThemeType.dark || config.type == NovaThemeType.amoled
          ? Brightness.dark
          : Brightness.light;
    }

    final colorScheme = AppColors.getColorScheme(
      brightness, 
      config.accent, 
      isAmoled: config.isAmoled,
      customColor: config.customColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: AppTypography.textTheme,
      fontFamily: AppTypography.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusXl,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
      ),
    );
  }
}
