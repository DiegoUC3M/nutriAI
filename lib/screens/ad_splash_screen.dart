import 'package:flutter/material.dart';
import '../services/ad_manager.dart';
import 'home_screen.dart';

/// Splash screen that attempts to show an App Open Ad when the app launches.
///
/// Once the ad is dismissed (or fails to load), the user is automatically
/// navigated to the [HomeScreen].
class AdSplashScreen extends StatefulWidget {
  const AdSplashScreen({super.key});

  @override
  State<AdSplashScreen> createState() => _AdSplashScreenState();
}

class _AdSplashScreenState extends State<AdSplashScreen> {
  final AdManager _adManager = AdManager();

  @override
  void initState() {
    super.initState();
    _loadAndShowAd();
  }

  void _loadAndShowAd() {
    _adManager.loadAd(
      onAdLoaded: () {
        if (!mounted) return;
        _adManager.showAd(
          onAdDismissed: () => _navigateToHome(),
        );
      },
      onAdFailedToLoad: () => _navigateToHome(),
    );
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading screen shown while the ad loads
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 80, color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Gym App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
