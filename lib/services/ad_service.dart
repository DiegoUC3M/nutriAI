import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Servicio centralizado para gestionar anuncios de AdMob.
/// En web, los anuncios están deshabilitados (google_mobile_ads no soporta web).
class AdService {
  AdService._();
  static final instance = AdService._();

  // ── Detecta si estamos en entorno de desarrollo ──
  static bool get _useTestIds => kDebugMode;

  // ── Banner Ad Unit IDs ──
  static const _bannerAndroidTest = 'ca-app-pub-3940256099942544/6300978111';
  static const _bannerIosTest     = 'ca-app-pub-3940256099942544/2934735716';
  static const _bannerAndroidProd = 'ca-app-pub-3923796247100081/7952635147';
  static const _bannerIosProd     = _bannerIosTest; // no se publica en iOS

  // ── Rewarded Ad Unit IDs ──
  static const _rewardedAndroidTest = 'ca-app-pub-3940256099942544/5224354917';
  static const _rewardedIosTest     = 'ca-app-pub-3940256099942544/1712485313';
  static const _rewardedAndroidProd = 'ca-app-pub-3923796247100081/5776930342';
  static const _rewardedIosProd     = _rewardedIosTest; // no se publica en iOS

  String get bannerAdUnitId {
    if (_useTestIds) {
      return Platform.isAndroid ? _bannerAndroidTest : _bannerIosTest;
    }
    return Platform.isAndroid ? _bannerAndroidProd : _bannerIosProd;
  }

  String get rewardedAdUnitId {
    if (_useTestIds) {
      return Platform.isAndroid ? _rewardedAndroidTest : _rewardedIosTest;
    }
    return Platform.isAndroid ? _rewardedAndroidProd : _rewardedIosProd;
  }

  RewardedAd? _rewardedAd;
  bool get isRewardedAdReady => !kIsWeb && _rewardedAd != null;

  // ── Inicialización ──

  Future<void> initialize() async {
    if (kIsWeb) return;
    await MobileAds.instance.initialize();
  }

  // ── Banner ──

  BannerAd? createBannerAd({required void Function() onLoaded}) {
    if (kIsWeb) return null;
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

  // ── Rewarded ──

  void loadRewarded() {
    if (kIsWeb) return;
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Shows the rewarded ad. Calls [onRewarded] when user earns reward,
  /// or calls it immediately if no ad is available (graceful fallback).
  void showRewarded({required VoidCallback onRewarded}) {
    if (kIsWeb || _rewardedAd == null) {
      onRewarded();
      return;
    }
    _rewardedAd!.show(
      onUserEarnedReward: (a, b) => onRewarded(),
    );
  }
}
