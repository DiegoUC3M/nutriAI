import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'NutriAI'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your smart nutrition'**
  String get splashTagline;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingStart;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to NutriAI'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Your smart personalized nutrition assistant. Design diets tailored to your body, goals, and food preferences.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Total personalization'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Indicate your favorite foods, allergies, and dislikes. NutriAI will create meal plans you\'ll truly enjoy.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Custom macros'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'We calculate your caloric and macronutrient needs based on your weight, height, physical activity, and goal: lose fat, maintain, or build muscle.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Complete weekly diet'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Generate day-by-day meal plans with all meals: breakfast, lunch, snack, and dinner, adjusted to your macros.'**
  String get onboardingDesc4;

  /// No description provided for @onboardingTitle5.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get onboardingTitle5;

  /// No description provided for @onboardingDesc5.
  ///
  /// In en, this message translates to:
  /// **'Automatically get the ingredient list you need, organized by category. Just take it to the store.'**
  String get onboardingDesc5;

  /// No description provided for @tabNutrition.
  ///
  /// In en, this message translates to:
  /// **'NUTRITION'**
  String get tabNutrition;

  /// No description provided for @tabShopping.
  ///
  /// In en, this message translates to:
  /// **'SHOPPING'**
  String get tabShopping;

  /// No description provided for @shoppingListTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingListTitle;

  /// No description provided for @noShoppingList.
  ///
  /// In en, this message translates to:
  /// **'No shopping list'**
  String get noShoppingList;

  /// No description provided for @noShoppingListDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate a diet first from the Nutrition tab to see your shopping list.'**
  String get noShoppingListDesc;

  /// No description provided for @goToNutrition.
  ///
  /// In en, this message translates to:
  /// **'Go to Nutrition'**
  String get goToNutrition;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @generateDiet.
  ///
  /// In en, this message translates to:
  /// **'Generate Diet'**
  String get generateDiet;

  /// No description provided for @categoriesWithoutFood.
  ///
  /// In en, this message translates to:
  /// **'Categories without food'**
  String get categoriesWithoutFood;

  /// No description provided for @categoriesWithoutFoodDesc.
  ///
  /// In en, this message translates to:
  /// **'Your allergies and discarded foods have eliminated all options for:'**
  String get categoriesWithoutFoodDesc;

  /// No description provided for @categoriesWithoutFoodQuestion.
  ///
  /// In en, this message translates to:
  /// **'The generated diet may not be balanced. Do you want to continue anyway?'**
  String get categoriesWithoutFoodQuestion;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @generateAnyway.
  ///
  /// In en, this message translates to:
  /// **'Generate anyway'**
  String get generateAnyway;

  /// No description provided for @categoryProteins.
  ///
  /// In en, this message translates to:
  /// **'Proteins'**
  String get categoryProteins;

  /// No description provided for @categoryCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get categoryCarbs;

  /// No description provided for @categoryFats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get categoryFats;

  /// No description provided for @allergiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you have allergies?'**
  String get allergiesTitle;

  /// No description provided for @allergiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your allergies or intolerances. If you don\'t have any, tap Continue.'**
  String get allergiesSubtitle;

  /// No description provided for @allergiesCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Allergies and intolerances'**
  String get allergiesCardTitle;

  /// No description provided for @allergiesCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For some, you can fine-tune food by food.'**
  String get allergiesCardSubtitle;

  /// No description provided for @refine.
  ///
  /// In en, this message translates to:
  /// **'Refine: {tag}'**
  String refine(String tag);

  /// No description provided for @blockAll.
  ///
  /// In en, this message translates to:
  /// **'Block all'**
  String get blockAll;

  /// No description provided for @unblockAll.
  ///
  /// In en, this message translates to:
  /// **'Unblock all'**
  String get unblockAll;

  /// No description provided for @allergyHelpText.
  ///
  /// In en, this message translates to:
  /// **'Red = can\'t eat · Green = can eat'**
  String get allergyHelpText;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you like to eat?'**
  String get favoritesTitle;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your favorite foods. They will appear more often in your diet.'**
  String get favoritesSubtitle;

  /// No description provided for @favoritesInfoText.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t select anything, all foods will have the same chance of appearing. The ones you mark here will appear more frequently.'**
  String get favoritesInfoText;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My favorites'**
  String get myFavorites;

  /// No description provided for @openCategoryAndSelect.
  ///
  /// In en, this message translates to:
  /// **'Open each category and select'**
  String get openCategoryAndSelect;

  /// No description provided for @dislikedTitle.
  ///
  /// In en, this message translates to:
  /// **'What don\'t you like?'**
  String get dislikedTitle;

  /// No description provided for @dislikedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These foods will never appear in your diet. If you don\'t want to discard anything, tap Continue.'**
  String get dislikedSubtitle;

  /// No description provided for @dislikedInfoText.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t select anything, it means you don\'t want to discard any food. The ones you mark here won\'t appear in your diet.'**
  String get dislikedInfoText;

  /// No description provided for @iDontLike.
  ///
  /// In en, this message translates to:
  /// **'I don\'t like'**
  String get iDontLike;

  /// No description provided for @configureMacros.
  ///
  /// In en, this message translates to:
  /// **'Set up your macros'**
  String get configureMacros;

  /// No description provided for @macrosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to define your macronutrients.'**
  String get macrosSubtitle;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @weCalculateForYou.
  ///
  /// In en, this message translates to:
  /// **'We calculate for you'**
  String get weCalculateForYou;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @youDecide.
  ///
  /// In en, this message translates to:
  /// **'You decide'**
  String get youDecide;

  /// No description provided for @whatIsYourGoal.
  ///
  /// In en, this message translates to:
  /// **'What is your goal?'**
  String get whatIsYourGoal;

  /// No description provided for @loseFat.
  ///
  /// In en, this message translates to:
  /// **'🔥 Lose fat'**
  String get loseFat;

  /// No description provided for @maintainWeight.
  ///
  /// In en, this message translates to:
  /// **'⚖️ Maintain weight'**
  String get maintainWeight;

  /// No description provided for @gainMuscle.
  ///
  /// In en, this message translates to:
  /// **'💪 Build muscle'**
  String get gainMuscle;

  /// No description provided for @sexLabel.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sexLabel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'♂ Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'♀ Female'**
  String get female;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @yearsUnit.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get yearsUnit;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @cmUnit.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cmUnit;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Physical activity level'**
  String get activityLevel;

  /// No description provided for @sedentary.
  ///
  /// In en, this message translates to:
  /// **'🪑 Sedentary'**
  String get sedentary;

  /// No description provided for @sedentaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Little or no exercise, office work'**
  String get sedentaryDesc;

  /// No description provided for @lightActivity.
  ///
  /// In en, this message translates to:
  /// **'🚶 Light'**
  String get lightActivity;

  /// No description provided for @lightActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Light exercise 1-3 days/week'**
  String get lightActivityDesc;

  /// No description provided for @moderateActivity.
  ///
  /// In en, this message translates to:
  /// **'🏃 Moderate'**
  String get moderateActivity;

  /// No description provided for @moderateActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Moderate exercise 3-5 days/week'**
  String get moderateActivityDesc;

  /// No description provided for @activeActivity.
  ///
  /// In en, this message translates to:
  /// **'🏋️ Active'**
  String get activeActivity;

  /// No description provided for @activeActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Intense exercise 6-7 days/week'**
  String get activeActivityDesc;

  /// No description provided for @veryActiveActivity.
  ///
  /// In en, this message translates to:
  /// **'⚡ Very active'**
  String get veryActiveActivity;

  /// No description provided for @veryActiveActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Very intense exercise or daily physical work'**
  String get veryActiveActivityDesc;

  /// No description provided for @yourCalculatedPlan.
  ///
  /// In en, this message translates to:
  /// **'YOUR CALCULATED PLAN'**
  String get yourCalculatedPlan;

  /// No description provided for @estimatedCalories.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED CALORIES'**
  String get estimatedCalories;

  /// No description provided for @proteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get proteinLabel;

  /// No description provided for @carbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbsLabel;

  /// No description provided for @fatLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fatLabel;

  /// No description provided for @proteinsLabel.
  ///
  /// In en, this message translates to:
  /// **'Proteins'**
  String get proteinsLabel;

  /// No description provided for @carbohydratesLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydratesLabel;

  /// No description provided for @fatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fatsLabel;

  /// No description provided for @howManyDays.
  ///
  /// In en, this message translates to:
  /// **'How many days?'**
  String get howManyDays;

  /// No description provided for @daysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your diet plan duration. Maximum 30 days.'**
  String get daysSubtitle;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get daysUnit;

  /// No description provided for @oneDay.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get oneDay;

  /// No description provided for @thirtyDays.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get thirtyDays;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get quickAccess;

  /// No description provided for @nDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String nDays(int count);

  /// No description provided for @configureYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Set up your plan'**
  String get configureYourPlan;

  /// No description provided for @planConfigSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose meals per day and diet variety.'**
  String get planConfigSubtitle;

  /// No description provided for @mealsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Meals per day'**
  String get mealsPerDay;

  /// No description provided for @varietyLevel.
  ///
  /// In en, this message translates to:
  /// **'Variety level'**
  String get varietyLevel;

  /// No description provided for @lowVariety.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowVariety;

  /// No description provided for @lowVarietyDesc.
  ///
  /// In en, this message translates to:
  /// **'Repeat meals between days (easier to prepare)'**
  String get lowVarietyDesc;

  /// No description provided for @mediumVariety.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumVariety;

  /// No description provided for @mediumVarietyDesc.
  ///
  /// In en, this message translates to:
  /// **'Some daily variation'**
  String get mediumVarietyDesc;

  /// No description provided for @highVariety.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highVariety;

  /// No description provided for @highVarietyDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum variety, more different ingredients each day'**
  String get highVarietyDesc;

  /// No description provided for @dayN.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String dayN(int n);

  /// No description provided for @caloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get caloriesLabel;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @shoppingButton.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shoppingButton;

  /// No description provided for @adNotice.
  ///
  /// In en, this message translates to:
  /// **'A short ad will be shown when regenerating'**
  String get adNotice;

  /// No description provided for @generatingDiet.
  ///
  /// In en, this message translates to:
  /// **'Generating your diet with AI...'**
  String get generatingDiet;

  /// No description provided for @analyzingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Analyzing preferences and macros'**
  String get analyzingPreferences;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @generateDietFirst.
  ///
  /// In en, this message translates to:
  /// **'Generate a diet first'**
  String get generateDietFirst;

  /// No description provided for @daysAndIngredients.
  ///
  /// In en, this message translates to:
  /// **'{days} days · {items} ingredients'**
  String daysAndIngredients(int days, int items);

  /// No description provided for @estimatedQuantities.
  ///
  /// In en, this message translates to:
  /// **'Estimated quantities based on your diet'**
  String get estimatedQuantities;

  /// No description provided for @purchasedProgress.
  ///
  /// In en, this message translates to:
  /// **'{checked} / {total} purchased'**
  String purchasedProgress(int checked, int total);

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String stepOf(int current, int total);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get streakLabel;

  /// No description provided for @daysUnitUpper.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get daysUnitUpper;

  /// No description provided for @dietsLabel.
  ///
  /// In en, this message translates to:
  /// **'DIETS'**
  String get dietsLabel;

  /// No description provided for @createdLabel.
  ///
  /// In en, this message translates to:
  /// **'CREATED'**
  String get createdLabel;

  /// No description provided for @aiNutriAI.
  ///
  /// In en, this message translates to:
  /// **'AI NutriAI'**
  String get aiNutriAI;

  /// No description provided for @aiDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate personalized diets with artificial intelligence based on your preferences.'**
  String get aiDescription;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @settingsAndData.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS & DATA'**
  String get settingsAndData;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @personalDataSub.
  ///
  /// In en, this message translates to:
  /// **'Height, weight, and age'**
  String get personalDataSub;

  /// No description provided for @foodPreferences.
  ///
  /// In en, this message translates to:
  /// **'Food Preferences'**
  String get foodPreferences;

  /// No description provided for @foodPreferencesSub.
  ///
  /// In en, this message translates to:
  /// **'Allergies and favorites'**
  String get foodPreferencesSub;

  /// No description provided for @nutritionalGoals.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Goals'**
  String get nutritionalGoals;

  /// No description provided for @nutritionalGoalsSub.
  ///
  /// In en, this message translates to:
  /// **'Macros and calories'**
  String get nutritionalGoalsSub;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @syncSub.
  ///
  /// In en, this message translates to:
  /// **'Cloud status'**
  String get syncSub;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
