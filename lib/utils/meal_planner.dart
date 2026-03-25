import 'dart:math';

import '../data/food_database.dart';
import '../screens/nutrition/nutrition_flow_screen.dart';

// ─── Configuración de entrada ────────────────────────────────────

class MealPlanConfig {
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  final int days;
  final int mealsPerDay;
  final String varietyLevel; // 'low', 'medium', 'high'
  final Set<String> favorites;
  final Set<String> allergies;
  final Set<String> allergyExceptions;
  final Set<String> disliked;

  const MealPlanConfig({
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
    required this.days,
    required this.mealsPerDay,
    required this.varietyLevel,
    required this.favorites,
    required this.allergies,
    this.allergyExceptions = const {},
    required this.disliked,
  });

  int get targetCalories =>
      (targetProtein * 4 + targetCarbs * 4 + targetFat * 9).round();
}

// ─── Tipos internos ──────────────────────────────────────────────

enum _MealType { breakfast, snack, mainMeal, lightDinner }

class _MealSlot {
  final String name;
  final double calorieFraction;
  final _MealType type;

  const _MealSlot(this.name, this.calorieFraction, this.type);
}

// Métodos de cocción para dar variedad a los nombres
const _cookingMethods = [
  'a la plancha',
  'al horno',
  'a la parrilla',
  'salteado',
  'al vapor',
];

// ─── Configuración de slots según nº de comidas ──────────────────

const _slotConfigs = <int, List<_MealSlot>>{
  3: [
    _MealSlot('Desayuno', 0.30, _MealType.breakfast),
    _MealSlot('Almuerzo', 0.40, _MealType.mainMeal),
    _MealSlot('Cena', 0.30, _MealType.lightDinner),
  ],
  4: [
    _MealSlot('Desayuno', 0.25, _MealType.breakfast),
    _MealSlot('Almuerzo', 0.35, _MealType.mainMeal),
    _MealSlot('Merienda', 0.10, _MealType.snack),
    _MealSlot('Cena', 0.30, _MealType.lightDinner),
  ],
  5: [
    _MealSlot('Desayuno', 0.25, _MealType.breakfast),
    _MealSlot('Media mañana', 0.10, _MealType.snack),
    _MealSlot('Almuerzo', 0.30, _MealType.mainMeal),
    _MealSlot('Merienda', 0.10, _MealType.snack),
    _MealSlot('Cena', 0.25, _MealType.lightDinner),
  ],
  6: [
    _MealSlot('Desayuno', 0.20, _MealType.breakfast),
    _MealSlot('Media mañana', 0.10, _MealType.snack),
    _MealSlot('Almuerzo', 0.28, _MealType.mainMeal),
    _MealSlot('Merienda', 0.10, _MealType.snack),
    _MealSlot('Pre-cena', 0.07, _MealType.snack),
    _MealSlot('Cena', 0.25, _MealType.lightDinner),
  ],
};

// Alimentos aptos para desayuno
const _breakfastCarbs = {'Avena', 'Pan integral', 'Tortillas', 'Pan de centeno'};
const _breakfastProteins = {'Huevos', 'Pavo', 'Claras de huevo'};

// ─── Generador principal ─────────────────────────────────────────

