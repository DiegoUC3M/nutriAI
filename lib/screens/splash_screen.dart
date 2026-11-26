import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // Logo scale: starts small, bounces to full size
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 45,
      ),
    ]).animate(_controller);

    // Logo opacity: fade in quickly
    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Text opacity: appears after logo
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
      ),
    );

    // Fade out everything at the end
    _fadeOut = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.82, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) {
        // Show App Open Ad, then navigate
        AdService.instance.showAppOpenAd(
          onDismissed: () {
            if (mounted) {
              _navigateToNextScreen();
            }
          },
        );
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, a1, a2) => widget.nextScreen,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, a2, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Opacity(
            opacity: _fadeOut.value,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.asset(
                            'assets/icon/app_icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App name
                  Opacity(
                    opacity: _textOpacity.value,
                    child: const Text(
                      'NutriAI',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  Opacity(
                    opacity: _textOpacity.value,
                    child: Text(
                      AppLocalizations.of(context)?.splashTagline ?? 'Tu nutrición inteligente',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
