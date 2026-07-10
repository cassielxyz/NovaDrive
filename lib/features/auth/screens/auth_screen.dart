import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import '../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/telegram_core/tdlib_bridge.dart';
import '../../../core/services/nova_logger.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  String _dialCode = '+91';
  String _flag = '🇮🇳';

  @override
  void initState() {
    super.initState();
    NovaLogger.route('Auth screen mounted');
    // Initialize bridge if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tdlibBridgeProvider).initialize();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Watch for ready state to navigate
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.step == AuthStep.ready) {
        context.go('/dashboard');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'credentials') {
                context.go('/credentials');
              } else if (value == 'reset') {
                ref.read(authProvider.notifier).resetSession();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'credentials',
                child: Text('Edit Developer Credentials'),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Text('Reset TDLib Session'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginDesktop),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.security, size: 48, color: AppColors.primary),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      _getTitle(authState.step),
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (authState.error != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        authState.error!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    _buildForm(authState),
                    ],
                  ),
                ),
              ),
          ),
        ),
    );
  }

  String _getTitle(AuthStep step) {
    switch (step) {
      case AuthStep.loading:
        return 'Connecting to Cloud...';
      case AuthStep.phone:
        return 'Enter Phone Number';
      case AuthStep.code:
        return 'Enter Code';
      case AuthStep.password:
        return 'Enter Password';
      case AuthStep.ready:
        return 'Ready';
      case AuthStep.error:
        return 'Error';
    }
  }

  Widget _buildForm(AuthState authState) {
    switch (authState.step) {
      case AuthStep.loading:
      case AuthStep.ready:
        return const Center(child: CircularProgressIndicator());
      case AuthStep.phone:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: const OutlineInputBorder(),
                prefixIcon: InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      countryListTheme: CountryListThemeData(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        bottomSheetHeight: MediaQuery.of(context).size.height * 0.75,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        searchTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        inputDecoration: InputDecoration(
                          labelText: 'Search country',
                          hintText: 'Start typing to search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        ),
                      ),
                      onSelect: (Country country) {
                        setState(() {
                          _dialCode = '+${country.phoneCode}';
                          _flag = country.flagEmoji;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_flag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(_dialCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 8),
                        Container(
                          height: 24,
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: authState.isProcessing ? null : () {
                final fullNumber = '$_dialCode${_phoneController.text.trim()}';
                ref.read(authProvider.notifier).sendPhoneNumber(fullNumber);
              },
              child: authState.isProcessing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Next'),
            ),
          ],
        );
      case AuthStep.code:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: authState.isProcessing ? null : () {
                ref.read(authProvider.notifier).sendCode(_codeController.text.trim());
              },
              child: authState.isProcessing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Verify'),
            ),
          ],
        );
      case AuthStep.password:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '2FA Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: authState.isProcessing ? null : () {
                ref.read(authProvider.notifier).sendPassword(_passwordController.text.trim());
              },
              child: authState.isProcessing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Unlock'),
            ),
          ],
        );
      case AuthStep.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ref.read(authProvider.notifier).retryBootstrap();
              },
              child: const Text('Retry'),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.go('/credentials');
              },
              child: const Text('Edit Developer Credentials'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              onPressed: () {
                ref.read(authProvider.notifier).resetSession();
              },
              child: const Text('Reset TDLib Session'),
            ),
          ],
        );
    }
  }
}
