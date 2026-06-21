import 'package:flutter/material.dart';

// Importerer Umrah-siden slik at vi kan navigere dit
import 'screens/umrah_screen.dart';

// Startpunktet for hele appen
void main() {
  runApp(const DaleelApp());
}

// Hovedappen
class DaleelApp extends StatelessWidget {
  const DaleelApp({super.key});

  @override
  Widget build(BuildContext context) {

    // MaterialApp er "containeren" rundt hele appen
    return MaterialApp(
      title: 'Daleel',

      // Fjerner debug-banneret oppe til høyre
      debugShowCheckedModeBanner: false,

      // Første skjerm som åpnes
      home: const HomeScreen(),
    );
  }
}

// Forsiden
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Farger vi skal bruke flere steder
  final Color darkGreen = const Color(0xFF062E22);
  final Color gold = const Color(0xFFE9C46A);

  @override
  Widget build(BuildContext context) {

    // Scaffold er en vanlig app-side
    return Scaffold(
      backgroundColor: darkGreen,

      // Hindrer at innhold havner under notch eller statuslinje
      body: SafeArea(

        // Gir luft rundt innholdet
        child: Padding(
          padding: const EdgeInsets.all(24),

          // Legger widgets under hverandre
          child: Column(
            children: [

              // Tom plass øverst
              const SizedBox(height: 60),

              // Måneikon
              Icon(
                Icons.nightlight_round,
                color: gold,
                size: 70,
              ),

              const SizedBox(height: 30),

              // App-navn
              const Text(
                'DALEEL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),

              const SizedBox(height: 10),

              // Arabisk tekst
              Text(
                'دليل الحج والعمرة',
                style: TextStyle(
                  color: gold,
                  fontSize: 22,
                ),
              ),

              const SizedBox(height: 50),

              // Undertittel
              const Text(
                'Your guide for Hajj and Umrah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Beskrivelse
              const Text(
                'Step-by-step rituals, duas, holy site maps and checklists.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              // Skyver knappen ned mot bunnen
              const Spacer(),

              // Gjør knappen klikkbar
              GestureDetector(
                onTap: () {

                  // Bytter til Umrah-skjermen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UmrahScreen(),
                    ),
                  );
                },

                child: MainButton(
                  title: 'Begin Your Journey',
                  backgroundColor: gold,
                  textColor: darkGreen,
                ),
              ),

              const SizedBox(height: 16),

              // Språkstøtte
              const Text(
                'Available in English & العربية',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}