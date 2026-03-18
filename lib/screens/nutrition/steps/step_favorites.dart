import 'package:flutter/material.dart';
import '../../../data/food_database.dart';
import '../../../theme/app_theme.dart';
import 'food_pref_widgets.dart';

const _categoryConfig = <({FoodCategory cat, String emoji, String title})>[
  (cat: FoodCategory.protein, emoji: '🥩', title: 'Proteínas'),
  (cat: FoodCategory.carb, emoji: '🌾', title: 'Carbohidratos'),
  (cat: FoodCategory.fat, emoji: '🥑', title: 'Grasas saludables'),
  (cat: FoodCategory.vegetable, emoji: '🥬', title: 'Verduras'),
  (cat: FoodCategory.fruit, emoji: '🍎', title: 'Frutas'),
  (cat: FoodCategory.dairy, emoji: '🥛', title: 'Lácteos'),
];

class StepFavorites extends StatelessWidget {
  final Set<String> favorites;
  final ValueChanged<Set<String>> onFavoritesChanged;

  const StepFavorites({
    super.key,
    required this.favorites,
    required this.onFavoritesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Qué te gusta comer?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecciona tus alimentos favoritos. Aparecerán con más frecuencia en tu dieta.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 24),
          for (final cfg in _categoryConfig) ...[
            CategoryCard(
              emoji: cfg.emoji,
              title: cfg.title,
              items: foodNamesFor(cfg.cat),
              selected: favorites,
              selectedColor: AppColors.secondary,
              onChanged: onFavoritesChanged,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
