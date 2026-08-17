import 'package:flutter/material.dart';

// Farger som brukes gjennom Umrah-guiden.
// Disse kan senere flyttes til et felles theme for hele appen.
const Color kDarkGreen = Color(0xFF062E22);
const Color kGold = Color(0xFFE9C46A);
const Color kBackground = Color(0xFFF8F6F1);

const Color kDarkBackground = Color(0xFF101815);
const Color kDarkCard = Color(0xFF18231F);


// ═════════════════════════════════════════════════
// UMRAH SCREEN
//
// StatefulWidget brukes fordi:
// - progresjonen skal kunne endres
// - vi må huske hvilket ritualkort som er åpnet
// - theme og tekststørrelse kan endres
// ═════════════════════════════════════════════════
class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}


class _UmrahScreenState extends State<UmrahScreen> {

  // Antall fullførte hovedsteg.
  int _completedSteps = 0;

  // Styrer om guiden bruker dark mode.
  bool _isDarkMode = false;

  // 1.0 = 100 %
  // 0.8 = 80 %
  // 1.4 = 140 %
  double _textScale = 1.0;

  // Holder styr på hvilket kort som er åpnet.
  //
  // null = ingen
  // 0 = Ihram
  // 1 = Tawaf
  // 2 = Sa'i
  // 3 = Hair Cutting
  int? _expandedStep;


  // ═══════════════════════════════════════════════
  // SETTINGS
  // ═══════════════════════════════════════════════
  void _openSettings() {
    showModalBottomSheet(
      context: context,

      // Gjør at bottom sheet kan bruke mer av skjermen
      // dersom innholdet trenger det.
      isScrollControlled: true,

      // Vi gjør selve modalbakgrunnen transparent.
      // Da kan Container-en inni styre light/dark dynamisk.
      backgroundColor: Colors.transparent,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final Color sheetColor =
            _isDarkMode ? kDarkCard : Colors.white;

            final Color primaryTextColor =
            _isDarkMode ? Colors.white : Colors.black87;

            final Color secondaryTextColor =
            _isDarkMode ? Colors.white60 : Colors.black54;

            return SafeArea(
              top: false,

              child: Container(
                // Hindrer at panelet blir høyere enn skjermen.
                constraints: BoxConstraints(
                  maxHeight:
                  MediaQuery.of(context).size.height * 0.80,
                ),

                decoration: BoxDecoration(
                  color: sheetColor,

                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),

                // Hvis skjermen er liten eller teksten blir stor,
                // kan settings-panelet scrolles i stedet for å overflowe.
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    14,
                    24,
                    30,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      // ─────────────────────────────
                      // HÅNDTAK
                      // ─────────────────────────────
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,

                          decoration: BoxDecoration(
                            color: _isDarkMode
                                ? Colors.white24
                                : Colors.black12,

                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),


                      // ─────────────────────────────
                      // TITTEL
                      // ─────────────────────────────
                      Text(
                        'Guide settings',

                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 28),


                      // ─────────────────────────────
                      // APPEARANCE
                      // ─────────────────────────────
                      Text(
                        'Appearance',

                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [

                          // LIGHT MODE
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Oppdater siden bak modalvinduet.
                                setState(() {
                                  _isDarkMode = false;
                                });

                                // Oppdater selve modalvinduet.
                                setModalState(() {});
                              },

                              icon: const Icon(
                                Icons.light_mode_outlined,
                              ),

                              label: const Text('Light'),

                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                !_isDarkMode
                                    ? kDarkGreen
                                    : secondaryTextColor,

                                backgroundColor:
                                !_isDarkMode
                                    ? kGold.withOpacity(0.15)
                                    : Colors.transparent,

                                side: BorderSide(
                                  color:
                                  !_isDarkMode
                                      ? kGold
                                      : Colors.white24,
                                ),

                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),


                          // DARK MODE
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isDarkMode = true;
                                });

                                setModalState(() {});
                              },

                              icon: const Icon(
                                Icons.dark_mode_outlined,
                              ),

                              label: const Text('Dark'),

                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                _isDarkMode
                                    ? kGold
                                    : secondaryTextColor,

                                backgroundColor:
                                _isDarkMode
                                    ? kGold.withOpacity(0.12)
                                    : Colors.transparent,

                                side: BorderSide(
                                  color:
                                  _isDarkMode
                                      ? kGold
                                      : Colors.black12,
                                ),

                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),


