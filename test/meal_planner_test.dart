import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/data/food_database.dart';
import 'package:gym_app/utils/meal_planner.dart';
import 'package:gym_app/screens/nutrition/nutrition_flow_screen.dart';

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
    print('Generated ${result.length} days');
    expect(result.length, 7);

    for (final day in result) {
      print('Day ${day.dayNumber}: ${day.meals.length} meals, ${day.totalCalories} kcal, P:${day.totalProtein.round()} C:${day.totalCarbs.round()} F:${day.totalFat.round()}');
      expect(day.meals.length, 5);
      for (final meal in day.meals) {
        print('  ${meal.name}: ${meal.items.length} items, ${meal.totalCalories} kcal');
        for (final item in meal.items) {
          print('    ${item.name} - P:${item.protein.round()} C:${item.carbs.round()} F:${item.fat.round()} Cal:${item.calories}');
        }
      }
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
    print('Generated ${result.length} days with favorites');
    expect(result.length, 3);
    for (final day in result) {
      expect(day.meals.length, 3);
    }
  });
}
