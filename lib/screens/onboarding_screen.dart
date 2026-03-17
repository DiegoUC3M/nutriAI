import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}

const _pages = [
  _OnboardingPage(
    icon: Icons.restaurant_menu_rounded,
    iconColor: AppColors.primary,
    title: 'Bienvenido a NutriAI',
    description:
        'Tu asistente inteligente de nutrición personalizada. '
        'Diseña dietas adaptadas a tu cuerpo, objetivos y gustos alimentarios.',
  ),
  _OnboardingPage(
    icon: Icons.tune_rounded,
    iconColor: AppColors.secondary,
    title: 'Personalización total',
    description:
        'Indica tus alimentos favoritos, alergias y lo que no te gusta. '
        'NutriAI creará planes de comida que realmente disfrutarás.',
  ),
  _OnboardingPage(
    icon: Icons.calculate_rounded,
    iconColor: AppColors.accent,
    title: 'Macros a tu medida',
    description:
        'Calculamos tus necesidades calóricas y de macronutrientes '
        'según tu peso, altura, actividad física y objetivo: '
        'perder grasa, mantenerte o ganar músculo.',
  ),
  _OnboardingPage(
    icon: Icons.calendar_month_rounded,
    iconColor: AppColors.warning,
    title: 'Dieta semanal completa',
    description:
        'Genera planes de alimentación día a día con todas las comidas: '
        'desayuno, almuerzo, merienda y cena, ajustados a tus macros.',
  ),
  _OnboardingPage(
    icon: Icons.shopping_cart_rounded,
    iconColor: AppColors.secondaryDark,
    title: 'Lista de la compra',
    description:
        'Obtén automáticamente la lista de ingredientes que necesitas, '
        'organizada por categorías. Solo llévala al supermercado.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skip() => widget.onComplete();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 16),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Saltar' : '',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _PageContent(page: _pages[i]),
              ),
            ),

            // Dots
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1
                        ? 'Siguiente'
                        : 'Empezar',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;

  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 56, color: page.iconColor),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
