import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/data/food_database.dart';
import 'package:gym_app/utils/meal_planner.dart';

void main() {
  test('Adjusted dinner macros match the rounded portion', () {
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
    expect(dinner.grams, 320);
    expect(dinner.carbs, closeTo(egg.carbsForGrams(320), 0.0001));
    expect(dinner.protein, closeTo(egg.proteinForGrams(320), 0.0001));
    expect(dinner.fat, closeTo(egg.fatForGrams(320), 0.0001));
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
