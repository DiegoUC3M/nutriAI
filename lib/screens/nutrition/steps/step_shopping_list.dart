import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/translations.dart';
import '../../../data/food_database.dart';
import '../../../theme/app_theme.dart';
import '../nutrition_flow_screen.dart';

class StepShoppingList extends StatefulWidget {
  final List<DietDay>? dietDays;

  const StepShoppingList({super.key, required this.dietDays});

  @override
  State<StepShoppingList> createState() => _StepShoppingListState();
}

class _StepShoppingListState extends State<StepShoppingList> {
  final Set<String> _checkedItems = {};
  Map<String, List<_ShoppingEntry>>? _shoppingList;
  int _totalItems = 0;

  @override
  void didUpdateWidget(covariant StepShoppingList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dietDays != oldWidget.dietDays) {
      _checkedItems.clear();
      _shoppingList = null;
    }
  }

  void _buildList() {
    if (_shoppingList != null || widget.dietDays == null) return;
    _shoppingList = _generateShoppingList();
    _totalItems =
        _shoppingList!.values.fold<int>(0, (s, l) => s + l.length);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    if (widget.dietDays == null || widget.dietDays!.isEmpty) {
      return Center(
        child: Text(
          l10n.generateDietFirst,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    _buildList();
    final checkedCount = _checkedItems.length;
    final progress = _totalItems > 0 ? checkedCount / _totalItems : 0.0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        // ─── Info banner ─────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.shopping_cart_outlined,
                  color: AppColors.secondary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.daysAndIngredients(widget.dietDays!.length, _totalItems),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.estimatedQuantities,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ─── Progress bar ────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.purchasedProgress(checkedCount, _totalItems),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: progress == 1.0
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation(
                    progress == 1.0 ? AppColors.success : AppColors.primary,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ─── Shopping categories ─────────────────────────────
        ..._shoppingList!.entries.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    tr(category.key, locale),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${category.value.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...category.value.map((entry) {
                final isChecked = _checkedItems.contains(entry.name);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isChecked) {
                        _checkedItems.remove(entry.name);
                      } else {
                        _checkedItems.add(entry.name);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isChecked
                          ? AppColors.secondary.withValues(alpha: 0.06)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isChecked
                            ? AppColors.secondary.withValues(alpha: 0.3)
                            : AppColors.surfaceLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isChecked
                                ? AppColors.secondary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isChecked
                                  ? AppColors.secondary
                                  : AppColors.textMuted,
                              width: 2,
                            ),
                          ),
                          child: isChecked
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tr(entry.name, locale),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isChecked
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                              decoration: isChecked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                          entry.quantity,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isChecked
                                ? AppColors.textMuted
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  // ─── Shopping list generation from diet data ──────────────

  Map<String, List<_ShoppingEntry>> _generateShoppingList() {
    final Map<String, _AggregatedItem> aggregated = {};

    for (final day in widget.dietDays!) {
      for (final meal in day.meals) {
        for (final item in meal.items) {
          for (final ing in _extractIngredients(item)) {
            final existing = aggregated[ing.name];
            if (existing != null) {
              existing.totalGrams += ing.gramsPerServing;
              existing.count++;
            } else {
              aggregated[ing.name] = _AggregatedItem(
                count: 1,
                totalGrams: ing.gramsPerServing,
                category: ing.category,
                unit: ing.unit,
              );
            }
          }
        }
      }
    }

    final result = <String, List<_ShoppingEntry>>{};
    for (final entry in aggregated.entries) {
      final data = entry.value;
      final quantity = _formatQuantity(data);
      result.putIfAbsent(data.category, () => []);
      result[data.category]!.add(_ShoppingEntry(entry.key, quantity));
    }

    const order = [
      '🥩 Proteínas',
      '🥛 Lácteos',
      '🌾 Carbohidratos',
      '🥬 Verduras y frutas',
      '🥑 Grasas saludables',
      '🧴 Suplementos y otros',
    ];
    final sorted = <String, List<_ShoppingEntry>>{};
    for (final cat in order) {
      if (result.containsKey(cat)) {
        sorted[cat] = result[cat]!;
      }
    }
    for (final entry in result.entries) {
      sorted.putIfAbsent(entry.key, () => entry.value);
    }
    return sorted;
  }

  List<_ExtractedIngredient> _extractIngredients(MealItem item) {
    final parts = item.name.split(' con ');

    if (parts.length >= 2) {
      final mainName = _cleanName(parts[0]);
      final secondaryName = _cleanName(parts.sublist(1).join(' con '));
      final mainCat = _inferCategory(
          mainName, item.protein * 0.65, item.carbs * 0.65, item.fat * 0.65);
      final secCat = _inferCategory(secondaryName, item.protein * 0.35,
          item.carbs * 0.35, item.fat * 0.35);
      final mainGrams = item.grams * 0.65;
      final secGrams = item.grams * 0.35;

      return [
        _ExtractedIngredient(mainName, mainGrams, mainCat, _unitForItem(mainName)),
        _ExtractedIngredient(secondaryName, secGrams, secCat, _unitForItem(secondaryName)),
      ];
    }

    final cleanedName = _cleanName(item.name);
    final category = _inferCategory(cleanedName, item.protein, item.carbs, item.fat);
    return [
      _ExtractedIngredient(cleanedName, item.grams, category, _unitForItem(cleanedName)),
    ];
  }

  String _cleanName(String name) {
    // Quitar gramaje "(130g)"
    String clean = name.replaceAll(RegExp(r'\s*\([^)]*\)'), '');
    // Quitar métodos de cocción (incluye variantes de género)
    const methods = [
      'a la plancha', 'al horno', 'a la parrilla', 'al vapor',
      'salteado/a', 'salteado', 'salteada', 'salteadas', 'salteados',
      'cocido', 'cocida', 'cocidos', 'cocidas',
      'hervido', 'hervida', 'hervidos', 'hervidas',
      'frito', 'frita', 'fritos', 'fritas',
      'asado', 'asada', 'asados', 'asadas',
    ];
    for (final method in methods) {
      clean = clean.replaceAll(RegExp('\\s+${RegExp.escape(method)}', caseSensitive: false), '');
    }
    return clean.trim();
  }

  String _inferCategory(String name, double protein, double carbs, double fat) {
    final food = foodByName[name];
    if (food != null) return shoppingLabel(food.category);

    // Fallback: heurística por macros para items desconocidos
    final total = protein + carbs + fat;
    if (total == 0) return '🧴 Suplementos y otros';
    if (protein / total > 0.45) return '🥩 Proteínas';
    if (carbs / total > 0.5) return '🌾 Carbohidratos';
    if (fat / total > 0.45) return '🥑 Grasas saludables';
    return '🧴 Suplementos y otros';
  }

  String _unitForItem(String name) {
    final food = foodByName[name];
    if (food != null) return food.defaultUnit;
    return 'g';
  }

  String _formatQuantity(_AggregatedItem data) {
    final totalAmount = data.totalGrams;
    if (data.unit == 'ud') {
      final locale = Localizations.localeOf(context);
      if (locale.languageCode == 'en') {
        return '${data.count} ${data.count == 1 ? 'unit' : 'units'}';
      }
      return '${data.count} ${data.count == 1 ? 'unidad' : 'unidades'}';
    }
    if (data.unit == 'ml') {
      if (totalAmount >= 1000) return '${(totalAmount / 1000).toStringAsFixed(1)} L';
      return '${totalAmount.round()} ml';
    }
    if (totalAmount >= 1000) return '${(totalAmount / 1000).toStringAsFixed(1)} kg';
    return '${totalAmount.round()} g';
  }
}

class _ShoppingEntry {
  final String name;
  final String quantity;
  const _ShoppingEntry(this.name, this.quantity);
}

class _ExtractedIngredient {
  final String name;
  final double gramsPerServing;
  final String category;
  final String unit;
  const _ExtractedIngredient(this.name, this.gramsPerServing, this.category, this.unit);
}

class _AggregatedItem {
  int count;
  double totalGrams;
  final String category;
  final String unit;
  _AggregatedItem({required this.count, required this.totalGrams, required this.category, required this.unit});
}
