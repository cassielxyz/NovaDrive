import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/services/telegram_storage_service.dart';
import '../../core/services/telegram_sync_service.dart';
import '../../core/providers/storage_stats_provider.dart';
import '../auth/providers/auth_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../shared/widgets/nova_glass_card.dart';
import '../../shared/widgets/proxy_settings_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildSectionHeader(context, 'Account'),
          NovaGlassCard(
            padding: EdgeInsets.zero,
            heavyBlur: false,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                  title: Text('Telegram Account', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  subtitle: Text('Connected', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
                    title: Text('Developer Credentials', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    subtitle: Text('Update API ID and Hash', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    onTap: () => context.push('/credentials'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.vpn_key, color: Theme.of(context).colorScheme.primary),
                    title: Text('Proxy Settings', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    subtitle: Text('Configure MTProto, SOCKS5 or HTTP Proxy', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ProxySettingsDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, 'Appearance'),
          NovaGlassCard(
            padding: EdgeInsets.zero,
            heavyBlur: false,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.dark_mode, color: Theme.of(context).colorScheme.primary),
                  title: Text('Theme', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  trailing: DropdownButton<NovaThemeType>(
                    value: themeConfig.type,
                    underline: const SizedBox(),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    items: const [
                      DropdownMenuItem(value: NovaThemeType.system, child: Text('System Default')),
                      DropdownMenuItem(value: NovaThemeType.light, child: Text('Light')),
                      DropdownMenuItem(value: NovaThemeType.dark, child: Text('Dark')),
                      DropdownMenuItem(value: NovaThemeType.amoled, child: Text('Pure AMOLED')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeProvider.notifier).setType(value);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.blur_on, color: Theme.of(context).colorScheme.primary),
                  title: Text('Glass Effect Intensity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  trailing: Switch(
                    value: themeConfig.enableGlass,
                    onChanged: (val) {
                      ref.read(themeProvider.notifier).setGlassIntensity(val ? GlassIntensity.medium : GlassIntensity.off);
                    },
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.animation, color: Theme.of(context).colorScheme.primary),
                  title: Text('Reduce UI Motion', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  subtitle: Text('Disables heavy animations to improve performance', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                  trailing: Switch(
                    value: themeConfig.reduceMotion,
                    onChanged: (val) {
                      ref.read(themeProvider.notifier).setReduceMotion(val);
                    },
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
                  title: Text('Accent Color', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  trailing: DropdownButton<NovaAccentColor>(
                    value: themeConfig.accent,
                    underline: const SizedBox(),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    items: const [
                      DropdownMenuItem(value: NovaAccentColor.purple, child: Text('Purple')),
                      DropdownMenuItem(value: NovaAccentColor.blue, child: Text('Blue')),
                      DropdownMenuItem(value: NovaAccentColor.green, child: Text('Green')),
                      DropdownMenuItem(value: NovaAccentColor.orange, child: Text('Orange')),
                      DropdownMenuItem(value: NovaAccentColor.rose, child: Text('Rose')),
                      DropdownMenuItem(value: NovaAccentColor.monochrome, child: Text('Monochrome')),
                      DropdownMenuItem(value: NovaAccentColor.custom, child: Text('Custom (Color Wheel)')),
                    ],
                    onChanged: (value) async {
                      if (value == NovaAccentColor.custom) {
                        Color pickerColor = themeConfig.customColor;
                        final selectedColor = await showDialog<Color>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: (color) => pickerColor = color,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Got it'),
                                onPressed: () => Navigator.of(context).pop(pickerColor),
                              ),
                            ],
                          ),
                        );
                        if (selectedColor != null) {
                          ref.read(themeProvider.notifier).setCustomColor(selectedColor);
                        } else {
                          ref.read(themeProvider.notifier).setAccent(NovaAccentColor.custom);
                        }
                      } else if (value != null) {
                        ref.read(themeProvider.notifier).setAccent(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, 'Storage & Cache'),
          Consumer(
            builder: (context, ref, _) {
              final statsAsync = ref.watch(storageStatsProvider);
              return statsAsync.when(
                data: (stats) {
                  final sizeMb = (stats.usedBytes / (1024 * 1024)).toStringAsFixed(1);
                  return NovaGlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    heavyBlur: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Storage Used', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        const SizedBox(height: AppSpacing.xs),
                        Text('$sizeMb MB', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${stats.fileCount} Files', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            Text('${stats.folderCount} Folders', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text('Failed to load stats', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          NovaGlassCard(
            padding: EdgeInsets.zero,
            heavyBlur: false,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.sync, color: Theme.of(context).colorScheme.primary),
                  title: Text('Sync Now', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  subtitle: Text('Last sync: Just now', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  onTap: () async {
                    final storage = ref.read(telegramStorageProvider);
                    if (storage.savedMessagesChatId != null) {
                      await ref.read(telegramSyncProvider).startRecoverySync(
                        storage.savedMessagesChatId!, 
                        clearLocal: false,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sync completed')),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.sync_problem, color: Theme.of(context).colorScheme.error),
                  title: Text('Rebuild Nova Drive Index', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  subtitle: Text('Clear local cache and resync', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        title: Text('Rebuild Index?', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                        content: Text('This will clear your local file database and rebuild it from Telegram. No actual files will be deleted.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Rebuild', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      final storage = ref.read(telegramStorageProvider);
                      if (storage.savedMessagesChatId != null) {
                        await ref.read(telegramSyncProvider).startRecoverySync(
                          storage.savedMessagesChatId!, 
                          clearLocal: true,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Index rebuilt successfully')),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, 'Security'),
          NovaGlassCard(
            padding: EdgeInsets.zero,
            heavyBlur: false,
            child: ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
              title: Text('Logout', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () {
                ref.read(authProvider.notifier).resetSession();
                context.go('/splash');
              },
            ),
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Text(
              'Nova Drive v1.0.0',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
