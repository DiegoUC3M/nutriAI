import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.surfaceLight, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (index) => setState(() => _currentTab = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'NUTRICIÓN',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'COMPRA',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingTab() {
    if (_dietResult == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lista de la compra')),
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
                const Text(
                  'Sin lista de compra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Genera una dieta primero desde la pestaña de Nutrición para ver tu lista de la compra.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                    label: const Text('Ir a Nutrición'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de la compra')),
      body: StepShoppingList(dietDays: _dietResult),
    );
  }
}
