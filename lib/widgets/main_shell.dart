import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../l10n/app_localizations.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';
import '../screens/nutrition/nutrition_flow_screen.dart';
import '../screens/nutrition/steps/step_shopping_list.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentTab = 0;
  List<DietDay>? _dietResult;
  BannerAd? _bannerAd;
  bool _isBannerReady = false;

  @override
  void initState() {
    super.initState();
    AdService.instance.addListener(_adsChanged);
    _loadBanner();
  }

  void _adsChanged() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerReady = false;
    _loadBanner();
    setState(() {});
  }

  void _loadBanner() {
    late final BannerAd? banner;
    banner = AdService.instance.createBannerAd(
      onLoaded: () {
        if (mounted && _bannerAd == banner) {
          setState(() => _isBannerReady = true);
        }
      },
    );
    _bannerAd = banner;
    banner?.load();
  }

  @override
  void dispose() {
    AdService.instance.removeListener(_adsChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: [
          NutritionFlowScreen(
            onDietChanged: (diet) => setState(() => _dietResult = diet),
            onGoToShoppingList: () => setState(() => _currentTab = 1),
          ),
          _buildShoppingTab(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (AdService.instance.privacyOptionsRequired)
            TextButton(
              onPressed: AdService.instance.showPrivacyOptions,
              child: Text(l10n.adPrivacyOptions),
            ),
          if (_isBannerReady && _bannerAd != null)
            Container(
              color: AppColors.background,
              width: double.infinity,
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.surfaceLight, width: 0.5),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentTab,
              onTap: (index) => setState(() => _currentTab = index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.restaurant_menu),
                  label: l10n.tabNutrition,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: l10n.tabShopping,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_dietResult == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.shoppingListTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: AppColors.textMuted.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.noShoppingList,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.noShoppingListDesc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _currentTab = 0),
                    icon: const Icon(Icons.restaurant_menu, size: 20),
                    label: Text(l10n.goToNutrition),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shoppingListTitle)),
      body: StepShoppingList(dietDays: _dietResult),
    );
  }
}
