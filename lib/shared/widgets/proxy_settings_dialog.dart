import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/telegram_core/tdlib_bridge.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/auth/providers/auth_provider.dart';

class ProxySettingsDialog extends ConsumerStatefulWidget {
  const ProxySettingsDialog({super.key});

  @override
  ConsumerState<ProxySettingsDialog> createState() => _ProxySettingsDialogState();
}

class _ProxySettingsDialogState extends ConsumerState<ProxySettingsDialog> {
  final _formKey = GlobalKey<FormState>();
  
  bool _enabled = false;
  String _type = 'MTProto';
  
  final _serverController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secretController = TextEditingController();

  bool _isLoading = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await ref.read(secureStorageProvider).getProxySettings();
    if (mounted) {
      if (settings != null) {
        setState(() {
          _enabled = settings.enabled;
          _type = settings.type;
          _serverController.text = settings.server;
          _portController.text = settings.port.toString();
          _usernameController.text = settings.username ?? '';
          _passwordController.text = settings.password ?? '';
          _secretController.text = settings.secret ?? '';
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _serverController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final storage = ref.read(secureStorageProvider);

    final settings = ProxySettings(
      enabled: _enabled,
      type: _type,
      server: _serverController.text.trim(),
      port: int.parse(_portController.text.trim()),
      username: _type != 'MTProto' ? _usernameController.text.trim() : null,
      password: _type != 'MTProto' ? _passwordController.text.trim() : null,
      secret: _type == 'MTProto' ? _secretController.text.trim() : null,
    );

    await storage.saveProxySettings(settings);

    if (_enabled) {
      // Retry auth bootstrap to re-trigger auth flow checks
      ref.read(authProvider.notifier).retryBootstrap();
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _clear() async {
    final storage = ref.read(secureStorageProvider);
    await storage.clearProxySettings();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return AlertDialog(
      title: const Text('Proxy Settings'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable Proxy'),
                value: _enabled,
                onChanged: (val) {
                  setState(() {
                    _enabled = val;
                  });
                },
              ),
              if (_enabled) ...[
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'Proxy Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'MTProto', child: Text('MTProto')),
                    DropdownMenuItem(value: 'SOCKS5', child: Text('SOCKS5')),
                    DropdownMenuItem(value: 'HTTP', child: Text('HTTP')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _type = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _serverController,
                  decoration: const InputDecoration(
                    labelText: 'Server',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Server is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _portController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Port is required';
                    }
                    final port = int.tryParse(value);
                    if (port == null || port <= 0 || port > 65535) {
                      return 'Invalid port number';
                    }
                    return null;
                  },
                ),
                if (_type == 'MTProto') ...[
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _secretController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Secret',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Secret is required for MTProto';
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password (Optional)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clear,
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _enabled = true;
              _type = 'MTProto';
              _serverController.text = 'proxy.digitalresistance.dog';
              _portController.text = '443';
              _secretController.text = 'd41d8cd98f00b204e9800998ecf8427e';
            });
          },
          child: const Text('Add Proxy 1'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save & Apply'),
        ),
      ],
    );
  }
}
