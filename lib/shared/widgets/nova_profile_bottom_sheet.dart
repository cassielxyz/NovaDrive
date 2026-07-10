import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handy_tdlib/handy_tdlib.dart' as td;
import '../../core/theme/app_spacing.dart';

class NovaProfileBottomSheet extends StatelessWidget {
  final td.User user;

  const NovaProfileBottomSheet({super.key, required this.user});

  static void show(BuildContext context, td.User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NovaProfileBottomSheet(user: user),
    );
  }

  String _getStatusText() {
    final status = user.status;
    if (status is td.UserStatusOnline) return 'Online';
    if (status is td.UserStatusOffline) return 'Offline';
    if (status is td.UserStatusRecently) return 'Last seen recently';
    if (status is td.UserStatusLastWeek) return 'Last seen last week';
    if (status is td.UserStatusLastMonth) return 'Last seen last month';
    return 'Status unknown';
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = (user.profilePhoto?.small.local.isDownloadingCompleted ?? false) &&
        user.profilePhoto!.small.local.path.isNotEmpty;
    final fullName = '${user.firstName} ${user.lastName}'.trim();
    final username = user.usernames?.activeUsernames.isNotEmpty == true 
        ? '@${user.usernames!.activeUsernames.first}' 
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: hasPhoto ? FileImage(File(user.profilePhoto!.small.local.path)) : null,
              child: hasPhoto
                  ? null
                  : Text(
                      user.firstName.isNotEmpty ? user.firstName[0] : 'U',
                      style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              fullName.isNotEmpty ? fullName : 'Unknown User',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (username != null) ...[
              const SizedBox(height: 4),
              Text(
                username,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              _getStatusText(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: user.status is td.UserStatusOnline 
                    ? Colors.green 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (user.phoneNumber.isNotEmpty)
              ListTile(
                leading: Icon(Icons.phone, color: Theme.of(context).colorScheme.primary),
                title: Text('Phone Number'),
                subtitle: Text('+${user.phoneNumber}'),
              ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
              title: Text('Telegram ID'),
              subtitle: Text(user.id.toString()),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
