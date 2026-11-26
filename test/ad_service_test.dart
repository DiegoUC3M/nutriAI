import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// ignore: implementation_imports
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
// ignore: implementation_imports
import 'package:google_mobile_ads/src/ump/user_messaging_codec.dart';
import 'package:gym_app/l10n/app_localizations.dart';
import 'package:gym_app/services/ad_service.dart';
import 'package:gym_app/widgets/main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Ads are bypassed on desktop without a native plugin', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final ads = AdService.instance;
    await ads.initialize();
    ads.loadInterstitial();
    ads.loadAppOpenAd();
    expect(ads.createBannerAd(onLoaded: () {}), isNull);

    var dismissed = 0;
    ads.showInterstitial(onDismissed: () => dismissed++);
    ads.showAppOpenAd(onDismissed: () => dismissed++);
    expect(dismissed, 2);
  });

  testWidgets(
    'UMP gates every ad format and privacy options refresh the gate',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      final adsChannel = MethodChannel(
        'plugins.flutter.io/google_mobile_ads',
        StandardMethodCodec(AdMessageCodec()),
      );
      final umpChannel = MethodChannel(
        'plugins.flutter.io/google_mobile_ads/ump',
        StandardMethodCodec(UserMessagingCodec()),
      );
      final messenger = tester.binding.defaultBinaryMessenger;
      final calls = <String>[];
      var canRequestAds = false;
      messenger.setMockMethodCallHandler(adsChannel, (call) async {
        calls.add(call.method);
        if (call.method == 'MobileAds#initialize') {
          return InitializationStatus({});
        }
        return null;
      });
      messenger.setMockMethodCallHandler(umpChannel, (call) async {
        calls.add(call.method);
        return switch (call.method) {
          'ConsentInformation#getPrivacyOptionsRequirementStatus' => 1,
          'ConsentInformation#canRequestAds' => canRequestAds,
          'ConsentInformation#requestConsentInfoUpdate' ||
          'UserMessagingPlatform#loadAndShowConsentFormIfRequired' ||
          'UserMessagingPlatform#showPrivacyOptionsForm' => null,
          _ => throw StateError('Unexpected call: ${call.method}'),
        };
      });
      addTearDown(() {
        messenger.setMockMethodCallHandler(adsChannel, null);
        messenger.setMockMethodCallHandler(umpChannel, null);
      });

      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MainShell(),
        ),
      );
      final ads = AdService.instance;
      final privacyOptions = find.text('Opciones de privacidad');
      expect(privacyOptions, findsNothing);
      expect(calls, isEmpty);

      await ads.initialize();
      await tester.pump();
      expect(calls, [
        'ConsentInformation#requestConsentInfoUpdate',
        'UserMessagingPlatform#loadAndShowConsentFormIfRequired',
        'ConsentInformation#getPrivacyOptionsRequirementStatus',
        'ConsentInformation#canRequestAds',
      ]);
      expect(privacyOptions, findsOneWidget);
      expect(find.text('COMPRA'), findsOneWidget);

      calls.clear();
      canRequestAds = true;
      await tester.tap(privacyOptions);
      await tester.pump();
      expect(calls.where((call) => call != '_init'), [
        'UserMessagingPlatform#showPrivacyOptionsForm',
        'ConsentInformation#getPrivacyOptionsRequirementStatus',
        'ConsentInformation#canRequestAds',
        'MobileAds#initialize',
        'loadInterstitialAd',
        'loadAppOpenAd',
        'loadBannerAd',
      ]);

      calls.clear();
      canRequestAds = false;
      await tester.tap(privacyOptions);
      await tester.pump();
      expect(calls, contains('UserMessagingPlatform#showPrivacyOptionsForm'));
      expect(calls, isNot(contains('MobileAds#initialize')));
      expect(calls.where((call) => call.startsWith('load')), isEmpty);
      expect(ads.createBannerAd(onLoaded: () {}), isNull);
    },
    variant: const TargetPlatformVariant({TargetPlatform.android}),
  );
}
