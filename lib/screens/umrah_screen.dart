import 'package:flutter/material.dart';

// Farger som brukes gjennom Umrah-guiden.
// Disse kan senere flyttes til et felles theme for hele appen.
const Color kDarkGreen = Color(0xFF062E22);
const Color kGold = Color(0xFFE9C46A);
const Color kBackground = Color(0xFFF8F6F1);


// ═════════════════════════════════════════════════
// UMRAH SCREEN
//
// StatefulWidget brukes fordi progresjonen i guiden
// skal kunne endres når brukeren fullfører ritualene.
// ═════════════════════════════════════════════════
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
          // Expanded bruker resten av høyden på skjermen.
          // ListView gjør at brukeren kan scrolle dersom
          // innholdet blir høyere enn skjermen.
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [

                // ─────────────────────────────
                // STEG 1 – IHRAM
                // ─────────────────────────────
                _UmrahStepCard(
                  number: 1,
                  title: 'Ihram',
                  arabicTitle: 'الإحرام',
                  subtitle: 'Enter the sacred state for Umrah',
                ),

                SizedBox(height: 14),


                // ─────────────────────────────
                // STEG 2 – TAWAF
                // ─────────────────────────────
                _UmrahStepCard(
                  number: 2,
                  title: 'Tawaf',
                  arabicTitle: 'الطواف',
                  subtitle: 'Circumambulate the Kaaba seven times',
                ),

                SizedBox(height: 14),


                // ─────────────────────────────
                // STEG 3 – SA'I
                // ─────────────────────────────
                _UmrahStepCard(
                  number: 3,
                  title: "Sa'i",
                  arabicTitle: 'السعي',
                  subtitle: 'Walk between Safa and Marwa',
                ),

                SizedBox(height: 14),


                // ─────────────────────────────
                // STEG 4 – HAIR CUTTING
                // ─────────────────────────────
                _UmrahStepCard(
                  number: 4,
                  title: 'Hair Cutting',
                  arabicTitle: 'الحلق أو التقصير',
                  subtitle: 'Trim or shave the hair to complete Umrah',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// UMRAH STEP CARD
//
// Gjenbrukbar widget for ett hovedsteg i Umrah.
//
// I stedet for å skrive samme UI fire ganger,
// sender vi inn:
// - stegnummer
// - engelsk tittel
// - arabisk tittel
// - kort beskrivelse
//
// Senere gjør vi kortet expandable og legger til
// status som "Current" og "Completed".
// ═════════════════════════════════════════════════
class _UmrahStepCard extends StatelessWidget {

  final int number;
  final String title;
  final String arabicTitle;
  final String subtitle;

  const _UmrahStepCard({
    required this.number,
    required this.title,
    required this.arabicTitle,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        // Lett kant rundt kortet for å skille
        // det fra bakgrunnen.
        border: Border.all(
          color: const Color(0xFFE5E0D8),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ─────────────────────────────────────
          // STEGNUMMER
          // ─────────────────────────────────────
          //
          // Sirkel som viser nummeret på steget.
          Container(
            width: 42,
            height: 42,

            decoration: const BoxDecoration(
              color: kDarkGreen,
              shape: BoxShape.circle,
            ),

            alignment: Alignment.center,

            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),


          // ─────────────────────────────────────
          // TEKST
          // ─────────────────────────────────────
          //
          // Expanded gjør at teksten bruker resten
          // av tilgjengelig bredde i kortet.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Engelsk navn på ritualet.
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Arabisk navn på ritualet.
                Text(
                  arabicTitle,
                  style: const TextStyle(
                    color: kGold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                // Kort forklaring på hva steget innebærer.
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),


          // ─────────────────────────────────────
          // EXPAND-IKON
          // ─────────────────────────────────────
          //
          // Foreløpig er dette bare et visuelt hint.
          // I neste commit gjør vi kortet klikkbart,
          // slik at det kan åpnes og lukkes.
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}