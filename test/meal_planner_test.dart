import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/data/food_database.dart';
import 'package:gym_app/utils/meal_planner.dart';

void main() {
  test('Fitted dinner nutrients match the rounded portion', () {
    final egg = foodByName['Huevos']!;
    final config = MealPlanConfig(
      targetProtein: 150,
      targetCarbs: 225,
      targetFat: 0,
      days: 1,
      mealsPerDay: 3,
      varietyLevel: 'low',
      favorites: {},
      allergies: {},
      disliked: foodDatabase
          .map((food) => food.name)
          .where((name) => name != egg.name)
          .toSet(),
    );

    final dinner = MealPlanner.generate(config).single.meals.last.items.single;
    expect(dinner.grams % 5, 0);
    expect(dinner.carbs, closeTo(egg.carbsForGrams(dinner.grams), 0.0001));
    expect(dinner.protein, closeTo(egg.proteinForGrams(dinner.grams), 0.0001));
    expect(dinner.fat, closeTo(egg.fatForGrams(dinner.grams), 0.0001));
    expect(dinner.calories, egg.caloriesForGrams(dinner.grams));
  });

  test('Equal 1500 kcal targets produce different macro distributions', () {
    const allowed = {'Pavo', 'Arroz', 'Aceite de oliva'};
    final disliked = foodDatabase
        .map((food) => food.name)
        .toSet()
        .difference(allowed);
    final moderate = _config(150, 135, 40, disliked: disliked);
    final high = _config(300, 30, 20, disliked: disliked);
    expect(moderate.targetCalories, 1500);
    expect(high.targetCalories, 1500);

    final moderateDay = MealPlanner.generate(moderate).single;
    final highDay = MealPlanner.generate(high).single;
    for (final (day, target) in [(moderateDay, moderate), (highDay, high)]) {
      expect(day.totalProtein, closeTo(target.targetProtein, 10));
      expect(day.totalCarbs, closeTo(target.targetCarbs, 10));
      expect(day.totalFat, closeTo(target.targetFat, 5));
    }
    expect(highDay.totalProtein - moderateDay.totalProtein, greaterThan(120));
    expect(moderateDay.totalCarbs - highDay.totalCarbs, greaterThan(85));
  });

  test('Daily fitting keeps the 1230 kcal plan within 3 percent', () {
    final config = _config(150, 90, 30);
    expect(config.targetCalories, 1230);
    for (final seed in [0, 1, 2, 3, 4]) {
      final day = MealPlanner.generate(config, random: Random(seed)).single;
      expect(
        day.totalCalories,
        closeTo(1230, 1230 * 0.03),
        reason: 'seed $seed',
      );
    }
  });

  test('Daily fitting corrects fat overshoot without a macro deficit', () {
    final day = MealPlanner.generate(
      _config(150, 90, 30),
      random: Random(46),
    ).single;
    expect(day.totalFat, closeTo(30, 5));
    expect(day.totalProtein, closeTo(150, 5));
    expect(day.totalCarbs, closeTo(90, 5));
  });

  test('Daily fitting keeps the apple snack near its calorie share', () {
    final day = MealPlanner.generate(
      _config(150, 90, 30, mealsPerDay: 4),
      random: Random(58),
    ).single;
    final snack = day.meals.singleWhere((meal) => meal.name == 'Merienda');
    expect(snack.items.any((item) => item.name.startsWith('Manzana ')), isTrue);
    expect(snack.totalCalories, inInclusiveRange(78, 168));
  });

  test('Supplemental snack foods are suitable and snack-sized', () {
    final day = MealPlanner.generate(
      _config(300, 30, 20, mealsPerDay: 4),
      random: Random(0),
    ).single;
    final snack = day.meals.singleWhere((meal) => meal.name == 'Merienda');
    expect(snack.items, isNotEmpty);
    for (final item in snack.items) {
      final food = foodByName[item.name.split(' (').first]!;
      expect(
        food.category,
        isIn([FoodCategory.fruit, FoodCategory.dairy, FoodCategory.fat]),
        reason: item.name,
      );
      expect(item.grams, lessThanOrEqualTo(food.defaultServingG));
    }
  });

  test('MealPlanner.generate produces valid diet', () {
    final config = MealPlanConfig(
      targetProtein: 150.0,
      targetCarbs: 250.0,
      targetFat: 70.0,
      days: 7,
      mealsPerDay: 5,
      varietyLevel: 'medium',
      favorites: <String>{},
      allergies: <String>{},
      disliked: <String>{},
    );

    final result = MealPlanner.generate(config);
    expect(result.length, 7);

    for (final day in result) {
      expect(day.meals.length, 5);
    }
  });

  test('MealPlanner.generate with favorites', () {
    final config = MealPlanConfig(
      targetProtein: 120.0,
      targetCarbs: 200.0,
      targetFat: 60.0,
      days: 3,
      mealsPerDay: 3,
      varietyLevel: 'low',
      favorites: {'Pollo', 'Arroz', 'Brócoli'},
      allergies: {'Gluten'},
      disliked: {'Tofu'},
    );

    final result = MealPlanner.generate(config);
    expect(result.length, 3);
    for (final day in result) {
      expect(day.meals.length, 3);
    }
  });
}

MealPlanConfig _config(
  double protein,
  double carbs,
  double fat, {
  Set<String> disliked = const {},
  int mealsPerDay = 3,
}) => MealPlanConfig(
  targetProtein: protein,
  targetCarbs: carbs,
  targetFat: fat,
  days: 1,
  mealsPerDay: mealsPerDay,
  varietyLevel: 'medium',
  favorites: {},
  allergies: {},
  disliked: disliked,
);
