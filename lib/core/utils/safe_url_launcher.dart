import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/nova_logger.dart';

class SafeUrlLauncher {
  static const List<String> _allowedSchemes = ['https'];

  static Future<void> launchExternal(
    BuildContext context,
    String urlString, {
    List<String> allowedHosts = const [],
  }) async {
    // 1. Check placeholder
    if (urlString.contains('PASTE_') || urlString.isEmpty || urlString == 'Coming soon') {
      NovaLogger.security('Placeholder URL click blocked: $urlString');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link coming soon.')),
        );
      }
      return;
    }

    try {
      // 2. Parse URI
      final uri = Uri.parse(urlString);

      // 3. Check scheme
      if (!_allowedSchemes.contains(uri.scheme.toLowerCase())) {
        NovaLogger.error('NOVA_SECURITY', 'Unsafe URL blocked (invalid scheme): $urlString');
        _showError(context);
        return;
      }

      // 4. Validate host if provided
      if (allowedHosts.isNotEmpty) {
        bool hostAllowed = false;
        for (final host in allowedHosts) {
          if (uri.host.toLowerCase().endsWith(host.toLowerCase())) {
            hostAllowed = true;
            break;
          }
        }
        if (!hostAllowed) {
          NovaLogger.error('NOVA_SECURITY', 'Unsafe URL blocked (host not allowed): $urlString');
          _showError(context);
          return;
        }
      }

      // 5. Call canLaunchUrl
      if (await canLaunchUrl(uri)) {
        // 6. Launch external application
        NovaLogger.security('Safe URL opened: $urlString');
        if (!context.mounted) return;
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        NovaLogger.error('NOVA_SECURITY', 'URL launch failed (cannot launch): $urlString');
        if (!context.mounted) return;
        _showError(context);
      }
    } catch (e) {
      NovaLogger.error('NOVA_SECURITY', 'URL launch failed (parse error): $e');
      if (!context.mounted) return;
      _showError(context);
    }
  }

  static void _showError(BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid or unsafe link blocked.')),
      );
    }
  }
}