class MealPlanner {
  static List<DietDay> generate(MealPlanConfig config) {
    final rng = Random();
    final slots = _slotConfigs[config.mealsPerDay] ?? _slotConfigs[5]!;

    // Filtrar pool de alimentos disponibles
    final pool = foodDatabase.where((food) {
      if (food.allergenTags.any((tag) => config.allergies.contains(tag))) {
        if (!config.allergyExceptions.contains(food.name)) return false;
      }
      if (config.disliked.contains(food.name)) return false;
      return true;
    }).toList();

    final proteins = pool.where((f) => f.category == FoodCategory.protein).toList();
    final carbs = pool.where((f) => f.category == FoodCategory.carb).toList();
    final fats = pool.where((f) => f.category == FoodCategory.fat).toList();
    final veggies = pool.where((f) => f.category == FoodCategory.vegetable).toList();
    final fruits = pool.where((f) => f.category == FoodCategory.fruit).toList();
    final dairy = pool.where((f) => f.category == FoodCategory.dairy).toList();

    // Tracking para variedad
    final recentProteins = <String>[];
    final recentCarbs = <String>[];
    final recentVeggies = <String>[];

    final days = <DietDay>[];

    for (int d = 0; d < config.days; d++) {
      final meals = <Meal>[];

      for (final slot in slots) {
        final mealTargetP = config.targetProtein * slot.calorieFraction;
        final mealTargetC = config.targetCarbs * slot.calorieFraction;
        final mealTargetF = config.targetFat * slot.calorieFraction;
        final mealTargetCal =
            (mealTargetP * 4 + mealTargetC * 4 + mealTargetF * 9);

        final selections = <(FoodItem, double)>[];

        switch (slot.type) {
          case _MealType.breakfast:
            _composeBreakfast(
              selections, proteins, carbs, fats, fruits, dairy,
              config, rng, recentCarbs,
            );
          case _MealType.snack:
            _composeSnack(selections, fats, fruits, dairy, config, rng);
          case _MealType.mainMeal:
            _composeMainMeal(
              selections, proteins, carbs, fats, veggies,
              config, rng, recentProteins, recentCarbs, recentVeggies,
            );
          case _MealType.lightDinner:
            _composeLightDinner(
              selections, proteins, carbs, fats, veggies,
              config, rng, recentProteins, recentVeggies,
            );
        }

        // Escalar porciones para ajustar a los macros del slot
        final items = _scaleToTarget(selections, mealTargetCal, slot.type, rng);
        meals.add(Meal(name: slot.name, items: items));
      }

      // Ajuste final: corregir desviación en la última comida
      _adjustLastMeal(meals, config);

      days.add(DietDay(dayNumber: d + 1, meals: meals));
    }

    return days;
  }

  // ─── Composición por tipo de comida ──────────────────────────

  static void _composeBreakfast(
    List<(FoodItem, double)> selections,
    List<FoodItem> proteins, List<FoodItem> carbs,
    List<FoodItem> fats, List<FoodItem> fruits, List<FoodItem> dairy,
    MealPlanConfig config, Random rng, List<String> recentCarbs,
  ) {
    // Carb de desayuno
    final bkCarbs = carbs.where((f) => _breakfastCarbs.contains(f.name)).toList();
    if (bkCarbs.isNotEmpty) {
      selections.add((_pick(bkCarbs, config.favorites, recentCarbs, config.varietyLevel, rng), 0));
    } else if (carbs.isNotEmpty) {
      selections.add((_pick(carbs, config.favorites, recentCarbs, config.varietyLevel, rng), 0));
    }

    // Proteína de desayuno
    final bkProts = proteins.where((f) => _breakfastProteins.contains(f.name)).toList();
    if (bkProts.isNotEmpty) {
      selections.add((_pick(bkProts, config.favorites, [], config.varietyLevel, rng), 0));
    } else if (proteins.isNotEmpty) {
      selections.add((_pick(proteins, config.favorites, [], config.varietyLevel, rng), 0));
    }

    // Fruta o lácteo
    if (dairy.isNotEmpty && rng.nextBool()) {
      selections.add((_pick(dairy, config.favorites, [], config.varietyLevel, rng), 0));
    } else if (fruits.isNotEmpty) {
      selections.add((_pick(fruits, config.favorites, [], config.varietyLevel, rng), 0));
    }

    // Rellenar defaultServingG
    for (int i = 0; i < selections.length; i++) {
      selections[i] = (selections[i].$1, selections[i].$1.defaultServingG);
    }
  }

  static void _composeSnack(
    List<(FoodItem, double)> selections,
    List<FoodItem> fats, List<FoodItem> fruits, List<FoodItem> dairy,
    MealPlanConfig config, Random rng,
  ) {
    // Un snack: fruta, grasa o lácteo
    final options = <List<FoodItem>>[
      if (fruits.isNotEmpty) fruits,
      if (fats.isNotEmpty) fats,
      if (dairy.isNotEmpty) dairy,
    ];
    if (options.isNotEmpty) {
      final chosen = options[rng.nextInt(options.length)];
      selections.add((_pick(chosen, config.favorites, [], config.varietyLevel, rng), 0));
    }

    for (int i = 0; i < selections.length; i++) {
      selections[i] = (selections[i].$1, selections[i].$1.defaultServingG);
    }
  }

