import 'package:flutter/material.dart';

// Farger som brukes gjennom Umrah-guiden.
// Disse kan senere flyttes til et felles theme for hele appen.
const Color kDarkGreen = Color(0xFF062E22);
const Color kGold = Color(0xFFE9C46A);
const Color kBackground = Color(0xFFF8F6F1);


// ═════════════════════════════════════════════════
// UMRAH SCREEN
//
// StatefulWidget brukes fordi:
// - progresjonen skal kunne endres
// - vi må huske hvilket ritualkort som er åpnet
// ═════════════════════════════════════════════════
class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}


class _UmrahScreenState extends State<UmrahScreen> {

  // Antall fullførte hovedsteg.
  // Vi bruker denne senere når vi implementerer
  // faktisk fullføring av ritualene.
  int _completedSteps = 0;

  // Holder styr på hvilket kort som er åpnet.
  //
  // null = ingen kort åpnet
  // 0 = Ihram
  // 1 = Tawaf
  // 2 = Sa'i
  // 3 = Hair Cutting
  int? _expandedStep;

  @override
  Widget build(BuildContext context) {

    // LinearProgressIndicator forventer verdi mellom 0.0 og 1.0.
    final double progress = _completedSteps / 4;

    return Scaffold(
      backgroundColor: kBackground,

      body: Column(
        children: [

          // ─────────────────────────────────────
          // HEADER
          // ─────────────────────────────────────
          Container(
            width: double.infinity,
            color: kDarkGreen,

            child: SafeArea(
              bottom: false,

              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  20,
                  24,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // Tittel og tilbakeknapp
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
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

                    // Tekstlig progresjon
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

                    // Visuell progressbar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white24,

                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
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
          // RITUALKORT
          // ─────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),

              children: [

                // STEG 1
                _UmrahStepCard(
                  number: 1,
                  title: 'Ihram',
                  arabicTitle: 'الإحرام',
                  subtitle: 'Enter the sacred state for Umrah',

                  // Kortet er åpent hvis _expandedStep == 0
                  isExpanded: _expandedStep == 0,

                  // Når brukeren trykker på kortet
                  onTap: () {
                    setState(() {

                      // Hvis samme kort allerede er åpent,
                      // lukk det. Ellers åpne det.
                      _expandedStep =
                      _expandedStep == 0 ? null : 0;
                    });
                  },
                ),

                const SizedBox(height: 14),


                // STEG 2
                _UmrahStepCard(
                  number: 2,
                  title: 'Tawaf',
                  arabicTitle: 'الطواف',
                  subtitle: 'Circumambulate the Kaaba seven times',
                  isExpanded: _expandedStep == 1,

                  onTap: () {
                    setState(() {
                      _expandedStep =
                      _expandedStep == 1 ? null : 1;
                    });
                  },
                ),

                const SizedBox(height: 14),


                // STEG 3
                _UmrahStepCard(
                  number: 3,
                  title: "Sa'i",
                  arabicTitle: 'السعي',
                  subtitle: 'Walk between Safa and Marwa',
                  isExpanded: _expandedStep == 2,

                  onTap: () {
                    setState(() {
                      _expandedStep =
                      _expandedStep == 2 ? null : 2;
                    });
                  },
                ),

                const SizedBox(height: 14),


                // STEG 4
                _UmrahStepCard(
                  number: 4,
                  title: 'Hair Cutting',
                  arabicTitle: 'الحلق أو التقصير',
                  subtitle: 'Trim or shave the hair to complete Umrah',
                  isExpanded: _expandedStep == 3,

                  onTap: () {
                    setState(() {
                      _expandedStep =
                      _expandedStep == 3 ? null : 3;
                    });
                  },
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
// Dette er fortsatt en StatelessWidget.
// State ligger i forelderen UmrahScreen.
//
// Kortet mottar:
// - informasjon om ritualet
// - om det er åpnet eller lukket
// - en funksjon som kjøres når brukeren trykker
// ═════════════════════════════════════════════════
class _UmrahStepCard extends StatelessWidget {

  final int number;
  final String title;
  final String arabicTitle;
  final String subtitle;

  // true = detaljene vises
  // false = bare sammendrag vises
  final bool isExpanded;

  // Funksjonen som kjøres når kortet trykkes.
  final VoidCallback onTap;

  const _UmrahStepCard({
    required this.number,
    required this.title,
    required this.arabicTitle,
    required this.subtitle,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: const Color(0xFFE5E0D8),
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // ─────────────────────────────────
              // ØVERSTE DEL AV KORTET
              // ─────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // Stegnummer
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

                  // Tittel, arabisk navn og kort forklaring
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          title,

                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          arabicTitle,

                          style: const TextStyle(
                            color: kGold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 10),

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

                  // Pilen endrer retning basert på om
                  // kortet er åpnet eller lukket.
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,

                    color: Colors.black45,
                  ),
                ],
              ),


              // ─────────────────────────────────
              // UTVIDET INNHOLD
              // ─────────────────────────────────
              //
              // Denne delen legges kun inn i widget-treet
              // når isExpanded == true.
              if (isExpanded) ...[
                const SizedBox(height: 18),

                const Divider(),

                const SizedBox(height: 12),

                const Text(
                  'Instructions',

                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Foreløpig placeholder.
                // I neste commit erstatter vi denne med
                // ekte instruksjoner for hvert ritual.
                Text(
                  'More information about $title will be shown here.',

                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}