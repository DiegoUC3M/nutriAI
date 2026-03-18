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

class StepDisliked extends StatefulWidget {
  final Set<String> disliked;
  final ValueChanged<Set<String>> onDislikedChanged;

  const StepDisliked({
    super.key,
    required this.disliked,
    required this.onDislikedChanged,
  });

  @override
  State<StepDisliked> createState() => _StepDislikedState();
}

class _StepDislikedState extends State<StepDisliked> {
  final _expandedCats = <FoodCategory>{};

  @override
  Widget build(BuildContext context) {
    final totalDisliked = widget.disliked.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Qué no te gusta?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Estos alimentos nunca aparecerán en tu dieta. Si no quieres descartar nada, pulsa Continuar.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            icon: Icons.block_rounded,
            iconColor: AppColors.error,
            title: 'No me gustan',
            subtitle: 'Abre cada categoría y selecciona',
            trailing: totalDisliked > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$totalDisliked',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          for (final cfg in _categoryConfig) ...[
            ExpandableCategoryCard(
              emoji: cfg.emoji,
              title: cfg.title,
              items: foodNamesFor(cfg.cat),
              selected: widget.disliked,
              isExpanded: _expandedCats.contains(cfg.cat),
              onExpand: () => setState(() {
                if (_expandedCats.contains(cfg.cat)) {
                  _expandedCats.remove(cfg.cat);
                } else {
                  _expandedCats.add(cfg.cat);
                }
              }),
              onChanged: widget.onDislikedChanged,
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
