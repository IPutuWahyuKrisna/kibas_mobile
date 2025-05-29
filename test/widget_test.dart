import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kibas_mobile/main.dart';
import 'package:kibas_mobile/src/features/auth/presentation/pages/login.dart';
import 'package:kibas_mobile/src/features/start%20pages/presentation/splash__screen.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const KibasApp());

    // Verify that the initial route is loaded (splash screen)
    expect(find.byType(SplashScreen), findsOneWidget);
  });

  // Add more tests for your specific routes and functionality
  testWidgets('Navigation to login screen works', (WidgetTester tester) async {
    await tester.pumpWidget(const KibasApp());

    // Wait for splash screen to complete
    await tester.pumpAndSettle();

    // Verify login screen is shown after splash
    expect(find.byType(LoginPages), findsOneWidget);
  });
}
