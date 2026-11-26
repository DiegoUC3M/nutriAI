// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'NutriAI';

  @override
  String get splashTagline => 'Tu nutrición inteligente';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingStart => 'Empezar';

  @override
  String get onboardingTitle1 => 'Bienvenido a NutriAI';

  @override
  String get onboardingDesc1 =>
      'Tu asistente inteligente de nutrición personalizada. Diseña dietas adaptadas a tu cuerpo, objetivos y gustos alimentarios.';

  @override
  String get onboardingTitle2 => 'Personalización total';

  @override
  String get onboardingDesc2 =>
      'Indica tus alimentos favoritos, alergias y lo que no te gusta. NutriAI creará planes de comida que realmente disfrutarás.';

  @override
  String get onboardingTitle3 => 'Macros a tu medida';

  @override
  String get onboardingDesc3 =>
      'Calculamos tus necesidades calóricas y de macronutrientes según tu peso, altura, actividad física y objetivo: perder grasa, mantenerte o ganar músculo.';

  @override
  String get onboardingTitle4 => 'Dieta semanal completa';

  @override
  String get onboardingDesc4 =>
      'Genera planes de alimentación día a día con todas las comidas: desayuno, almuerzo, merienda y cena, ajustados a tus macros.';

  @override
  String get onboardingTitle5 => 'Lista de la compra';

  @override
  String get onboardingDesc5 =>
      'Obtén automáticamente la lista de ingredientes que necesitas, organizada por categorías. Solo llévala al supermercado.';

  @override
  String get tabNutrition => 'NUTRICIÓN';

  @override
  String get tabShopping => 'COMPRA';

  @override
  String get adPrivacyOptions => 'Opciones de privacidad';

  @override
  String get shoppingListTitle => 'Lista de la compra';

  @override
  String get noShoppingList => 'Sin lista de compra';

  @override
  String get noShoppingListDesc =>
      'Genera una dieta primero desde la pestaña de Nutrición para ver tu lista de la compra.';

  @override
  String get goToNutrition => 'Ir a Nutrición';

  @override
  String get continueButton => 'Continuar';

  @override
  String get generateDiet => 'Generar Dieta';

  @override
  String get categoriesWithoutFood => 'Categorías sin alimentos';

  @override
  String get categoriesWithoutFoodDesc =>
      'Tus alergias y alimentos descartados han eliminado todas las opciones de:';

  @override
  String get categoriesWithoutFoodQuestion =>
      'La dieta generada puede no ser equilibrada. ¿Quieres continuar igualmente?';

  @override
  String get goBack => 'Volver';

  @override
  String get generateAnyway => 'Generar igualmente';

  @override
  String get categoryProteins => 'Proteínas';

  @override
  String get categoryCarbs => 'Carbohidratos';

  @override
  String get categoryFats => 'Grasas';

  @override
  String get allergiesTitle => '¿Tienes alergias?';

  @override
  String get allergiesSubtitle =>
      'Selecciona tus alergias o intolerancias. Si no tienes ninguna, pulsa Continuar.';

  @override
  String get allergiesCardTitle => 'Alergias e intolerancias';

  @override
  String get allergiesCardSubtitle =>
      'En algunas podrás afinar alimento por alimento.';

  @override
  String refine(String tag) {
    return 'Afinar: $tag';
  }

  @override
  String get blockAll => 'Bloquear todas';

  @override
  String get unblockAll => 'Desmarcar todas';

  @override
  String get allergyHelpText => 'Rojo = no puedes comerlo · Verde = sí puedes';

  @override
  String get favoritesTitle => '¿Qué te gusta comer?';

  @override
  String get favoritesSubtitle =>
      'Selecciona tus alimentos favoritos. Aparecerán con más frecuencia en tu dieta.';

  @override
  String get favoritesInfoText =>
      'Si no seleccionas nada, todos los alimentos tendrán la misma probabilidad de aparecer. Los que marques aquí aparecerán con más frecuencia.';

  @override
  String get myFavorites => 'Mis favoritos';

  @override
  String get openCategoryAndSelect => 'Abre cada categoría y selecciona';

  @override
  String get dislikedTitle => '¿Qué no te gusta?';

  @override
  String get dislikedSubtitle =>
      'Estos alimentos nunca aparecerán en tu dieta. Si no quieres descartar nada, pulsa Continuar.';

  @override
  String get dislikedInfoText =>
      'Si no seleccionas nada, significa que no quieres descartar ningún alimento. Los que marques aquí no aparecerán en tu dieta.';

  @override
  String get iDontLike => 'No me gustan';

  @override
  String get configureMacros => 'Configura tus macros';

  @override
  String get macrosSubtitle =>
      'Elige cómo quieres definir tus macronutrientes.';

  @override
  String get automatic => 'Automático';

  @override
  String get weCalculateForYou => 'Calculamos por ti';

  @override
  String get manual => 'Manual';

  @override
  String get youDecide => 'Tú decides';

  @override
  String get whatIsYourGoal => '¿Cuál es tu objetivo?';

  @override
  String get loseFat => '🔥 Perder grasa';

  @override
  String get maintainWeight => '⚖️ Mantener peso';

  @override
  String get gainMuscle => '💪 Ganar músculo';

  @override
  String get sexLabel => 'Sexo';

  @override
  String get male => '♂ Hombre';

  @override
  String get female => '♀ Mujer';

  @override
  String get ageLabel => 'Edad';

  @override
  String get weightLabel => 'Peso';

  @override
  String get heightLabel => 'Altura';

  @override
  String get yearsUnit => 'años';

  @override
  String get kgUnit => 'kg';

  @override
  String get cmUnit => 'cm';

  @override
  String get activityLevel => 'Nivel de actividad física';

  @override
  String get sedentary => '🪑 Sedentario';

  @override
  String get sedentaryDesc => 'Poco o ningún ejercicio, trabajo de oficina';

  @override
  String get lightActivity => '🚶 Ligera';

  @override
  String get lightActivityDesc => 'Ejercicio ligero 1-3 días/semana';

  @override
  String get moderateActivity => '🏃 Moderada';

  @override
  String get moderateActivityDesc => 'Ejercicio moderado 3-5 días/semana';

  @override
  String get activeActivity => '🏋️ Activa';

  @override
  String get activeActivityDesc => 'Ejercicio intenso 6-7 días/semana';

  @override
  String get veryActiveActivity => '⚡ Muy activa';

  @override
  String get veryActiveActivityDesc =>
      'Ejercicio muy intenso o trabajo físico diario';

  @override
  String get yourCalculatedPlan => 'TU PLAN CALCULADO';

  @override
  String get estimatedCalories => 'CALORÍAS ESTIMADAS';

  @override
  String get proteinLabel => 'Proteína';

  @override
  String get carbsLabel => 'Carbos';

  @override
  String get fatLabel => 'Grasa';

  @override
  String get proteinsLabel => 'Proteínas';

  @override
  String get carbohydratesLabel => 'Carbohidratos';

  @override
  String get fatsLabel => 'Grasas';

  @override
  String get howManyDays => '¿Cuántos días?';

  @override
  String get daysSubtitle =>
      'Elige la duración de tu plan de dieta. Máximo 30 días.';

  @override
  String get daysUnit => 'DÍAS';

  @override
  String get oneDay => '1 día';

  @override
  String get thirtyDays => '30 días';

  @override
  String get quickAccess => 'Acceso rápido';

  @override
  String nDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get configureYourPlan => 'Configura tu plan';

  @override
  String get planConfigSubtitle =>
      'Elige cuántas comidas al día y la variedad de tu dieta.';

  @override
  String get mealsPerDay => 'Comidas al día';

  @override
  String get varietyLevel => 'Nivel de variedad';

  @override
  String get lowVariety => 'Baja';

  @override
  String get lowVarietyDesc =>
      'Repite comidas entre días (más fácil de preparar)';

  @override
  String get mediumVariety => 'Media';

  @override
  String get mediumVarietyDesc => 'Algo de variación día a día';

  @override
  String get highVariety => 'Alta';

  @override
  String get highVarietyDesc =>
      'Máxima variedad, más ingredientes distintos cada día';

  @override
  String dayN(int n) {
    return 'Día $n';
  }

  @override
  String get caloriesLabel => 'Calorías';

  @override
  String get regenerate => 'Regenerar';

  @override
  String get regenerateDesc => 'Mismos ajustes, nueva dieta';

  @override
  String get restartFlow => 'Preferencias';

  @override
  String get restartFlowDesc => 'Volver al paso 1';

  @override
  String get shoppingButton => 'Compra';

  @override
  String get adNotice =>
      'Se mostrará un anuncio breve al regenerar o al volver al paso 1';

  @override
  String get generatingDiet => 'Generando tu dieta con IA...';

  @override
  String get goingBackToStep1 => 'Volviendo al paso 1...';

  @override
  String get analyzingPreferences => 'Analizando preferencias y macros';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get generateDietFirst => 'Genera una dieta primero';

  @override
  String daysAndIngredients(int days, int items) {
    return '$days días · $items ingredientes';
  }

  @override
  String get estimatedQuantities => 'Cantidades estimadas en base a tu dieta';

  @override
  String purchasedProgress(int checked, int total) {
    return '$checked / $total comprados';
  }

  @override
  String stepOf(int current, int total) {
    return '$current/$total';
  }

  @override
  String get profileTitle => 'Perfil';

  @override
  String get user => 'Usuario';

  @override
  String get freePlan => 'Plan Gratuito';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get streakLabel => 'RACHA';

  @override
  String get daysUnitUpper => 'DÍAS';

  @override
  String get dietsLabel => 'DIETAS';

  @override
  String get createdLabel => 'CREADAS';

  @override
  String get aiNutriAI => 'IA NutriAI';

  @override
  String get aiDescription =>
      'Genera dietas personalizadas con inteligencia artificial basadas en tus preferencias.';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get settingsAndData => 'AJUSTES Y DATOS';

  @override
  String get personalData => 'Datos Personales';

  @override
  String get personalDataSub => 'Altura, peso y edad';

  @override
  String get foodPreferences => 'Preferencias Alimentarias';

  @override
  String get foodPreferencesSub => 'Alergias y favoritos';

  @override
  String get nutritionalGoals => 'Objetivos Nutricionales';

  @override
  String get nutritionalGoalsSub => 'Macros y calorías';

  @override
  String get sync => 'Sincronización';

  @override
  String get syncSub => 'Estado de la nube';

  @override
  String get logOut => 'Cerrar Sesión';
}
