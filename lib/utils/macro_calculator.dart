class MacroResult {
  final double bmr;
  final double tdee;
  final double adjustedCalories;
  final double protein;
  final double carbs;
  final double fat;

  const MacroResult({
    required this.bmr,
    required this.tdee,
    required this.adjustedCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  int get totalCalories => adjustedCalories.round();
}

class MacroCalculator {
  static const _activityMultipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'very_active': 1.9,
  };

  static const _goalMultipliers = {
    'lose': 0.80,
    'maintain': 1.0,
    'gain': 1.15,
  };

  static MacroResult calculate({
    required String sex,
    required double weightKg,
    required double heightCm,
    required int age,
    required String activityLevel,
    required String goal,
  }) {
    // 1. BMR — Mifflin-St Jeor
    final double bmr;
    if (sex == 'male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }

    // 2. TDEE = BMR × activity multiplier
    final tdee = bmr * (_activityMultipliers[activityLevel] ?? 1.55);

    // 3. Goal adjustment
    final adjustedCalories = tdee * (_goalMultipliers[goal] ?? 1.0);

    // 4. Macro distribution
    double protein;
    double fat;

    switch (goal) {
      case 'lose':
        protein = 2.2 * weightKg;
        fat = (adjustedCalories * 0.25) / 9;
      case 'gain':
        protein = 2.0 * weightKg;
        fat = (adjustedCalories * 0.25) / 9;
      default: // maintain
        protein = 1.8 * weightKg;
        fat = (adjustedCalories * 0.28) / 9;
    }

    final proteinCalories = protein * 4;
    final fatCalories = fat * 9;
    var carbs = (adjustedCalories - proteinCalories - fatCalories) / 4;
    if (carbs < 0) carbs = 0;

    return MacroResult(
      bmr: bmr,
      tdee: tdee,
      adjustedCalories: adjustedCalories,
      protein: protein.roundToDouble(),
      carbs: carbs.roundToDouble(),
      fat: fat.roundToDouble(),
    );
  }
}
