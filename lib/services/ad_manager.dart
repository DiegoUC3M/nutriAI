import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Manages App Open Ads for the application.
///
/// Loads and shows a full-screen ad when the app is first launched.
/// Uses Google test ad unit IDs by default — replace them with your real
/// ad unit IDs before publishing to production.
class AdManager {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  /// Google-provided test ad unit IDs.
  /// Replace with your own ad unit IDs for production.
  String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9257395921';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/5575463023';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  bool get isAdLoaded => _isAdLoaded;

  /// Loads an App Open Ad.
  ///
  /// [onAdLoaded] is called when the ad finishes loading successfully.
  /// [onAdFailedToLoad] is called if the ad fails to load.
  void loadAd({
    Function? onAdLoaded,
    Function? onAdFailedToLoad,
  }) {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdLoaded = true;
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          onAdFailedToLoad?.call();
        },
      ),
    );
  }

  /// Shows the loaded App Open Ad.
  ///
  /// [onAdDismissed] is called when the user closes the ad.
  void showAd({Function? onAdDismissed}) {
    if (!_isAdLoaded || _appOpenAd == null) {
      onAdDismissed?.call();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        _isAdLoaded = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpenAd = null;
        _isAdLoaded = false;
        onAdDismissed?.call();
      },
    );

    _appOpenAd!.show();
  }

  /// Disposes the ad to free resources.
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isAdLoaded = false;
  }
}
