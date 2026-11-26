// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.binding.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    const adsChannel = 'plugins.flutter.io/google_mobile_ads';
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMessageHandler(
      adsChannel,
      (_) async => const StandardMethodCodec().encodeSuccessEnvelope(null),
    );
    addTearDown(() => messenger.setMockMessageHandler(adsChannel, null));

    await tester.pumpWidget(const MyApp(showOnboarding: false));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify the app renders the bottom navigation
    expect(find.text('NUTRICIÓN'), findsOneWidget);
  });
}
