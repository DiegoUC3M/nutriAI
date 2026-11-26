import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/services/ad_service.dart';

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
}
