import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/translations.dart';
import '../../../theme/app_theme.dart';
import '../nutrition_flow_screen.dart';

class StepDietResult extends StatefulWidget {
  final List<DietDay>? dietDays;
  final bool isGenerating;
  final String? loadingMessage;
  final VoidCallback onRegenerate;
  final VoidCallback? onNewDiet;
  final VoidCallback onGoToShoppingList;

  const StepDietResult({
    super.key,
    required this.dietDays,
    required this.isGenerating,
    this.loadingMessage,
    required this.onRegenerate,
    required this.onNewDiet,
    required this.onGoToShoppingList,
  });

  @override
  State<StepDietResult> createState() => _StepDietResultState();
}

class _StepDietResultState extends State<StepDietResult> {
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.isGenerating) {
      return _buildLoadingState();
    }

    if (widget.dietDays == null || widget.dietDays!.isEmpty) {
      return _buildEmptyState();
    }

    final days = widget.dietDays!;
    final currentDay = days[_selectedDay];

    return Column(
      children: [
        // Day selector
        SizedBox(
          height: 56,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final isSelected = index == _selectedDay;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceLight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        l10n.dayN(index + 1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Macros resumen del día
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroBadge(
                label: l10n.caloriesLabel,
                value: '${currentDay.totalCalories}',
                unit: 'kcal',
                color: AppColors.primary,
              ),
              _MacroBadge(
                label: l10n.proteinLabel,
                value: '${currentDay.totalProtein.round()}',
                unit: 'g',
                color: AppColors.secondary,
              ),
              _MacroBadge(
                label: l10n.carbsLabel,
                value: '${currentDay.totalCarbs.round()}',
                unit: 'g',
                color: AppColors.primaryLight,
              ),
              _MacroBadge(
                label: l10n.fatLabel,
                value: '${currentDay.totalFat.round()}',
                unit: 'g',
                color: AppColors.warning,
              ),
            ],
          ),
        ),

        // Meals
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: currentDay.meals.length,
            itemBuilder: (context, index) {
              final meal = currentDay.meals[index];
              return _MealCard(meal: meal);
            },
          ),
        ),

        // Action buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 72,
                        child: OutlinedButton(
                          onPressed: widget.onRegenerate,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.settings_outlined, size: 20),
                              const SizedBox(height: 4),
                              Text(l10n.restartFlow, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              Text(
                                l10n.restartFlowDesc,
                                style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 72,
                        child: OutlinedButton(
                          onPressed: widget.onNewDiet,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh, size: 20),
                              const SizedBox(height: 4),
                              Text(l10n.regenerate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              Text(
                                l10n.regenerateDesc,
                                style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.adNotice,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: widget.onGoToShoppingList,
                    icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                    label: Text(l10n.shoppingButton, overflow: TextOverflow.ellipsis),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.loadingMessage ?? l10n.generatingDiet,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.analyzingPreferences,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        l10n.noResults,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

// ─── Reusable widgets ───────────────────────────────────────────

class _MacroBadge extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _MacroBadge({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;

  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr(meal.name, locale), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('${meal.totalCalories} kcal', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 10),
          ...meal.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(trMealItem(item.name, locale), style: const TextStyle(fontSize: 14, color: AppColors.textSecondary))),
                    Text('P:${item.protein.round()} C:${item.carbs.round()} G:${item.fat.round()}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'monospace')),
                  ],
                ),
              )),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _MiniMacro('P', meal.totalProtein, AppColors.secondary),
              const SizedBox(width: 8),
              _MiniMacro('C', meal.totalCarbs, AppColors.primaryLight),
              const SizedBox(width: 8),
              _MiniMacro('G', meal.totalFat, AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMacro extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MiniMacro(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text('$label: ${value.round()}g', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
