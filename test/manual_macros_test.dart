import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/l10n/app_localizations.dart';
import 'package:gym_app/screens/nutrition/nutrition_flow_screen.dart';
import 'package:gym_app/screens/nutrition/steps/step_macros_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Switching to manual clamps the stored automatic macros', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NutritionFlowScreen(),
      ),
    );
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }

    final macros = find.byType(StepMacrosConfig);
    await tester.enterText(find.byType(TextFormField).at(1), '220');
    await tester.pumpAndSettle();
    expect(tester.widget<StepMacrosConfig>(macros).protein, greaterThan(350));

    await tester.tap(find.text('Manual'));
    await tester.pumpAndSettle();
    expect(tester.widget<StepMacrosConfig>(macros).protein, 350);
    expect(tester.takeException(), isNull);
  });
}
