import 'package:flutter/material.dart';

// Farger som brukes gjennom Umrah-guiden.
// Disse kan senere flyttes til et felles theme for hele appen.
const Color kDarkGreen = Color(0xFF062E22);
const Color kGold = Color(0xFFE9C46A);
const Color kBackground = Color(0xFFF8F6F1);


// StatefulWidget brukes fordi progresjonen i guiden
// skal kunne endres når brukeren fullfører ritualene.
class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}


class _UmrahScreenState extends State<UmrahScreen> {

  // Holder styr på hvor mange av de fire hovedstegene
  // i Umrah som brukeren har fullført.
  int _completedSteps = 0;

  @override
  Widget build(BuildContext context) {

    // LinearProgressIndicator forventer en verdi mellom 0.0 og 1.0.
    // Derfor deler vi antall fullførte steg på totalt antall steg.
    //
    // Eksempel:
    // 0 / 4 = 0.00 → 0 %
    // 1 / 4 = 0.25 → 25 %
    // 2 / 4 = 0.50 → 50 %
    final double progress = _completedSteps / 4;

    return Scaffold(
      backgroundColor: kBackground,

      body: Column(
        children: [

          // ─────────────────────────────────────
          // HEADER
          // ─────────────────────────────────────
          //
          // Headeren inneholder:
          // - tilbakeknapp
          // - navn på guiden
          // - antall fullførte steg
          // - visuell progress bar
          Container(
            width: double.infinity,
            color: kDarkGreen,

            // SafeArea hindrer innholdet i å havne bak
            // statuslinjen/notch på telefonen.
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 20, 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Tittelrad med tilbakeknapp.
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Går tilbake til forrige skjerm,
                            // som normalt vil være HomeScreen.
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 8),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Umrah Guide',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 2),

                            Text(
                              'Step-by-step pilgrimage ritual',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Viser progresjonen både som antall steg
                    // og som prosent.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_completedSteps of 4 steps complete',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        // progress er mellom 0 og 1.
                        // Vi ganger med 100 for å vise prosent.
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: kGold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Selve progressbaren.
                    // ClipRRect brukes for å gi den avrundede hjørner.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          kGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─────────────────────────────────────
          // GUIDE CONTENT
          // ─────────────────────────────────────
          //
          // Midlertidig placeholder.
          // I neste steg erstatter vi denne med
          // de fire ritualkortene.
          const Expanded(
            child: Center(
              child: Text(
                'Umrah steps coming next...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}