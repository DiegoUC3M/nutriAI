import 'package:flutter/material.dart';
import '../../../data/food_database.dart';
import '../../../theme/app_theme.dart';
import 'food_pref_widgets.dart';

class StepFavorites extends StatefulWidget {
  final Set<String> favorites;
  final Set<String> allergies;
  final Set<String> allergyExceptions;
  final Set<String> excludedFoods;
  final ValueChanged<Set<String>> onFavoritesChanged;

  const StepFavorites({
    super.key,
    required this.favorites,
    required this.allergies,
    required this.allergyExceptions,
    this.excludedFoods = const {},
    required this.onFavoritesChanged,
  });

  @override
  State<StepFavorites> createState() => _StepFavoritesState();
}

class _StepFavoritesState extends State<StepFavorites> {
  final _expandedGroups = <int>{};

  @override
  Widget build(BuildContext context) {
    final groups = filteredFoodGroups(widget.allergies, widget.allergyExceptions)
        .map((g) {
          final foods = g.foods.where((f) => !widget.excludedFoods.contains(f)).toList();
          return FoodGroup(emoji: g.emoji, title: g.title, foods: foods);
        })
        .where((g) => g.foods.isNotEmpty)
        .toList();
    final totalFavorites = widget.favorites.length;
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
          SectionHeader(
            icon: Icons.favorite_rounded,
            iconColor: AppColors.secondary,
            title: 'Mis favoritos',
            subtitle: 'Abre cada categoría y selecciona',
            trailing: totalFavorites > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$totalFavorites',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < groups.length; i++) ...[
            ExpandableCategoryCard(
              emoji: groups[i].emoji,
              title: groups[i].title,
              items: groups[i].foods,
              selected: widget.favorites,
              isExpanded: _expandedGroups.contains(i),
              selectedColor: AppColors.secondary,
              onExpand: () => setState(() {
                if (_expandedGroups.contains(i)) {
                  _expandedGroups.remove(i);
                } else {
                  _expandedGroups.add(i);
                }
              }),
              onChanged: widget.onFavoritesChanged,
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
