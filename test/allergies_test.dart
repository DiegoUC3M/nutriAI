import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/l10n/app_localizations.dart';
import 'package:gym_app/screens/nutrition/steps/step_allergies.dart';

void main() {
  testWidgets('Collapsing fish details keeps the allergy and exceptions', (
    tester,
  ) async {
    final allergies = <String>{};
    final exceptions = <String>{};
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StepAllergies(
            allergies: allergies,
            allergyExceptions: exceptions,
            onAllergiesChanged: (_) {},
            onAllergyExceptionsChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pescado'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Salmón'));
    await tester.tap(find.text('Salmón'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byIcon(Icons.expand_less));
    await tester.tap(find.byIcon(Icons.expand_less));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.expand_more), findsOneWidget);
    expect(find.text('Salmón'), findsNothing);
    expect(allergies, {'Pescado'});
    expect(exceptions, {'Salmón'});
  });
}
