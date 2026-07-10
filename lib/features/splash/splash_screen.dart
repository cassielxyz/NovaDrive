import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../core/services/nova_logger.dart';
import '../../core/providers/app_bootstrap_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NovaLogger.route('Splash mounted');
    
    // Start the bootstrap process
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appBootstrapProvider.notifier).startBootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppBootPhase>(appBootstrapProvider, (previous, next) {
      if (next == AppBootPhase.unauthenticated) {
        NovaLogger.route('Routing to: /credentials');
        FlutterNativeSplash.remove();
        context.go('/credentials');
      } else if (next == AppBootPhase.needsAuth) {
        NovaLogger.route('Routing to: /auth');
        FlutterNativeSplash.remove();
        context.go('/auth');
      } else if (next == AppBootPhase.ready) {
        NovaLogger.route('Routing to: /dashboard');
        FlutterNativeSplash.remove();
        context.go('/dashboard');
      } else if (next == AppBootPhase.failed) {
        NovaLogger.route('Bootstrap failed, routing to /auth for fallback');
        FlutterNativeSplash.remove();
        context.go('/auth');
      }
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(), // Empty body, hidden behind native splash anyway
    );
  }
}
