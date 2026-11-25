import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/utils/meal_planner.dart';

void main() {
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
