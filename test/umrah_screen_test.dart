import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hajj_umrah_guide/screens/umrah_screen.dart';

void main() {
  setUp(() {
    // Nullstiller SharedPreferences før hver test.
    // Da påvirker ikke testene hverandre.
    SharedPreferences.setMockInitialValues({});
  });


  testWidgets(
    'UmrahScreen åpnes med standardinnstillinger',
        (WidgetTester tester) async {

      await tester.pumpWidget(
        const MaterialApp(
          home: UmrahScreen(),
        ),
      );

      // Venter på at _loadSettings() skal bli ferdig.
      await tester.pumpAndSettle();

      // Sjekker at skjermen faktisk er lastet.
      expect(
        find.text('Umrah Guide'),
        findsOneWidget,
      );

      final scaffold = tester.widget<Scaffold>(
        find.byType(Scaffold),
      );

      // Standard skal være light mode.
      expect(
        scaffold.backgroundColor,
        kBackground,
      );
    },
  );


  testWidgets(
    'UmrahScreen laster dark mode fra SharedPreferences',
        (WidgetTester tester) async {

      // Simulerer at brukeren tidligere har valgt dark mode.
      SharedPreferences.setMockInitialValues({
        'umrah_dark_mode': true,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: UmrahScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(
        find.byType(Scaffold),
      );

      // Skjermen skal bruke mørk bakgrunn.
      expect(
        scaffold.backgroundColor,
        kDarkBackground,
      );
    },
  );


  testWidgets(
    'UmrahScreen laster lagret tekststørrelse',
        (WidgetTester tester) async {

      // Simulerer at brukeren tidligere har valgt 130 % tekst.
      SharedPreferences.setMockInitialValues({
        'umrah_text_scale': 1.3,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: UmrahScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Åpner innstillinger.
      await tester.tap(
        find.byIcon(Icons.settings_outlined),
      );

      await tester.pumpAndSettle();

      // Hvis verdien ble lastet riktig,
      // skal settings-panelet vise 130 %.
      expect(
        find.text('130%'),
        findsOneWidget,
      );
    },
  );


  testWidgets(
    'brukeren kan bytte til dark mode og verdien lagres',
        (WidgetTester tester) async {

      await tester.pumpWidget(
        const MaterialApp(
          home: UmrahScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Åpner settings-panelet.
      await tester.tap(
        find.byIcon(Icons.settings_outlined),
      );

      await tester.pumpAndSettle();

      // Trykker på Dark-knappen.
      await tester.tap(
        find.text('Dark'),
      );

      await tester.pumpAndSettle();

      // Leser SharedPreferences etter trykket.
      final prefs = await SharedPreferences.getInstance();

      // Verdien skal nå være lagret som true.
      expect(
        prefs.getBool('umrah_dark_mode'),
        true,
      );
    },
  );


  testWidgets(
    'brukeren kan øke tekststørrelsen og verdien lagres',
        (WidgetTester tester) async {

      await tester.pumpWidget(
        const MaterialApp(
          home: UmrahScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Åpner settings.
      await tester.tap(
        find.byIcon(Icons.settings_outlined),
      );

      await tester.pumpAndSettle();

      // Standard skal være 100 %.
      expect(
        find.text('100%'),
        findsOneWidget,
      );

      // Trykker på pluss én gang.
      await tester.tap(
        find.byIcon(Icons.add),
      );

      await tester.pumpAndSettle();

      // UI skal nå vise 110 %.
      expect(
        find.text('110%'),
        findsOneWidget,
      );

      // Sjekker at SharedPreferences også ble oppdatert.
      final prefs = await SharedPreferences.getInstance();

      expect(
        prefs.getDouble('umrah_text_scale'),
        closeTo(1.1, 0.001),
      );
    },
  );
}