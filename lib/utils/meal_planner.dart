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

  Map<String, dynamic> toJson() => {
    'targetProtein': targetProtein,
    'targetCarbs': targetCarbs,
    'targetFat': targetFat,
    'days': days,
    'mealsPerDay': mealsPerDay,
    'varietyLevel': varietyLevel,
    'favorites': favorites.toList(),
    'allergies': allergies.toList(),
    'allergyExceptions': allergyExceptions.toList(),
    'disliked': disliked.toList(),
  };

  factory MealPlanConfig.fromJson(Map<String, dynamic> json) => MealPlanConfig(
    targetProtein: (json['targetProtein'] as num).toDouble(),
    targetCarbs: (json['targetCarbs'] as num).toDouble(),
    targetFat: (json['targetFat'] as num).toDouble(),
    days: json['days'] as int,
    mealsPerDay: json['mealsPerDay'] as int,
    varietyLevel: json['varietyLevel'] as String,
    favorites: Set<String>.from(json['favorites'] as List),
    allergies: Set<String>.from(json['allergies'] as List),
    allergyExceptions: Set<String>.from(json['allergyExceptions'] as List),
    disliked: Set<String>.from(json['disliked'] as List),
  );
}

// ─── Tipos internos ──────────────────────────────────────────────

enum _MealType { breakfast, snack, mainMeal, lightDinner }

class _MealSlot {
  final String name;
  final double calorieFraction;
  final _MealType type;

  const _MealSlot(this.name, this.calorieFraction, this.type);
}

class _Portion {
  static const stepGrams = 5.0;
  static const calorieWeight = 0.75;

  final FoodItem food;
  final List<double> perStep;
  final bool optional;
  final int maxSteps;
  int steps;

  _Portion(this.food, double grams, {this.optional = false})
    : perStep = [
        food.proteinForGrams(stepGrams) * 4,
        food.carbsForGrams(stepGrams) * 4,
        food.fatForGrams(stepGrams) * 9,
        food.caloriesPer100g * (stepGrams / 100) * calorieWeight,
      ],
      maxSteps = switch (food.category) {
        FoodCategory.fat => 12,
        FoodCategory.protein => 70,
        _ => 50,
      },
      steps = (grams / stepGrams).round() {
    if (!optional) steps = steps.clamp(minServingSteps, maxSteps);
  }

