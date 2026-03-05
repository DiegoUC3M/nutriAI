import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../nutrition_flow_screen.dart';

class StepDietResult extends StatefulWidget {
  final List<DietDay>? dietDays;
  final bool isGenerating;
  final VoidCallback onRegenerate;

  const StepDietResult({
    super.key,
    required this.dietDays,
    required this.isGenerating,
    required this.onRegenerate,
  });

  @override
  State<StepDietResult> createState() => _StepDietResultState();
}

class _StepDietResultState extends State<StepDietResult>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDay = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGenerating) {
      return _buildLoadingState();
    }

    if (widget.dietDays == null || widget.dietDays!.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Tabs: Dieta / Lista de compra
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            dividerHeight: 0,
            tabs: const [
              Tab(text: '🍽️ Tu Dieta'),
              Tab(text: '🛒 Compra'),
            ],
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDietTab(),
              _buildShoppingTab(),
            ],
          ),
        ),

        // Botón regenerar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: widget.onRegenerate,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Nueva Dieta'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDietTab() {
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
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                        'Día ${index + 1}',
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
                label: 'Calorías',
                value: '${currentDay.totalCalories}',
                unit: 'kcal',
                color: AppColors.primary,
              ),
              _MacroBadge(
                label: 'Proteína',
                value: '${currentDay.totalProtein.round()}',
                unit: 'g',
                color: AppColors.secondary,
              ),
              _MacroBadge(
                label: 'Carbos',
                value: '${currentDay.totalCarbs.round()}',
                unit: 'g',
                color: AppColors.primaryLight,
              ),
              _MacroBadge(
                label: 'Grasa',
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
      ],
    );
  }

  Widget _buildShoppingTab() {
    final shoppingList = _generateShoppingList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
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
              const Icon(Icons.info_outline,
                  color: AppColors.secondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lista de la compra para ${widget.dietDays!.length} días de dieta',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        ...shoppingList.entries.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.key,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ...category.value.map((item) => _ShoppingItem(item: item)),
              const SizedBox(height: 20),
            ],
          );
        }),
      ],
    );
  }

  Map<String, List<ShoppingItem>> _generateShoppingList() {
    // Agrupa todos los alimentos de todos los días
    final Map<String, double> itemQuantities = {};
    for (final day in widget.dietDays!) {
      for (final meal in day.meals) {
        for (final item in meal.items) {
          itemQuantities[item.name] =
              (itemQuantities[item.name] ?? 0) + 1;
        }
      }
    }

    return {
      '🥩 Proteínas': [
        ShoppingItem('Pechuga de pollo', '${(widget.dietDays!.length * 200)}g'),
        ShoppingItem('Salmón', '${(widget.dietDays!.length * 150)}g'),
        ShoppingItem('Huevos', '${widget.dietDays!.length * 3} unidades'),
        ShoppingItem('Yogur griego', '${widget.dietDays!.length} unidades'),
      ],
      '🌾 Carbohidratos': [
        ShoppingItem('Arroz integral', '${(widget.dietDays!.length * 150)}g'),
        ShoppingItem('Avena', '${(widget.dietDays!.length * 60)}g'),
        ShoppingItem('Patatas', '${(widget.dietDays!.length * 200)}g'),
        ShoppingItem('Pan integral', '${widget.dietDays!.length} rebanadas'),
      ],
      '🥑 Grasas': [
        ShoppingItem('Aceite de oliva', '${(widget.dietDays!.length * 15)}ml'),
        ShoppingItem('Frutos secos', '${(widget.dietDays!.length * 30)}g'),
      ],
      '🥬 Verduras y frutas': [
        ShoppingItem('Espinacas', '${(widget.dietDays!.length * 100)}g'),
        ShoppingItem('Brócoli', '${(widget.dietDays!.length * 150)}g'),
        ShoppingItem('Tomate', '${widget.dietDays!.length} unidades'),
        ShoppingItem('Plátano', '${widget.dietDays!.length} unidades'),
      ],
      '🧴 Suplementos y otros': [
        ShoppingItem('Proteína en polvo', '${(widget.dietDays!.length * 30)}g'),
        ShoppingItem('Leche', '${(widget.dietDays!.length * 250)}ml'),
      ],
    };
  }

  Widget _buildLoadingState() {
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
          const Text(
            'Generando tu dieta con IA...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Analizando preferencias y macros',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Sin resultados',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

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
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;

  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
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
              Text(
                meal.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${meal.totalCalories} kcal',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...meal.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      'P:${item.protein.round()} C:${item.carbs.round()} G:${item.fat.round()}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 6),
          // Macro totales de la comida
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
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: ${value.round()}g',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class ShoppingItem {
  final String name;
  final String quantity;

  const ShoppingItem(this.name, this.quantity);
}

class _ShoppingItem extends StatefulWidget {
  final ShoppingItem item;

  const _ShoppingItem({required this.item});

  @override
  State<_ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<_ShoppingItem> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _checked = !_checked),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _checked
              ? AppColors.secondary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _checked ? AppColors.secondary.withValues(alpha: 0.3) : AppColors.surfaceLight,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _checked ? AppColors.secondary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _checked ? AppColors.secondary : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: _checked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.item.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _checked
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                  decoration: _checked
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            Text(
              widget.item.quantity,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _checked
                    ? AppColors.textMuted
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
