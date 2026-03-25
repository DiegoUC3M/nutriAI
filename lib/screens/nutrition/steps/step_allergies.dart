import 'package:flutter/material.dart';
import '../../../data/food_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/translations.dart';
import '../../../theme/app_theme.dart';
import 'food_pref_widgets.dart';

const _expandableAllergens = {'Frutos secos', 'Frutas', 'Pescado', 'Mariscos', 'Semillas'};

const _allergenConfig = <String, ({IconData icon, Color color})>{
  'Frutos secos': (icon: Icons.forest, color: Color(0xFF92400E)),
  'Gluten': (icon: Icons.bakery_dining, color: Color(0xFFF59E0B)),
  'Huevo': (icon: Icons.egg, color: Color(0xFFFBBF24)),
  'Lactosa': (icon: Icons.local_cafe, color: Color(0xFF60A5FA)),
  'Mariscos': (icon: Icons.set_meal, color: Color(0xFFEF4444)),
  'Pescado': (icon: Icons.phishing, color: Color(0xFF3B82F6)),
  'Soja': (icon: Icons.spa, color: Color(0xFF84CC16)),
  'Frutas': (icon: Icons.eco, color: Color(0xFFEF4444)),
  'Apio': (icon: Icons.grass, color: Color(0xFF22C55E)),
  'Semillas': (icon: Icons.grain, color: Color(0xFFA16207)),
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.allergiesTitle,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.allergiesSubtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 28),
          SectionCard(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.warning,
            title: l10n.allergiesCardTitle,
            subtitle: l10n.allergiesCardSubtitle,
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
                      tag: tr(tag, locale),
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final foods = foodsWithAllergen(tag);
    final config = _allergenConfig[tag];
    final color = config?.color ?? AppColors.error;
    final allAllowed = foods.every((f) => widget.allergyExceptions.contains(f.name));

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
                Expanded(
                  child: Text(
                    l10n.refine(tr(tag, locale)),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (allAllowed) {
                      // Re-block all: remove all exceptions
                      for (final f in foods) {
                        widget.allergyExceptions.remove(f.name);
                      }
                    } else {
                      // Allow all: add all as exceptions
                      for (final f in foods) {
                        widget.allergyExceptions.add(f.name);
                      }
                    }
                    widget.onAllergyExceptionsChanged(widget.allergyExceptions);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: allAllowed
                          ? AppColors.error.withValues(alpha: 0.1)
                          : AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: allAllowed
                            ? AppColors.error.withValues(alpha: 0.3)
                            : AppColors.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      allAllowed ? l10n.blockAll : l10n.unblockAll,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: allAllowed ? AppColors.error : AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.allergyHelpText,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: foods.map((food) {
                final isException = widget.allergyExceptions.contains(food.name);
                final isBlocked = !isException;
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
                      color: isBlocked
                          ? AppColors.error.withValues(alpha: 0.12)
                          : AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBlocked
                            ? AppColors.error.withValues(alpha: 0.4)
                            : AppColors.secondary,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isBlocked ? Icons.block : Icons.check_circle,
                          size: 15,
                          color: isBlocked ? AppColors.error : AppColors.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tr(food.name, locale),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isBlocked ? AppColors.error : AppColors.secondary,
                            decoration: isBlocked ? TextDecoration.lineThrough : null,
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