  static void _composeMainMeal(
    List<(FoodItem, double)> selections,
    List<FoodItem> proteins, List<FoodItem> carbs,
    List<FoodItem> fats, List<FoodItem> veggies,
    MealPlanConfig config, Random rng,
    List<String> recentP, List<String> recentC, List<String> recentV,
  ) {
    if (proteins.isNotEmpty) {
      selections.add((_pick(proteins, config.favorites, recentP, config.varietyLevel, rng), 0));
    }
    if (carbs.isNotEmpty) {
      selections.add((_pick(carbs, config.favorites, recentC, config.varietyLevel, rng), 0));
    }
    if (veggies.isNotEmpty) {
      selections.add((_pick(veggies, config.favorites, recentV, config.varietyLevel, rng), 0));
    }
    if (fats.isNotEmpty) {
      // Aceite de oliva como grasa de cocción preferida
      final olive = fats.where((f) => f.name == 'Aceite de oliva').toList();
      selections.add((olive.isNotEmpty ? olive.first : fats[rng.nextInt(fats.length)], 0));
    }

    for (int i = 0; i < selections.length; i++) {
      selections[i] = (selections[i].$1, selections[i].$1.defaultServingG);
    }
  }

  static void _composeLightDinner(
    List<(FoodItem, double)> selections,
    List<FoodItem> proteins, List<FoodItem> carbs,
    List<FoodItem> fats, List<FoodItem> veggies,
    MealPlanConfig config, Random rng,
    List<String> recentP, List<String> recentV,
  ) {
    if (proteins.isNotEmpty) {
      selections.add((_pick(proteins, config.favorites, recentP, config.varietyLevel, rng), 0));
    }
    if (veggies.isNotEmpty) {
      selections.add((_pick(veggies, config.favorites, recentV, config.varietyLevel, rng), 0));
      // Segunda verdura para cenas
      if (veggies.length > 1) {
        final first = selections.last.$1.name;
        final others = veggies.where((f) => f.name != first).toList();
        if (others.isNotEmpty) {
          selections.add((_pick(others, config.favorites, [], config.varietyLevel, rng), 0));
        }
      }
    }
    // Carb ligero (porción reducida)
    if (carbs.isNotEmpty) {
      selections.add((_pick(carbs, config.favorites, [], config.varietyLevel, rng), 0));
    }
    if (fats.isNotEmpty) {
      final olive = fats.where((f) => f.name == 'Aceite de oliva').toList();
      selections.add((olive.isNotEmpty ? olive.first : fats[rng.nextInt(fats.length)], 0));
    }

    for (int i = 0; i < selections.length; i++) {
      final food = selections[i].$1;
      final serving = food.category == FoodCategory.carb
          ? food.defaultServingG * 0.6 // Menos carbs en la cena
          : food.defaultServingG;
      selections[i] = (food, serving);
    }
  }

  // ─── Escalado de porciones ───────────────────────────────────

  static List<MealItem> _scaleToTarget(
    List<(FoodItem, double)> selections,
    double targetCal,
    _MealType type,
    Random rng,
  ) {
    if (selections.isEmpty) return [];

    double currentCal = selections.fold(
        0.0, (s, e) => s + e.$1.caloriesForGrams(e.$2));

    if (currentCal <= 0) currentCal = 1;

    final scale = (targetCal / currentCal).clamp(0.3, 3.0);

    return selections.map((entry) {
      final food = entry.$1;
      var grams = (entry.$2 * scale).clamp(
        food.category == FoodCategory.fat ? 5.0 : 20.0,
        food.category == FoodCategory.fat ? 60.0 : 250.0,
      );
      grams = (grams / 5).round() * 5.0; // Redondear a múltiplos de 5g

      final name = _formatItemName(food, grams, type, rng);

      // MealItem constructor: (name, carbs, protein, fat, calories)
      return MealItem(
        name,
        food.carbsForGrams(grams),
        food.proteinForGrams(grams),
        food.fatForGrams(grams),
        food.caloriesForGrams(grams),
        grams: grams,
      );
    }).toList();
  }

