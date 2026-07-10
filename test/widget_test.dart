import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:novadrive/app.dart';
import 'package:novadrive/features/splash/splash_screen.dart';

void main() {
  testWidgets('App starts on Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: NovaDriveApp(),
      ),
    );

    // Verify that the splash screen is initially displayed.
    expect(find.byType(SplashScreen), findsOneWidget);
    
    // Exhaust the splash screen timer so the test framework doesn't throw a pending timer error
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
