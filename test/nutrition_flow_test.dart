import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/l10n/app_localizations.dart';
import 'package:gym_app/screens/nutrition/nutrition_flow_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Full nutrition flow generates diet', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    List<DietDay>? capturedDiet;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NutritionFlowScreen(
            onDietChanged: (diet) => capturedDiet = diet,
          ),
        ),
      ),
    );

    // Step 0: Allergies
    expect(find.text('¿Tienes alergias?'), findsOneWidget);

    // Advance to Step 1: Favorites
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué te gusta comer?'), findsOneWidget);

    // Advance to Step 2: Disliked
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué no te gusta?'), findsOneWidget);

    // Advance to Step 3: Macros
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Configura tus macros'), findsOneWidget);

    // Advance to Step 4: Days
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // Advance to Step 5: Plan Config
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Configura tu plan'), findsOneWidget);

    // Generate Diet (step 5 → step 6)
    expect(find.text('Generar Dieta'), findsOneWidget);
    await tester.tap(find.text('Generar Dieta'));
    await tester.pump(); // process setState

    // StepDietResult is now DIRECTLY rendered (not in PageView)
    // Should show loading state immediately
    expect(find.text('Generando tu dieta con IA...'), findsOneWidget);

    // Wait for Future.delayed(500ms) to fire and generation to complete
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Diet should be generated and callback called
    expect(capturedDiet, isNotNull, reason: 'Diet should have been generated');
    expect(capturedDiet!.length, 7);

    // StepDietResult should show the diet
    expect(find.text('Día 1'), findsOneWidget);
    expect(find.text('Regenerar'), findsOneWidget);
    expect(find.text('Compra'), findsOneWidget);
  });

  testWidgets('Regenerating after reload keeps the saved plan settings', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    List<DietDay>? diet;
    final app = MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NutritionFlowScreen(onDietChanged: (value) => diet = value),
    );
    await tester.pumpWidget(app);
    await tester.tap(find.text('Pescado'));
    await tester.pumpAndSettle();

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }
    tester.widget<Slider>(find.byType(Slider)).onChanged!(2);
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generar Dieta'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(diet, hasLength(2));

    await tester.pumpWidget(const SizedBox.shrink());
    diet = null;
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(diet, hasLength(2));

    await tester.tap(find.text('Regenerar'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(diet, hasLength(2));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('saved_diet'), contains('"allergies":["Pescado"]'));
  });
}
