import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/food_database.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ad_service.dart';
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
  PageController _pageController = PageController();
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
    _loadSavedDiet();
  }

  Future<void> _loadSavedDiet() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('saved_diet');
    if (json == null) return;
    try {
      final saved = jsonDecode(json);
      final list = (saved is List ? saved : saved['diet']) as List;
      final config = saved is List
          ? null
          : MealPlanConfig.fromJson(saved['config'] as Map<String, dynamic>);
      final days = list.map((d) => DietDay.fromJson(d as Map<String, dynamic>)).toList();
      if (!mounted || days.isEmpty) return;
      setState(() {
        _dietResult = days;
        _savedPlanConfig = config;
        _currentStep = 6;
      });
      widget.onDietChanged?.call(_dietResult);
    } catch (e) {
      debugPrint('Error loading saved diet: $e');
    }
  }

  Future<void> _saveDiet(List<DietDay> diet, MealPlanConfig config) async {
    final json = jsonEncode({
      'diet': diet.map((d) => d.toJson()).toList(),
      'config': config.toJson(),
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_diet', json);
  }

  Future<void> _clearSavedDiet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_diet');
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
  MealPlanConfig? _savedPlanConfig;
  bool _isGenerating = false;
  String? _loadingMessage;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 0) {
        // Leaving allergies → remove stale favorites/disliked
        final allowed = filteredFoodGroups(_allergies, _allergyExceptions)
            .expand((g) => g.foods)
            .toSet();
        _favoritesFoods.retainWhere(allowed.contains);
        _dislikedFoods.retainWhere(allowed.contains);
      }
      if (_currentStep == 5) {
        // Check pool sufficiency before generating
        _checkPoolAndGenerate();
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

  void _startGeneration() {
    setState(() {
      _currentStep = 6;
      _isGenerating = true;
      _dietResult = null;
      _loadingMessage = null;
    });
    _generateDiet(MealPlanConfig(
      targetProtein: _protein,
      targetCarbs: _carbs,
      targetFat: _fat,
      days: _days,
      mealsPerDay: _mealsPerDay,
      varietyLevel: _varietyLevel,
      favorites: Set.of(_favoritesFoods),
      allergies: Set.of(_allergies),
      allergyExceptions: Set.of(_allergyExceptions),
      disliked: Set.of(_dislikedFoods),
    ));
  }

  void _checkPoolAndGenerate() {
    final pool = foodDatabase.where((food) {
      if (food.allergenTags.any((tag) => _allergies.contains(tag))) {
        if (!_allergyExceptions.contains(food.name)) return false;
      }
      if (_dislikedFoods.contains(food.name)) return false;
      return true;
    }).toList();

    const categoryLabels = <FoodCategory, String>{
      FoodCategory.protein: 'protein',
      FoodCategory.carb: 'carb',
      FoodCategory.fat: 'fat',
    };

    final missing = <String>[];
    for (final entry in categoryLabels.entries) {
      if (!pool.any((f) => f.category == entry.key)) {
        missing.add(entry.value);
      }
    }

    if (missing.isEmpty) {
      _startGeneration();
      return;
    }

    showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        final localizedMissing = missing.map((key) {
          switch (key) {
            case 'protein': return l10n.categoryProteins;
            case 'carb': return l10n.categoryCarbs;
            case 'fat': return l10n.categoryFats;
            default: return key;
          }
        }).toList();
        return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.categoriesWithoutFood,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.categoriesWithoutFoodDesc,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 12),
            ...localizedMissing.map((cat) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.block, color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Text(cat, style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error,
                  )),
                ],
              ),
            )),
            const SizedBox(height: 8),
            Text(
              l10n.categoriesWithoutFoodQuestion,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.goBack, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.generateAnyway, style: const TextStyle(color: AppColors.warning)),
          ),
        ],
      );
      },
    ).then((proceed) {
      if (proceed == true) _startGeneration();
    });
  }

  void _generateDiet(MealPlanConfig config) {
    setState(() {
      _isGenerating = true;
      _dietResult = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      try {
        final result = MealPlanner.generate(config);

        if (!mounted) return;
        setState(() {
          _dietResult = result;
          _savedPlanConfig = config;
          _isGenerating = false;
        });
        widget.onDietChanged?.call(_dietResult);
        _saveDiet(result, config);
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
    final l10n = AppLocalizations.of(context)!;
    final savedPlanConfig = _savedPlanConfig;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        leading: _currentStep > 0 && _currentStep < 6
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _prevStep,
              )
            : null,
        actions: [
          if (_currentStep < 6)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  l10n.stepOf(_currentStep + 1, _totalSteps),
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
                        allergies: _allergies,
                        allergyExceptions: _allergyExceptions,
                        excludedFoods: _dislikedFoods,
                        onFavoritesChanged: (v) => setState(() {}),
                      ),
                      StepDisliked(
                        disliked: _dislikedFoods,
                        allergies: _allergies,
                        allergyExceptions: _allergyExceptions,
                        excludedFoods: _favoritesFoods,
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
                            const protein = StepMacrosConfig.proteinRange;
                            const carbs = StepMacrosConfig.carbsRange;
                            const fat = StepMacrosConfig.fatRange;
                            setState(() {
                              _protein = _protein.clamp(protein.min, protein.max);
                              _carbs = _carbs.clamp(carbs.min, carbs.max);
                              _fat = _fat.clamp(fat.min, fat.max);
                            });
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
                    loadingMessage: _loadingMessage,
                    onRegenerate: () {
                      final l10n = AppLocalizations.of(context)!;
                      setState(() {
                        _isGenerating = true;
                        _dietResult = null;
                        _loadingMessage = l10n.goingBackToStep1;
                      });
                      AdService.instance.showInterstitial(
                        onDismissed: () {
                          Future.delayed(const Duration(milliseconds: 800), () {
                            if (!mounted) return;
                            _clearSavedDiet();
                            _pageController.dispose();
                            _pageController = PageController();
                            setState(() {
                              _dietResult = null;
                              _savedPlanConfig = null;
                              _isGenerating = false;
                              _currentStep = 0;
                            });
                          });
                        },
                      );
                    },
                    onNewDiet: savedPlanConfig == null ? null : () {
                      setState(() {
                        _isGenerating = true;
                        _dietResult = null;
                        _loadingMessage = null;
                      });
                      AdService.instance.showInterstitial(
                        onDismissed: () => _generateDiet(savedPlanConfig),
                      );
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
                          label: Text(l10n.generateDiet),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _nextStep,
                          child: Text(l10n.continueButton),
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
  final double grams;

  const MealItem(this.name, this.carbs, this.protein, this.fat, this.calories, {this.grams = 0});

  Map<String, dynamic> toJson() => {
    'name': name, 'carbs': carbs, 'protein': protein, 'fat': fat, 'calories': calories, 'grams': grams,
  };

  factory MealItem.fromJson(Map<String, dynamic> j) => MealItem(
    j['name'] as String,
    (j['carbs'] as num).toDouble(),
    (j['protein'] as num).toDouble(),
    (j['fat'] as num).toDouble(),
    (j['calories'] as num).toInt(),
    grams: (j['grams'] as num?)?.toDouble() ?? 0,
  );
}

class Meal {
  final String name;
  final List<MealItem> items;

  const Meal({required this.name, required this.items});

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0.0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0.0, (sum, item) => sum + item.fat);

  Map<String, dynamic> toJson() => {
    'name': name, 'items': items.map((i) => i.toJson()).toList(),
  };

  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    name: j['name'] as String,
    items: (j['items'] as List).map((i) => MealItem.fromJson(i as Map<String, dynamic>)).toList(),
  );
}

class DietDay {
  final int dayNumber;
  final List<Meal> meals;

  const DietDay({required this.dayNumber, required this.meals});

  int get totalCalories => meals.fold(0, (sum, m) => sum + m.totalCalories);
  double get totalProtein => meals.fold(0.0, (sum, m) => sum + m.totalProtein);
  double get totalCarbs => meals.fold(0.0, (sum, m) => sum + m.totalCarbs);
  double get totalFat => meals.fold(0.0, (sum, m) => sum + m.totalFat);

  Map<String, dynamic> toJson() => {
    'dayNumber': dayNumber, 'meals': meals.map((m) => m.toJson()).toList(),
  };

  factory DietDay.fromJson(Map<String, dynamic> j) => DietDay(
    dayNumber: (j['dayNumber'] as num).toInt(),
    meals: (j['meals'] as List).map((m) => Meal.fromJson(m as Map<String, dynamic>)).toList(),
  );
}
