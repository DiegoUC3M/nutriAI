import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Servicio centralizado para gestionar anuncios de AdMob.
/// Google Mobile Ads solo se admite en Android e iOS.
class AdService {
  AdService._();
  static final instance = AdService._();

  // ── Detecta si estamos en entorno de desarrollo ──
  static bool get _useTestIds => kDebugMode;
  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get _adsSupported =>
      !kIsWeb && (_isAndroid || defaultTargetPlatform == TargetPlatform.iOS);

  // ── Banner Ad Unit IDs ──
  static const _bannerAndroidTest = 'ca-app-pub-3940256099942544/6300978111';
  static const _bannerIosTest     = 'ca-app-pub-3940256099942544/2934735716';
  static const _bannerAndroidProd = 'ca-app-pub-3923796247100081/7952635147';
  static const _bannerIosProd     = _bannerIosTest; // no se publica en iOS

  // ── Rewarded Ad Unit IDs (comentado por si se usa en el futuro) ──
  // static const _rewardedAndroidTest = 'ca-app-pub-3940256099942544/5224354917';
  // static const _rewardedIosTest     = 'ca-app-pub-3940256099942544/1712485313';
  // static const _rewardedAndroidProd = 'ca-app-pub-3923796247100081/5776930342';
  // static const _rewardedIosProd     = _rewardedIosTest;

  // ── Interstitial Ad Unit IDs ──
  static const _interstitialAndroidTest = 'ca-app-pub-3940256099942544/1033173712';
  static const _interstitialIosTest     = 'ca-app-pub-3940256099942544/4411468910';
  static const _interstitialAndroidProd = 'ca-app-pub-3923796247100081/4229621364';
  static const _interstitialIosProd     = _interstitialIosTest; // no se publica en iOS

  // ── App Open Ad Unit IDs ──
  static const _appOpenAndroidTest = 'ca-app-pub-3940256099942544/9257395921';
  static const _appOpenIosTest     = 'ca-app-pub-3940256099942544/5575463023';
  static const _appOpenAndroidProd = 'ca-app-pub-3923796247100081/8234780135';
  static const _appOpenIosProd     = _appOpenIosTest; // no se publica en iOS

  String get bannerAdUnitId {
    if (_useTestIds) {
      return _isAndroid ? _bannerAndroidTest : _bannerIosTest;
    }
    return _isAndroid ? _bannerAndroidProd : _bannerIosProd;
  }

  String get interstitialAdUnitId {
    if (_useTestIds) {
      return _isAndroid ? _interstitialAndroidTest : _interstitialIosTest;
    }
    return _isAndroid ? _interstitialAndroidProd : _interstitialIosProd;
  }

  String get appOpenAdUnitId {
    if (_useTestIds) {
      return _isAndroid ? _appOpenAndroidTest : _appOpenIosTest;
    }
    return _isAndroid ? _appOpenAndroidProd : _appOpenIosProd;
  }

  InterstitialAd? _interstitialAd;
  AppOpenAd? _appOpenAd;
  bool get isInterstitialAdReady => _adsSupported && _interstitialAd != null;
  bool get isAppOpenAdReady => _adsSupported && _appOpenAd != null;

  // ── Inicialización ──

  Future<void> initialize() async {
    if (!_adsSupported) return;
    await MobileAds.instance.initialize();
  }

  // ── Banner ──

  BannerAd? createBannerAd({required void Function() onLoaded}) {
    if (!_adsSupported) return null;
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  // ── Interstitial ──

  void loadInterstitial() {
    if (!_adsSupported) return;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Shows the interstitial ad. Calls [onDismissed] when the user closes it,
  /// or calls it immediately if no ad is available (graceful fallback).
  void showInterstitial({required VoidCallback onDismissed}) {
    if (!isInterstitialAdReady) {
      onDismissed();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onDismissed();
      },
    );
    _interstitialAd!.show();
  }

  // ── Rewarded (comentado por si se usa en el futuro) ──
  //
  // RewardedAd? _rewardedAd;
  // bool get isRewardedAdReady => !kIsWeb && _rewardedAd != null;
  //
  // String get rewardedAdUnitId {
  //   if (_useTestIds) {
  //     return Platform.isAndroid ? _rewardedAndroidTest : _rewardedIosTest;
  //   }
  //   return Platform.isAndroid ? _rewardedAndroidProd : _rewardedIosProd;
  // }
  //
  // void loadRewarded() {
  //   if (kIsWeb) return;
  //   RewardedAd.load(
  //     adUnitId: rewardedAdUnitId,
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _rewardedAd = ad;
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             _rewardedAd = null;
  //             loadRewarded();
  //           },
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             debugPrint('Rewarded ad failed to show: $error');
  //             ad.dispose();
  //             _rewardedAd = null;
  //             loadRewarded();
  //           },
  //         );
  //       },
  //       onAdFailedToLoad: (error) {
  //         debugPrint('Rewarded ad failed to load: $error');
  //         _rewardedAd = null;
  //       },
  //     ),
  //   );
  // }
  //
  // void showRewarded({required VoidCallback onRewarded}) {
  //   if (kIsWeb || _rewardedAd == null) {
  //     onRewarded();
  //     return;
  //   }
  //   _rewardedAd!.show(
  //     onUserEarnedReward: (a, b) => onRewarded(),
  //   );
  // }

  // ── App Open Ad ──

  void loadAppOpenAd() {
    if (!_adsSupported) return;
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('App Open Ad failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Shows the app open ad. Calls [onDismissed] when the user closes it
  /// or immediately if no ad is available.
  void showAppOpenAd({required VoidCallback onDismissed}) {
    if (!isAppOpenAdReady) {
      onDismissed();
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('App Open Ad failed to show: $error');
        ad.dispose();
        _appOpenAd = null;
        onDismissed();
      },
    );
    _appOpenAd!.show();
  }
}
