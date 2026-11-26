import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/l10n/app_localizations.dart';
import 'package:gym_app/screens/nutrition/nutrition_flow_screen.dart';
import 'package:gym_app/screens/nutrition/steps/step_shopping_list.dart';

void main() {
  testWidgets('Shopping list converts egg weight to whole eggs', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StepShoppingList(
            dietDays: [
              DietDay(
                dayNumber: 1,
                meals: [
                  Meal(
                    name: 'Desayuno',
                    items: [MealItem('Huevos (250g)', 0, 0, 0, 0, grams: 250)],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Huevos'), findsOneWidget);
    expect(find.text('5 unidades'), findsOneWidget);
  });
}
