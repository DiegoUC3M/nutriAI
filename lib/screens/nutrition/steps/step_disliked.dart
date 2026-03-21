import 'package:flutter/material.dart';
import '../../../data/food_database.dart';
import '../../../theme/app_theme.dart';
import 'food_pref_widgets.dart';

class StepDisliked extends StatefulWidget {
  final Set<String> disliked;
  final Set<String> allergies;
  final Set<String> allergyExceptions;
  final Set<String> excludedFoods;
  final ValueChanged<Set<String>> onDislikedChanged;

  const StepDisliked({
    super.key,
    required this.disliked,
    required this.allergies,
    required this.allergyExceptions,
    this.excludedFoods = const {},
    required this.onDislikedChanged,
  });

  @override
  State<StepDisliked> createState() => _StepDislikedState();
}

class _StepDislikedState extends State<StepDisliked> {
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: AppColors.warning),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Si no seleccionas nada, significa que no quieres descartar ningún alimento. Los que marques aquí no aparecerán en tu dieta.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
          for (var i = 0; i < groups.length; i++) ...[
            ExpandableCategoryCard(
              emoji: groups[i].emoji,
              title: groups[i].title,
              items: groups[i].foods,
              selected: widget.disliked,
              isExpanded: _expandedGroups.contains(i),
              onExpand: () => setState(() {
                if (_expandedGroups.contains(i)) {
                  _expandedGroups.remove(i);
                } else {
                  _expandedGroups.add(i);
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
