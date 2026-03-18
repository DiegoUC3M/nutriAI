import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/macro_calculator.dart';
import '../../utils/meal_planner.dart';
import 'steps/step_allergies.dart';
import 'steps/step_favorites.dart';
import 'steps/step_disliked.dart';
import 'steps/step_macros_config.dart';
import 'steps/step_days_selection.dart';
import 'steps/step_plan_config.dart';
import 'steps/step_diet_result.dart';

class NutritionFlowScreen extends StatefulWidget {
  final ValueChanged<List<DietDay>?>? onDietChanged;
  final VoidCallback? onGoToShoppingList;

  const NutritionFlowScreen({super.key, this.onDietChanged, this.onGoToShoppingList});

  @override
  State<NutritionFlowScreen> createState() => _NutritionFlowScreenState();
}

class _NutritionFlowScreenState extends State<NutritionFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 7;

  // Datos del flujo
  final Set<String> _favoritesFoods = {};
  final Set<String> _allergies = {};
  final Set<String> _allergyExceptions = {};
  final Set<String> _dislikedFoods = {};

  // Macros
  bool _autoMacros = true;
  late double _protein;
  late double _carbs;
  late double _fat;

  // Auto macros data
  String _goal = 'maintain';
  String _sex = 'male';
  int _age = 25;
  double _weight = 70;
  double _height = 170;
  String _activityLevel = 'moderate';

  @override
  void initState() {
    super.initState();
    final result = MacroCalculator.calculate(
      sex: _sex,
      weightKg: _weight,
      heightCm: _height,
      age: _age,
      activityLevel: _activityLevel,
      goal: _goal,
    );
    _protein = result.protein;
    _carbs = result.carbs;
    _fat = result.fat;
  }

  void _recalculateAutoMacros() {
    if (!_autoMacros) return;
    final result = MacroCalculator.calculate(
      sex: _sex,
      weightKg: _weight,
      heightCm: _height,
      age: _age,
      activityLevel: _activityLevel,
      goal: _goal,
    );
    setState(() {
      _protein = result.protein;
      _carbs = result.carbs;
      _fat = result.fat;
    });
  }

  // Días
  int _days = 7;

  // Configuración del plan
  int _mealsPerDay = 5;
  String _varietyLevel = 'medium';

  // Resultado
  List<DietDay>? _dietResult;
  bool _isGenerating = false;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 5) {
        // Moving to diet result step — generate the diet
        setState(() {
          _currentStep = 6;
          _isGenerating = true;
          _dietResult = null;
        });
        _generateDiet();
      } else {
        setState(() => _currentStep++);
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _generateDiet() {
    setState(() {
      _isGenerating = true;
      _dietResult = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      try {
        final config = MealPlanConfig(
          targetProtein: _protein,
          targetCarbs: _carbs,
          targetFat: _fat,
          days: _days,
          mealsPerDay: _mealsPerDay,
          varietyLevel: _varietyLevel,
          favorites: _favoritesFoods,
          allergies: _allergies,
          allergyExceptions: _allergyExceptions,
          disliked: _dislikedFoods,
        );

        final result = MealPlanner.generate(config);

        if (!mounted) return;
        setState(() {
          _dietResult = result;
          _isGenerating = false;
        });
        widget.onDietChanged?.call(_dietResult);
      } catch (e) {
        if (!mounted) return;
        debugPrint('Error generating diet: $e');
        setState(() {
          _isGenerating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriAI'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _currentStep == 6
                    ? () {
                        setState(() {
                          _currentStep = 5;
                          _isGenerating = false;
                        });
                      }
                    : _prevStep,
              )
            : null,
        actions: [
          if (_currentStep < 6)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentStep + 1}/$_totalSteps',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          if (_currentStep < 6)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _totalSteps,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  minHeight: 4,
                ),
              ),
            ),
          const SizedBox(height: 8),

          // Pages
          Expanded(
            child: _currentStep < 6
                ? PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StepAllergies(
                        allergies: _allergies,
                        allergyExceptions: _allergyExceptions,
                        onAllergiesChanged: (v) => setState(() {}),
                        onAllergyExceptionsChanged: (v) => setState(() {}),
                      ),
                      StepFavorites(
                        favorites: _favoritesFoods,
                        onFavoritesChanged: (v) => setState(() {}),
                      ),
                      StepDisliked(
                        disliked: _dislikedFoods,
                        onDislikedChanged: (v) => setState(() {}),
                      ),
                      StepMacrosConfig(
                        autoMacros: _autoMacros,
                        protein: _protein,
                        carbs: _carbs,
                        fat: _fat,
                        goal: _goal,
                        sex: _sex,
                        age: _age,
                        weight: _weight,
                        height: _height,
                        activityLevel: _activityLevel,
                        onAutoMacrosChanged: (v) {
                          _autoMacros = v;
                          if (v) {
                            _recalculateAutoMacros();
                          } else {
                            setState(() {});
                          }
                        },
                        onProteinChanged: (v) => setState(() => _protein = v),
                        onCarbsChanged: (v) => setState(() => _carbs = v),
                        onFatChanged: (v) => setState(() => _fat = v),
                        onGoalChanged: (v) {
                          _goal = v;
                          _recalculateAutoMacros();
                        },
                        onSexChanged: (v) {
                          _sex = v;
                          _recalculateAutoMacros();
                        },
                        onAgeChanged: (v) {
                          _age = v;
                          _recalculateAutoMacros();
                        },
                        onWeightChanged: (v) {
                          _weight = v;
                          _recalculateAutoMacros();
                        },
                        onHeightChanged: (v) {
                          _height = v;
                          _recalculateAutoMacros();
                        },
                        onActivityChanged: (v) {
                          _activityLevel = v;
                          _recalculateAutoMacros();
                        },
                      ),
                      StepDaysSelection(
                        days: _days,
                        onDaysChanged: (v) => setState(() => _days = v),
                      ),
                      StepPlanConfig(
                        mealsPerDay: _mealsPerDay,
                        varietyLevel: _varietyLevel,
                        onMealsPerDayChanged: (v) =>
                            setState(() => _mealsPerDay = v),
                        onVarietyChanged: (v) =>
                            setState(() => _varietyLevel = v),
                      ),
                    ],
                  )
                : StepDietResult(
                    dietDays: _dietResult,
                    isGenerating: _isGenerating,
                    onRegenerate: () {
                      setState(() {
                        _dietResult = null;
                        _isGenerating = false;
                        _currentStep = 0;
                      });
                      _pageController.jumpToPage(0);
                    },
                    onGoToShoppingList: () {
                      widget.onGoToShoppingList?.call();
                    },
                  ),
          ),

          // Bottom button
          if (_currentStep < 6)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _currentStep == 5
                      ? ElevatedButton.icon(
                          onPressed: _nextStep,
                          icon: const Icon(Icons.auto_awesome, size: 20),
                          label: const Text('Generar Dieta'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _nextStep,
                          child: const Text('Continuar'),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Modelos de datos
class MealItem {
  final String name;
  final double carbs;
  final double protein;
  final double fat;
  final int calories;

  const MealItem(this.name, this.carbs, this.protein, this.fat, this.calories);
}

class Meal {
  final String name;
  final List<MealItem> items;

  const Meal({required this.name, required this.items});

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0.0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0.0, (sum, item) => sum + item.fat);
}

class DietDay {
  final int dayNumber;
  final List<Meal> meals;

  const DietDay({required this.dayNumber, required this.meals});

  int get totalCalories => meals.fold(0, (sum, m) => sum + m.totalCalories);
  double get totalProtein => meals.fold(0.0, (sum, m) => sum + m.totalProtein);
  double get totalCarbs => meals.fold(0.0, (sum, m) => sum + m.totalCarbs);
  double get totalFat => meals.fold(0.0, (sum, m) => sum + m.totalFat);
}
