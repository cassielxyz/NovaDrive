import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class NovaDriveApp extends ConsumerWidget {
  const NovaDriveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeConfig = ref.watch(themeProvider);
    
    ThemeData lightTheme = AppTheme.getTheme(themeConfig, Brightness.light);
    ThemeData darkTheme = AppTheme.getTheme(themeConfig, Brightness.dark);
    
    ThemeMode themeMode;
    switch (themeConfig.type) {
      case NovaThemeType.light:
        themeMode = ThemeMode.light;
        break;
      case NovaThemeType.dark:
      case NovaThemeType.amoled:
        themeMode = ThemeMode.dark;
        break;
      case NovaThemeType.system:
        themeMode = ThemeMode.system;
        break;
    }
    
    return MaterialApp.router(
      title: 'Nova Drive',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
