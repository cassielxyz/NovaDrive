import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_tdlib/handy_tdlib.dart';
import '../telegram_core/tdlib_bridge.dart';
import '../services/nova_logger.dart';
import '../services/secure_storage_service.dart';
import '../services/telegram_storage_service.dart';


enum AppBootPhase {
  idle,
  initializingDatabase,
  checkingSession,
  initializingTdlib,
  needsAuth,
  authenticated,
  unauthenticated,
  ready,
  failed,
}

class AppBootstrapNotifier extends Notifier<AppBootPhase> {
  @override
  AppBootPhase build() {
    return AppBootPhase.idle;
  }

  Future<void> startBootstrap() async {
    if (state != AppBootPhase.idle && state != AppBootPhase.failed) {
      return;
    }
    
    try {
      state = AppBootPhase.checkingSession;
      NovaLogger.route('Bootstrap: Checking session');
      final storage = ref.read(secureStorageProvider);
      final credentials = await storage.getCredentials();
      
      if (credentials == null) {
        NovaLogger.route('Bootstrap: Unauthenticated');
        state = AppBootPhase.unauthenticated;
        return;
      }
      
      state = AppBootPhase.initializingTdlib;
      NovaLogger.route('Bootstrap: Initializing TDLib');
      
      final bridge = ref.read(tdlibBridgeProvider);
      await bridge.initialize();
      
      // Wait for auth state
      final authCompleter = Completer<AppBootPhase>();
      final sub = bridge.updates.listen((object) {
        if (object is UpdateAuthorizationState) {
          final authState = object.authorizationState;
          if (authState is AuthorizationStateReady) {
            if (!authCompleter.isCompleted) authCompleter.complete(AppBootPhase.authenticated);
          } else if (authState is AuthorizationStateWaitPhoneNumber || 
                     authState is AuthorizationStateWaitCode || 
                     authState is AuthorizationStateWaitPassword) {
            if (!authCompleter.isCompleted) authCompleter.complete(AppBootPhase.needsAuth);
          }
        } else if (object is AuthorizationState) {
          if (object is AuthorizationStateReady) {
            if (!authCompleter.isCompleted) authCompleter.complete(AppBootPhase.authenticated);
          } else if (object is AuthorizationStateWaitPhoneNumber || 
                     object is AuthorizationStateWaitCode || 
                     object is AuthorizationStateWaitPassword) {
            if (!authCompleter.isCompleted) authCompleter.complete(AppBootPhase.needsAuth);
          }
        } else if (object is TdError) {
          NovaLogger.route('Bootstrap: TdError received: ${object.code} ${object.message}');
          if (!authCompleter.isCompleted) authCompleter.complete(AppBootPhase.failed);
        }
      });
      
      AppBootPhase phase;
      try {
        phase = await authCompleter.future.timeout(const Duration(seconds: 15));
      } catch (e) {
        NovaLogger.route('Bootstrap: TDLib auth timeout, assuming needsAuth');
        phase = AppBootPhase.needsAuth;
      } finally {
        sub.cancel();
      }
      
      if (phase == AppBootPhase.needsAuth) {
        NovaLogger.route('Bootstrap: Needs Auth');
        state = AppBootPhase.needsAuth;
        return;
      }
      
      // Now it's authenticated, we can initialize telegram storage safely
      final telegramStorage = ref.read(telegramStorageProvider);
      await telegramStorage.initialize();
      
      if (telegramStorage.savedMessagesChatId != null) {
        NovaLogger.route('Bootstrap: Authenticated & Ready');
        state = AppBootPhase.ready;
      } else {
        state = AppBootPhase.failed;
      }
    } catch (e) {
      NovaLogger.route('Bootstrap Failed: $e');
      state = AppBootPhase.failed;
    }
  }

  void retryBootstrap() {
    state = AppBootPhase.idle;
    startBootstrap();
  }
}

final appBootstrapProvider = NotifierProvider<AppBootstrapNotifier, AppBootPhase>(() {
  return AppBootstrapNotifier();
});
