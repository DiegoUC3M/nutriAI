import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'steps/step_food_preferences.dart';
import 'steps/step_macros_config.dart';
import 'steps/step_days_selection.dart';
import 'steps/step_diet_result.dart';

class NutritionFlowScreen extends StatefulWidget {
  const NutritionFlowScreen({super.key});

  @override
  State<NutritionFlowScreen> createState() => _NutritionFlowScreenState();
}

class _NutritionFlowScreenState extends State<NutritionFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 4;

  // Datos del flujo
  final Set<String> _favoritesFoods = {};
  final Set<String> _allergies = {};
  final Set<String> _dislikedFoods = {};

  // Macros
  bool _autoMacros = true;
  double _protein = 150;
  double _carbs = 250;
  double _fat = 70;

  // Auto macros data
  String _goal = 'maintain';
  String _sex = 'male';
  int _age = 25;
  double _weight = 70;
  double _height = 170;
  String _activityLevel = 'moderate';

  // Días
  int _days = 7;

  // Resultado
  List<DietDay>? _dietResult;
  bool _isGenerating = false;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 2) {
        _generateDiet();
      }
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
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
    setState(() => _isGenerating = true);

    // Simulación de generación de dieta (aquí irá la IA)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _dietResult = _buildMockDiet();
        _isGenerating = false;
      });
    });
  }

  List<DietDay> _buildMockDiet() {
    final meals = [
      'Desayuno',
      'Media mañana',
      'Almuerzo',
      'Merienda',
      'Cena',
    ];

    final sampleFoods = {
      'Desayuno': [
        MealItem('Avena con plátano', 60, 12, 6, 350),
        MealItem('Tortilla de claras', 5, 30, 3, 170),
      ],
      'Media mañana': [
        MealItem('Yogur griego con frutos secos', 15, 18, 12, 240),
      ],
      'Almuerzo': [
        MealItem('Pechuga de pollo a la plancha', 0, 40, 5, 200),
        MealItem('Arroz integral (150g)', 50, 6, 2, 240),
        MealItem('Ensalada mixta con aceite de oliva', 8, 3, 10, 130),
      ],
      'Merienda': [
        MealItem('Batido de proteínas con leche', 12, 30, 4, 200),
      ],
      'Cena': [
        MealItem('Salmón al horno', 0, 35, 15, 280),
        MealItem('Verduras salteadas', 15, 5, 5, 120),
        MealItem('Patata cocida (200g)', 35, 4, 0, 160),
      ],
    };

    return List.generate(_days, (i) {
      return DietDay(
        dayNumber: i + 1,
        meals: meals.map((mealName) {
          return Meal(
            name: mealName,
            items: sampleFoods[mealName] ?? [],
          );
        }).toList(),
      );
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
        leading: _currentStep > 0 && _currentStep < 3
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _prevStep,
              )
            : null,
        actions: [
          if (_currentStep < 3)
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
          if (_currentStep < 3)
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
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StepFoodPreferences(
                  favorites: _favoritesFoods,
                  allergies: _allergies,
                  disliked: _dislikedFoods,
                  onFavoritesChanged: (v) => setState(() {}),
                  onAllergiesChanged: (v) => setState(() {}),
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
                  onAutoMacrosChanged: (v) => setState(() => _autoMacros = v),
                  onProteinChanged: (v) => setState(() => _protein = v),
                  onCarbsChanged: (v) => setState(() => _carbs = v),
                  onFatChanged: (v) => setState(() => _fat = v),
                  onGoalChanged: (v) => setState(() => _goal = v),
                  onSexChanged: (v) => setState(() => _sex = v),
                  onAgeChanged: (v) => setState(() => _age = v),
                  onWeightChanged: (v) => setState(() => _weight = v),
                  onHeightChanged: (v) => setState(() => _height = v),
                  onActivityChanged: (v) => setState(() => _activityLevel = v),
                ),
                StepDaysSelection(
                  days: _days,
                  onDaysChanged: (v) => setState(() => _days = v),
                ),
                StepDietResult(
                  dietDays: _dietResult,
                  isGenerating: _isGenerating,
                  onRegenerate: () {
                    setState(() {
                      _dietResult = null;
                      _currentStep = 0;
                    });
                    _pageController.jumpToPage(0);
                  },
                ),
              ],
            ),
          ),

          // Bottom button
          if (_currentStep < 3)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _currentStep == 2
                      ? ElevatedButton.icon(
                          onPressed: _nextStep,
                          icon: const Icon(Icons.auto_awesome, size: 20),
                          label: const Text('Generar Dieta con IA'),
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