                      // ─────────────────────────────
                      // TEXT SIZE
                      // ─────────────────────────────
                      Text(
                        'Text size',

                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Adjust the guide text for easier reading.',

                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color:
                          _isDarkMode
                              ? Colors.white.withOpacity(0.06)
                              : const Color(0xFFF5F0EB),

                          borderRadius:
                          BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [

                            // REDUSER TEKST
                            IconButton(
                              onPressed:
                              _textScale > 0.8
                                  ? () {
                                setState(() {
                                  _textScale =
                                      (_textScale - 0.1)
                                          .clamp(
                                        0.8,
                                        1.4,
                                      )
                                          .toDouble();
                                });

                                setModalState(() {});
                              }
                                  : null,

                              icon: const Icon(
                                Icons.remove,
                              ),

                              color: primaryTextColor,
                            ),


                            // GJELDENDE STØRRELSE
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${(_textScale * 100).round()}%',

                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),


                            // ØK TEKST
                            IconButton(
                              onPressed:
                              _textScale < 1.4
                                  ? () {
                                setState(() {
                                  _textScale =
                                      (_textScale + 0.1)
                                          .clamp(
                                        0.8,
                                        1.4,
                                      )
                                          .toDouble();
                                });

                                setModalState(() {});
                              }
                                  : null,

                              icon: const Icon(
                                Icons.add,
                              ),

                              color: primaryTextColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: Text(
                          'Minimum 80% · Maximum 140%',

                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {

    // LinearProgressIndicator forventer en verdi
    // mellom 0.0 og 1.0.
    final double progress = _completedSteps / 4;

    final Color pageBackground =
    _isDarkMode
        ? kDarkBackground
        : kBackground;

    return Scaffold(
      backgroundColor: pageBackground,

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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    // Tilbakeknapp + tittel + settings.
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

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [
                              Text(
                                'Umrah Guide',

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight:
                                  FontWeight.bold,
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
                        ),

                        // Åpner innstillingene.
                        IconButton(
                          onPressed: _openSettings,

                          tooltip: 'Guide settings',

                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),


                    // ─────────────────────────────
                    // PROGRESS
                    // ─────────────────────────────

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

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
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(20),

                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,

                        backgroundColor:
                        Colors.white24,

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
                  subtitle:
                  'Enter the sacred state for Umrah',

                  isExpanded:
                  _expandedStep == 0,

                  isDarkMode:
                  _isDarkMode,

                  textScale:
                  _textScale,

                  onTap: () {
                    setState(() {
                      _expandedStep =
                      _expandedStep == 0
                          ? null
                          : 0;
                    });
                  },
                ),

                const SizedBox(height: 14),


                // STEG 2
                _UmrahStepCard(
                  number: 2,
                  title: 'Tawaf',
                  arabicTitle: 'الطواف',
                  subtitle:
                  'Circumambulate the Kaaba seven times',

                  isExpanded:
                  _expandedStep == 1,

                  isDarkMode:
                  _isDarkMode,

                  textScale:
                  _textScale,

                  onTap: () {
                    setState(() {
                      _expandedStep =
                      _expandedStep == 1
                          ? null
                          : 1;
                    });
                  },
                ),

                const SizedBox(height: 14),


                // STEG 3
                _UmrahStepCard(
                  number: 3,
                  title: "Sa'i",
                  arabicTitle: 'السعي',
                  subtitle:
                  'Walk between Safa and Marwa',

                  isExpanded:
                  _expandedStep == 2,

                  isDarkMode:
                  _isDarkMode,

                  textScale:
                  _textScale,

                  onTap: () {
                    setState(() {
                      _expandedStep =
                      _expandedStep == 2
                          ? null
                          : 2;
                    });
                  },
                ),

                const SizedBox(height: 14),


                // STEG 4
                _UmrahStepCard(
                  number: 4,
                  title: 'Hair Cutting',
                  arabicTitle:
                  'الحلق أو التقصير',
                  subtitle:
                  'Trim or shave the hair to complete Umrah',

                  isExpanded:
                  _expandedStep == 3,

                  isDarkMode:
                  _isDarkMode,

                  textScale:
                  _textScale,

                  onTap: () {
                    setState(() {
                      _expandedStep =
                      _expandedStep == 3
                          ? null
                          : 3;
                    });
                  },
                ),

                const SizedBox(height: 20),
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
// StatelessWidget fordi state fortsatt ligger
// i forelderen UmrahScreen.
// ═════════════════════════════════════════════════

class _UmrahStepCard extends StatelessWidget {

  final int number;
  final String title;
  final String arabicTitle;
  final String subtitle;

  final bool isExpanded;
  final bool isDarkMode;

  final double textScale;

  final VoidCallback onTap;


  const _UmrahStepCard({
    required this.number,
    required this.title,
    required this.arabicTitle,
    required this.subtitle,
    required this.isExpanded,
    required this.isDarkMode,
    required this.textScale,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {

    final Color cardColor =
    isDarkMode
        ? kDarkCard
        : Colors.white;

    final Color titleColor =
    isDarkMode
        ? Colors.white
        : Colors.black87;

    final Color secondaryColor =
    isDarkMode
        ? Colors.white70
        : Colors.black54;

    final Color borderColor =
    isDarkMode
        ? Colors.white12
        : const Color(0xFFE5E0D8);


    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(18),

        child: Container(
          padding:
          const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: cardColor,

            borderRadius:
            BorderRadius.circular(18),

            border: Border.all(
              color: borderColor,
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ───────────────────────────────
              // TOPPEN AV KORTET
              // ───────────────────────────────

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // Stegnummer
                  Container(
                    width: 42,
                    height: 42,

                    decoration:
                    const BoxDecoration(
                      color: kDarkGreen,
                      shape: BoxShape.circle,
                    ),

                    alignment:
                    Alignment.center,

                    child: Text(
                      '$number',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                        16 * textScale,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Tekstinnhold
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          title,

                          style: TextStyle(
                            color: titleColor,
                            fontSize:
                            20 * textScale,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          arabicTitle,

                          style: TextStyle(
                            color: kGold,
                            fontSize:
                            16 * textScale,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          subtitle,

                          style: TextStyle(
                            color:
                            secondaryColor,
                            fontSize:
                            14 * textScale,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Endrer retning når kortet åpnes.
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,

                    color: isDarkMode
                        ? Colors.white54
                        : Colors.black45,
                  ),
                ],
              ),


              // ───────────────────────────────
              // EXPANDED CONTENT
              // ───────────────────────────────

              if (isExpanded) ...[
                const SizedBox(height: 18),

                Divider(
                  color: isDarkMode
                      ? Colors.white12
                      : Colors.black12,
                ),

                const SizedBox(height: 12),

                Text(
                  'Instructions',

                  style: TextStyle(
                    color: titleColor,
                    fontSize:
                    16 * textScale,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'More information about $title will be shown here.',

                  style: TextStyle(
                    color: secondaryColor,
                    fontSize:
                    14 * textScale,
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