import 'package:flutter/material.dart';
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
    if (widget.dietDays == null || widget.dietDays!.isEmpty) {
      return const Center(
        child: Text(
          'Genera una dieta primero',
          style: TextStyle(color: AppColors.textSecondary),
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
                      '${widget.dietDays!.length} días · $_totalItems ingredientes',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Cantidades estimadas en base a tu dieta',
                      style: TextStyle(
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
                    '$checkedCount / $_totalItems comprados',
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
                    category.key,
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
                            entry.name,
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
              existing.count++;
            } else {
              aggregated[ing.name] = _AggregatedItem(
                count: 1,
                gramsPerServing: ing.gramsPerServing,
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
      final mainCal = (item.calories * 0.65).round();
      final secCal = (item.calories * 0.35).round();
      final mainCat = _inferCategory(
          mainName, item.protein * 0.65, item.carbs * 0.65, item.fat * 0.65);
      final secCat = _inferCategory(secondaryName, item.protein * 0.35,
          item.carbs * 0.35, item.fat * 0.35);

      return [
        _ExtractedIngredient(mainName, _estimateServing(mainName, mainCat, mainCal), mainCat, _unitForItem(mainName)),
        _ExtractedIngredient(secondaryName, _estimateServing(secondaryName, secCat, secCal), secCat, _unitForItem(secondaryName)),
      ];
    }

    final cleanedName = _cleanName(item.name);
    final category = _inferCategory(cleanedName, item.protein, item.carbs, item.fat);
    return [
      _ExtractedIngredient(cleanedName, _estimateServing(cleanedName, category, item.calories), category, _unitForItem(cleanedName)),
    ];
  }

  String _cleanName(String name) {
    String clean = name.replaceAll(RegExp(r'\s*\([^)]*\)'), '');
    const methods = [
      'a la plancha', 'al horno', 'cocida', 'cocido',
      'salteadas', 'salteado', 'al vapor', 'hervida', 'hervido',
      'frita', 'frito', 'asada', 'asado', 'a la parrilla',
    ];
    for (final method in methods) {
      clean = clean.replaceAll(RegExp('\\s+$method', caseSensitive: false), '');
    }
    return clean.trim();
  }

  String _inferCategory(String name, double protein, double carbs, double fat) {
    final lower = name.toLowerCase();

    const proteinKw = ['pollo', 'salmón', 'salmon', 'huevo', 'clara', 'tortilla de clara', 'atún', 'ternera', 'pavo', 'carne', 'lomo', 'merluza', 'gambas'];
    const vegKw = ['ensalada', 'verdura', 'brócoli', 'brocoli', 'espinaca', 'tomate', 'lechuga', 'pepino', 'zanahoria', 'calabacín', 'pimiento', 'cebolla'];
    const fruitKw = ['plátano', 'platano', 'manzana', 'naranja', 'fresa', 'uva', 'kiwi', 'pera', 'melocotón', 'piña'];
    const carbKw = ['arroz', 'avena', 'patata', 'pan ', 'pasta', 'quinoa', 'boniato', 'cereal', 'maíz'];
    const fatKw = ['aceite', 'frutos secos', 'aguacate', 'mantequilla', 'nueces', 'almendras', 'cacahuete'];
    const dairyKw = ['yogur', 'leche', 'queso', 'requesón'];
    const suppKw = ['proteína en polvo', 'batido de proteína', 'batido de proteínas', 'suplemento', 'creatina'];

    if (proteinKw.any((k) => lower.contains(k))) return '🥩 Proteínas';
    if (dairyKw.any((k) => lower.contains(k))) return '🥛 Lácteos';
    if (carbKw.any((k) => lower.contains(k))) return '🌾 Carbohidratos';
    if (vegKw.any((k) => lower.contains(k))) return '🥬 Verduras y frutas';
    if (fruitKw.any((k) => lower.contains(k))) return '🥬 Verduras y frutas';
    if (fatKw.any((k) => lower.contains(k))) return '🥑 Grasas saludables';
    if (suppKw.any((k) => lower.contains(k))) return '🧴 Suplementos y otros';

    final total = protein + carbs + fat;
    if (total == 0) return '🧴 Suplementos y otros';
    if (protein / total > 0.45) return '🥩 Proteínas';
    if (carbs / total > 0.5) return '🌾 Carbohidratos';
    if (fat / total > 0.45) return '🥑 Grasas saludables';
    return '🧴 Suplementos y otros';
  }

  String _unitForItem(String name) {
    final lower = name.toLowerCase();
    if (['aceite', 'leche'].any((k) => lower.contains(k))) return 'ml';
    if (['yogur', 'plátano', 'platano', 'manzana', 'naranja', 'huevo', 'kiwi', 'pera'].any((k) => lower.contains(k))) {
      return 'ud';
    }
    return 'g';
  }

  double _estimateServing(String name, String category, int calories) {
    final unit = _unitForItem(name);
    if (unit == 'ud') return 1;
    if (unit == 'ml') {
      final lower = name.toLowerCase();
      if (lower.contains('aceite')) return 15;
      if (lower.contains('leche')) return 250;
      return 100;
    }
    if (category.contains('Proteínas')) return (calories / 1.7).roundToDouble();
    if (category.contains('Carbohidratos')) return (calories / 1.3).roundToDouble();
    if (category.contains('Verduras')) return (calories / 0.35).roundToDouble();
    if (category.contains('Grasas')) return (calories / 5.5).roundToDouble();
    if (category.contains('Lácteos')) return (calories / 0.9).roundToDouble();
    return (calories / 1.5).roundToDouble();
  }

  String _formatQuantity(_AggregatedItem data) {
    final totalAmount = data.gramsPerServing * data.count;
    if (data.unit == 'ud') {
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
  final double gramsPerServing;
  final String category;
  final String unit;
  _AggregatedItem({required this.count, required this.gramsPerServing, required this.category, required this.unit});
}
