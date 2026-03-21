import 'package:flutter/material.dart';
import '../../../data/food_database.dart';
import '../../../theme/app_theme.dart';
import 'food_pref_widgets.dart';

const _expandableAllergens = {'Frutos secos', 'Frutas', 'Pescado', 'Mariscos'};

const _allergenConfig = <String, ({IconData icon, Color color})>{
  'Frutos secos': (icon: Icons.forest, color: Color(0xFF92400E)),
  'Gluten': (icon: Icons.bakery_dining, color: Color(0xFFF59E0B)),
  'Huevo': (icon: Icons.egg, color: Color(0xFFFBBF24)),
  'Lactosa': (icon: Icons.local_cafe, color: Color(0xFF60A5FA)),
  'Mariscos': (icon: Icons.set_meal, color: Color(0xFFEF4444)),
  'Pescado': (icon: Icons.phishing, color: Color(0xFF3B82F6)),
  'Soja': (icon: Icons.spa, color: Color(0xFF84CC16)),
  'Frutas': (icon: Icons.apple, color: Color(0xFFEF4444)),
  'Apio': (icon: Icons.grass, color: Color(0xFF22C55E)),
};

class StepAllergies extends StatefulWidget {
  final Set<String> allergies;
  final Set<String> allergyExceptions;
  final ValueChanged<Set<String>> onAllergiesChanged;
  final ValueChanged<Set<String>> onAllergyExceptionsChanged;

  const StepAllergies({
    super.key,
    required this.allergies,
    required this.allergyExceptions,
    required this.onAllergiesChanged,
    required this.onAllergyExceptionsChanged,
  });

  @override
  State<StepAllergies> createState() => _StepAllergiesState();
}

class _StepAllergiesState extends State<StepAllergies> {
  String? _expandedAllergen;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Tienes alergias?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecciona tus alergias o intolerancias. Si no tienes ninguna, pulsa Continuar.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 28),
          SectionCard(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.warning,
            title: 'Alergias e intolerancias',
            subtitle: 'En algunas podrás afinar alimento por alimento.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: allAllergenTags.map((tag) {
                    final isActive = widget.allergies.contains(tag);
                    final config = _allergenConfig[tag];
                    final affectedFoods = foodsWithAllergen(tag);
                    final isExpandable = _expandableAllergens.contains(tag);
                    final isExpanded = _expandedAllergen == tag;

                    return _AllergyChip(
                      tag: tag,
                      icon: config?.icon ?? Icons.warning,
                      color: config?.color ?? AppColors.error,
                      isActive: isActive,
                      isExpandable: isExpandable,
                      isExpanded: isExpanded,
                      affectedCount: isExpandable ? affectedFoods.length : 0,
                      onTap: () {
                        if (!isActive) {
                          widget.allergies.add(tag);
                          widget.onAllergiesChanged(widget.allergies);
                          if (isExpandable) {
                            setState(() => _expandedAllergen = tag);
                          }
                        } else if (isExpandable && !isExpanded) {
                          setState(() => _expandedAllergen = tag);
                        } else {
                          widget.allergies.remove(tag);
                          for (final f in affectedFoods) {
                            widget.allergyExceptions.remove(f.name);
                          }
                          widget.onAllergyExceptionsChanged(widget.allergyExceptions);
                          widget.onAllergiesChanged(widget.allergies);
                          if (_expandedAllergen == tag) {
                            setState(() => _expandedAllergen = null);
                          }
                        }
                      },
                      onLongPress: isActive && isExpandable
                          ? () {
                              // Toggle expand/collapse without deactivating
                              setState(() {
                                _expandedAllergen = isExpanded ? null : tag;
                              });
                            }
                          : null,
                    );
                  }).toList(),
                ),
                if (_expandedAllergen != null &&
                    widget.allergies.contains(_expandedAllergen!) &&
                    _expandableAllergens.contains(_expandedAllergen!))
                  _buildAllergyDetail(_expandedAllergen!),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAllergyDetail(String tag) {
    final foods = foodsWithAllergen(tag);
    final config = _allergenConfig[tag];
    final color = config?.color ?? AppColors.error;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  'Afinar: $tag',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Desmarca los alimentos a los que NO eres alérgico',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: foods.map((food) {
                final isException = widget.allergyExceptions.contains(food.name);
                return GestureDetector(
                  onTap: () {
                    if (isException) {
                      widget.allergyExceptions.remove(food.name);
                    } else {
                      widget.allergyExceptions.add(food.name);
                    }
                    widget.onAllergyExceptionsChanged(widget.allergyExceptions);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isException
                          ? AppColors.secondary.withValues(alpha: 0.15)
                          : AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isException
                            ? AppColors.secondary
                            : AppColors.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isException ? Icons.check_circle : Icons.block,
                          size: 15,
                          color: isException ? AppColors.secondary : AppColors.error,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          food.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isException ? AppColors.secondary : AppColors.error,
                            decoration: isException ? null : TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private allergy chip ───────────────────────────────────────

class _AllergyChip extends StatelessWidget {
  final String tag;
  final IconData icon;
  final Color color;
  final bool isActive;
  final bool isExpandable;
  final bool isExpanded;
  final int affectedCount;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _AllergyChip({
    required this.tag,
    required this.icon,
    required this.color,
    required this.isActive,
    this.isExpandable = false,
    this.isExpanded = false,
    required this.affectedCount,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.15)
              : AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : AppColors.surfaceLight,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? color : AppColors.textMuted),
            const SizedBox(width: 8),
            Text(
              tag,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? color : AppColors.textSecondary,
              ),
            ),
            if (isActive && affectedCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$affectedCount',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
            if (isActive && isExpandable) ...[
              const SizedBox(width: 4),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
