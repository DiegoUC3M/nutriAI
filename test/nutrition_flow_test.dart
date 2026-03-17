import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/screens/nutrition/nutrition_flow_screen.dart';
import 'package:gym_app/utils/meal_planner.dart';

void main() {
  testWidgets('Full nutrition flow generates diet', (tester) async {
    // Suppress overflow errors from small test viewport
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    List<DietDay>? capturedDiet;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 800,
            child: NutritionFlowScreen(
              onDietChanged: (diet) => capturedDiet = diet,
            ),
          ),
        ),
      ),
    );

    // Step 0: Food Preferences
    expect(find.text('¿Qué te gusta comer?'), findsOneWidget);

    // Advance to Step 1: Macros
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Configura tus macros'), findsOneWidget);

    // Advance to Step 2: Days
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // Advance to Step 3: Plan Config
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Configura tu plan'), findsOneWidget);

    // Generate Diet (step 3 → step 4)
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
    expect(find.text('Lista de compra'), findsOneWidget);

    print('SUCCESS: Diet generated with ${capturedDiet!.length} days');
    for (final day in capturedDiet!) {
      print('  Day ${day.dayNumber}: ${day.totalCalories} kcal, ${day.meals.length} meals');
    }
  });
}