  static String _formatItemName(
      FoodItem food, double grams, _MealType type, Random rng) {
    final g = grams.round();
    // Añadir método de cocción a proteínas y verduras en comidas principales
    if ((type == _MealType.mainMeal || type == _MealType.lightDinner) &&
        (food.category == FoodCategory.protein ||
            food.category == FoodCategory.vegetable)) {
      final method = _cookingMethods[rng.nextInt(_cookingMethods.length)];
      return '${food.name} $method (${g}g)';
    }
    return '${food.name} (${g}g)';
  }

  // ─── Ajuste final del día ────────────────────────────────────

  static void _adjustLastMeal(List<Meal> meals, MealPlanConfig config) {
    final currentCal = meals.fold(0, (s, m) => s + m.totalCalories);
    final targetCal = config.targetCalories;

    if (currentCal <= 0 || targetCal <= 0) return;

    final ratio = targetCal / currentCal;

    // Solo ajustar si la desviación es >5%
    if ((ratio - 1.0).abs() < 0.05) return;

    // Reconstruir la última comida con porciones ajustadas
    final lastMeal = meals.last;
    final adjustedItems = lastMeal.items.map((item) {
      final adjustFactor = ratio.clamp(0.7, 1.4);
      final newCarbs = item.carbs * adjustFactor;
      final newProtein = item.protein * adjustFactor;
      final newFat = item.fat * adjustFactor;
      final newCal = (newProtein * 4 + newCarbs * 4 + newFat * 9).round();
      return MealItem(item.name, newCarbs, newProtein, newFat, newCal, grams: item.grams * adjustFactor);
    }).toList();

    meals[meals.length - 1] = Meal(name: lastMeal.name, items: adjustedItems);
  }

  // ─── Selección con peso (favoritos) y variedad ───────────────

  static FoodItem _pick(
    List<FoodItem> pool,
    Set<String> favorites,
    List<String> recentlyUsed,
    String varietyLevel,
    Random rng,
  ) {
    List<FoodItem> candidates;

    switch (varietyLevel) {
      case 'low':
        // Preferir los ya usados (rotación pequeña)
        final recent =
            pool.where((f) => recentlyUsed.contains(f.name)).toList();
        candidates =
            recent.isNotEmpty && recentlyUsed.length >= 2 ? recent : pool;
      case 'high':
        // Excluir lo usado recientemente
        final excluded = recentlyUsed.take(pool.length ~/ 2).toSet();
        candidates =
            pool.where((f) => !excluded.contains(f.name)).toList();
        if (candidates.isEmpty) candidates = pool;
      default: // medium
        final excluded = recentlyUsed.take(2).toSet();
        candidates =
            pool.where((f) => !excluded.contains(f.name)).toList();
        if (candidates.isEmpty) candidates = pool;
    }

    final picked = _weightedPick(candidates, favorites, rng);

    // Actualizar historial
    recentlyUsed.insert(0, picked.name);
    if (recentlyUsed.length > pool.length) {
      recentlyUsed.removeLast();
    }

    return picked;
  }

  static FoodItem _weightedPick(
    List<FoodItem> pool,
    Set<String> favorites,
    Random rng,
  ) {
    final weights =
        pool.map((f) => favorites.contains(f.name) ? 3 : 1).toList();
    final totalWeight = weights.fold(0, (s, w) => s + w);
    var pick = rng.nextInt(totalWeight);

    for (int i = 0; i < pool.length; i++) {
      pick -= weights[i];
      if (pick < 0) return pool[i];
    }
    return pool.last;
  }
}

// ─── Helper para obtener nombres de comidas según nº ─────────────

List<String> getMealSlotNames(int mealsPerDay) {
  final slots = _slotConfigs[mealsPerDay] ?? _slotConfigs[5]!;
  return slots.map((s) => s.name).toList();
}
