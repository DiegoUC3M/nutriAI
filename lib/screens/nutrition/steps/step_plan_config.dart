import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/translations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/meal_planner.dart';

class StepPlanConfig extends StatelessWidget {
  final int mealsPerDay;
  final String varietyLevel;
  final ValueChanged<int> onMealsPerDayChanged;
  final ValueChanged<String> onVarietyChanged;

  const StepPlanConfig({
    super.key,
    required this.mealsPerDay,
    required this.varietyLevel,
    required this.onMealsPerDayChanged,
    required this.onVarietyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final mealNames = getMealSlotNames(mealsPerDay);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.configureYourPlan,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.planConfigSubtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Comidas por día
          Text(
            l10n.mealsPerDay,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [3, 4, 5, 6].map((n) {
              final isSelected = mealsPerDay == n;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => onMealsPerDayChanged(n),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceLight,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$n',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Lista de comidas resultante
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceLight),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: mealNames.map((name) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tr(name, locale),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),

          // Variedad
          Text(
            l10n.varietyLevel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ..._buildVarietyOptions(l10n).map((option) {
            final (key, icon, label, description) = option;
            final isSelected = varietyLevel == key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => onVarietyChanged(key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.surfaceLight,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        icon,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.secondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? AppColors.secondary
                                        .withValues(alpha: 0.7)
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  static List<(String, String, String, String)> _buildVarietyOptions(AppLocalizations l10n) => [
    ('low', '🔁', l10n.lowVariety, l10n.lowVarietyDesc),
    ('medium', '🔀', l10n.mediumVariety, l10n.mediumVarietyDesc),
    ('high', '🎲', l10n.highVariety, l10n.highVarietyDesc),
  ];
}