  int get minServingSteps => food.category == FoodCategory.fat ? 1 : 4;
  double get grams => steps * stepGrams;
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
  static List<DietDay> generate(MealPlanConfig config, {Random? random}) {
    final rng = random ?? Random();
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
      final portionsByMeal = <List<_Portion>>[];

      for (final slot in slots) {
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

        portionsByMeal.add(_initialPortions(
          selections, config.targetCalories * slot.calorieFraction,
        ));
      }

      _fitDailyTargets(portionsByMeal, slots, pool, config);
      final meals = [
        for (var i = 0; i < slots.length; i++)
          Meal(
            name: slots[i].name,
            items: [
              for (final portion in portionsByMeal[i])
                if (portion.steps > 0) _makeItem(portion, slots[i].type, rng),
            ],
          ),
      ];
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

  static List<_Portion> _initialPortions(
    List<(FoodItem, double)> selections,
    double targetCal,
  ) {
    final currentCal = selections.fold(
        0.0, (s, e) => s + e.$1.caloriesForGrams(e.$2));
    final scale = (targetCal / max(currentCal, 1.0)).clamp(0.3, 3.0);
    return [for (final (food, grams) in selections) _Portion(food, grams * scale)];
  }

  static MealItem _makeItem(_Portion portion, _MealType type, Random rng) {
    final food = portion.food;
    final grams = portion.grams;
    return MealItem(
      _formatItemName(food, grams, type, rng),
      food.carbsForGrams(grams),
      food.proteinForGrams(grams),
      food.fatForGrams(grams),
      food.caloriesForGrams(grams),
      grams: grams,
    );
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

  static void _fitDailyTargets(
    List<List<_Portion>> meals,
    List<_MealSlot> slots,
    List<FoodItem> pool,
    MealPlanConfig config,
  ) {
    // Use energy-equivalent macro errors, with a lower weight for database kcal.
    final remaining = [
      config.targetProtein * 4,
      config.targetCarbs * 4,
      config.targetFat * 9,
      config.targetCalories * _Portion.calorieWeight,
    ];
    final portions = meals.expand((meal) => meal).toList();
    for (final portion in portions) {
      _subtractSteps(remaining, portion, portion.steps);
    }
    _fitPortions(portions, remaining);

    // If the chosen foods cannot supply a missing macro, add at most one
    // portion per meal from the same allergy- and preference-filtered pool.
    final availableMeals = List.generate(meals.length, (i) => i);
    while (availableMeals.isNotEmpty &&
        (remaining[0] > 20 || remaining[1] > 20 || remaining[2] > 45)) {
      _Portion? best;
      var bestSteps = 0;
      var bestMeal = -1;
      var bestGain = 0.0;
      for (final food in pool) {
        final candidate = _Portion(food, 0, optional: true);
        final steps = _bestChange(candidate, remaining);
        var gain = 0.0;
        for (var i = 0; i < remaining.length; i++) {
          final delta = candidate.perStep[i] * steps;
          gain += delta * (2 * remaining[i] - delta);
        }
        if (gain < bestGain || gain <= 0) continue;
        final meal = _mealForExtra(food, meals, slots, availableMeals, config);
        if (meal == null) continue;
        if (gain == bestGain && !config.favorites.contains(food.name)) continue;
        best = candidate;
        bestSteps = steps;
        bestMeal = meal;
        bestGain = gain;
      }
      if (best == null) break;
      best.steps = bestSteps;
      _subtractSteps(remaining, best, bestSteps);
      meals[bestMeal].add(best);
      availableMeals.remove(bestMeal);
      portions.add(best);
      _fitPortions(portions, remaining);
    }
  }

  static int? _mealForExtra(
    FoodItem food,
    List<List<_Portion>> meals,
    List<_MealSlot> slots,
    List<int> availableMeals,
    MealPlanConfig config,
  ) {
    int? bestMeal;
    var largestGap = double.negativeInfinity;
    for (final i in availableMeals) {
      if (meals[i].any((portion) => portion.food == food)) continue;
      final calories = meals[i].fold(0, (sum, portion) =>
          sum + portion.food.caloriesForGrams(portion.grams));
      final gap = config.targetCalories * slots[i].calorieFraction - calories;
      if (gap > largestGap) {
        bestMeal = i;
        largestGap = gap;
      }
    }
    return bestMeal;
  }

  static void _fitPortions(List<_Portion> portions, List<double> remaining) {
    for (var pass = 0; pass < 60; pass++) {
      var changed = false;
      for (final portion in portions) {
        final change = _bestChange(portion, remaining);
        if (change == 0) continue;
        portion.steps += change;
        _subtractSteps(remaining, portion, change);
        changed = true;
      }
      if (!changed) break;
    }
  }

  static int _bestChange(_Portion portion, List<double> remaining) {
    var dot = 0.0;
    var square = 0.0;
    for (var i = 0; i < remaining.length; i++) {
      final step = portion.perStep[i];
      dot += remaining[i] * step;
      square += step * step;
    }
    if (square == 0) return 0;
    final idealSteps = portion.steps + dot / square;
    if (portion.optional && idealSteps <= portion.minServingSteps / 2) {
      return -portion.steps;
    }
    return idealSteps.round().clamp(portion.minServingSteps, portion.maxSteps) -
        portion.steps;
  }

  static void _subtractSteps(List<double> remaining, _Portion portion, int steps) {
    for (var i = 0; i < remaining.length; i++) {
      remaining[i] -= portion.perStep[i] * steps;
    }
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
