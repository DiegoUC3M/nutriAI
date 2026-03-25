// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NutriAI';

  @override
  String get splashTagline => 'Your smart nutrition';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboardingTitle1 => 'Welcome to NutriAI';

  @override
  String get onboardingDesc1 =>
      'Your smart personalized nutrition assistant. Design diets tailored to your body, goals, and food preferences.';

  @override
  String get onboardingTitle2 => 'Total personalization';

  @override
  String get onboardingDesc2 =>
      'Indicate your favorite foods, allergies, and dislikes. NutriAI will create meal plans you\'ll truly enjoy.';

  @override
  String get onboardingTitle3 => 'Custom macros';

  @override
  String get onboardingDesc3 =>
      'We calculate your caloric and macronutrient needs based on your weight, height, physical activity, and goal: lose fat, maintain, or build muscle.';

  @override
  String get onboardingTitle4 => 'Complete weekly diet';

  @override
  String get onboardingDesc4 =>
      'Generate day-by-day meal plans with all meals: breakfast, lunch, snack, and dinner, adjusted to your macros.';

  @override
  String get onboardingTitle5 => 'Shopping list';

  @override
  String get onboardingDesc5 =>
      'Automatically get the ingredient list you need, organized by category. Just take it to the store.';

  @override
  String get tabNutrition => 'NUTRITION';

  @override
  String get tabShopping => 'SHOPPING';

  @override
  String get shoppingListTitle => 'Shopping List';

  @override
  String get noShoppingList => 'No shopping list';

  @override
  String get noShoppingListDesc =>
      'Generate a diet first from the Nutrition tab to see your shopping list.';

  @override
  String get goToNutrition => 'Go to Nutrition';

  @override
  String get continueButton => 'Continue';

  @override
  String get generateDiet => 'Generate Diet';

  @override
  String get categoriesWithoutFood => 'Categories without food';

  @override
  String get categoriesWithoutFoodDesc =>
      'Your allergies and discarded foods have eliminated all options for:';

  @override
  String get categoriesWithoutFoodQuestion =>
      'The generated diet may not be balanced. Do you want to continue anyway?';

  @override
  String get goBack => 'Go back';

  @override
  String get generateAnyway => 'Generate anyway';

  @override
  String get categoryProteins => 'Proteins';

  @override
  String get categoryCarbs => 'Carbohydrates';

  @override
  String get categoryFats => 'Fats';

  @override
  String get allergiesTitle => 'Do you have allergies?';

  @override
  String get allergiesSubtitle =>
      'Select your allergies or intolerances. If you don\'t have any, tap Continue.';

  @override
  String get allergiesCardTitle => 'Allergies and intolerances';

  @override
  String get allergiesCardSubtitle =>
      'For some, you can fine-tune food by food.';

  @override
  String refine(String tag) {
    return 'Refine: $tag';
  }

  @override
  String get blockAll => 'Block all';

  @override
  String get unblockAll => 'Unblock all';

  @override
  String get allergyHelpText => 'Red = can\'t eat · Green = can eat';

  @override
  String get favoritesTitle => 'What do you like to eat?';

  @override
  String get favoritesSubtitle =>
      'Select your favorite foods. They will appear more often in your diet.';

  @override
  String get favoritesInfoText =>
      'If you don\'t select anything, all foods will have the same chance of appearing. The ones you mark here will appear more frequently.';

  @override
  String get myFavorites => 'My favorites';

  @override
  String get openCategoryAndSelect => 'Open each category and select';

  @override
  String get dislikedTitle => 'What don\'t you like?';

  @override
  String get dislikedSubtitle =>
      'These foods will never appear in your diet. If you don\'t want to discard anything, tap Continue.';

  @override
  String get dislikedInfoText =>
      'If you don\'t select anything, it means you don\'t want to discard any food. The ones you mark here won\'t appear in your diet.';

  @override
  String get iDontLike => 'I don\'t like';

  @override
  String get configureMacros => 'Set up your macros';

  @override
  String get macrosSubtitle =>
      'Choose how you want to define your macronutrients.';

  @override
  String get automatic => 'Automatic';

  @override
  String get weCalculateForYou => 'We calculate for you';

  @override
  String get manual => 'Manual';

  @override
  String get youDecide => 'You decide';

  @override
  String get whatIsYourGoal => 'What is your goal?';

  @override
  String get loseFat => '🔥 Lose fat';

  @override
  String get maintainWeight => '⚖️ Maintain weight';

  @override
  String get gainMuscle => '💪 Build muscle';

  @override
  String get sexLabel => 'Sex';

  @override
  String get male => '♂ Male';

  @override
  String get female => '♀ Female';

  @override
  String get ageLabel => 'Age';

  @override
  String get weightLabel => 'Weight';

  @override
  String get heightLabel => 'Height';

  @override
  String get yearsUnit => 'years';

  @override
  String get kgUnit => 'kg';

  @override
  String get cmUnit => 'cm';

  @override
  String get activityLevel => 'Physical activity level';

  @override
  String get sedentary => '🪑 Sedentary';

  @override
  String get sedentaryDesc => 'Little or no exercise, office work';

  @override
  String get lightActivity => '🚶 Light';

  @override
  String get lightActivityDesc => 'Light exercise 1-3 days/week';

  @override
  String get moderateActivity => '🏃 Moderate';

  @override
  String get moderateActivityDesc => 'Moderate exercise 3-5 days/week';

  @override
  String get activeActivity => '🏋️ Active';

  @override
  String get activeActivityDesc => 'Intense exercise 6-7 days/week';

  @override
  String get veryActiveActivity => '⚡ Very active';

  @override
  String get veryActiveActivityDesc =>
      'Very intense exercise or daily physical work';

  @override
  String get yourCalculatedPlan => 'YOUR CALCULATED PLAN';

  @override
  String get estimatedCalories => 'ESTIMATED CALORIES';

  @override
  String get proteinLabel => 'Protein';

  @override
  String get carbsLabel => 'Carbs';

  @override
  String get fatLabel => 'Fat';

  @override
  String get proteinsLabel => 'Proteins';

  @override
  String get carbohydratesLabel => 'Carbohydrates';

  @override
  String get fatsLabel => 'Fats';

  @override
  String get howManyDays => 'How many days?';

  @override
  String get daysSubtitle => 'Choose your diet plan duration. Maximum 30 days.';

  @override
  String get daysUnit => 'DAYS';

  @override
  String get oneDay => '1 day';

  @override
  String get thirtyDays => '30 days';

  @override
  String get quickAccess => 'Quick access';

  @override
  String nDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get configureYourPlan => 'Set up your plan';

  @override
  String get planConfigSubtitle => 'Choose meals per day and diet variety.';

  @override
  String get mealsPerDay => 'Meals per day';

  @override
  String get varietyLevel => 'Variety level';

  @override
  String get lowVariety => 'Low';

  @override
  String get lowVarietyDesc => 'Repeat meals between days (easier to prepare)';

  @override
  String get mediumVariety => 'Medium';

  @override
  String get mediumVarietyDesc => 'Some daily variation';

  @override
  String get highVariety => 'High';

  @override
  String get highVarietyDesc =>
      'Maximum variety, more different ingredients each day';

  @override
  String dayN(int n) {
    return 'Day $n';
  }

  @override
  String get caloriesLabel => 'Calories';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get shoppingButton => 'Shopping';

  @override
  String get adNotice => 'A short ad will be shown when regenerating';

  @override
  String get generatingDiet => 'Generating your diet with AI...';

  @override
  String get analyzingPreferences => 'Analyzing preferences and macros';

  @override
  String get noResults => 'No results';

  @override
  String get generateDietFirst => 'Generate a diet first';

  @override
  String daysAndIngredients(int days, int items) {
    return '$days days · $items ingredients';
  }

  @override
  String get estimatedQuantities => 'Estimated quantities based on your diet';

  @override
  String purchasedProgress(int checked, int total) {
    return '$checked / $total purchased';
  }

  @override
  String stepOf(int current, int total) {
    return '$current/$total';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get user => 'User';

  @override
  String get freePlan => 'Free Plan';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get streakLabel => 'STREAK';

  @override
  String get daysUnitUpper => 'DAYS';

  @override
  String get dietsLabel => 'DIETS';

  @override
  String get createdLabel => 'CREATED';

  @override
  String get aiNutriAI => 'AI NutriAI';

  @override
  String get aiDescription =>
      'Generate personalized diets with artificial intelligence based on your preferences.';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get settingsAndData => 'SETTINGS & DATA';

  @override
  String get personalData => 'Personal Data';

  @override
  String get personalDataSub => 'Height, weight, and age';

  @override
  String get foodPreferences => 'Food Preferences';

  @override
  String get foodPreferencesSub => 'Allergies and favorites';

  @override
  String get nutritionalGoals => 'Nutritional Goals';

  @override
  String get nutritionalGoalsSub => 'Macros and calories';

  @override
  String get sync => 'Sync';

  @override
  String get syncSub => 'Cloud status';

  @override
  String get logOut => 'Log Out';
}
