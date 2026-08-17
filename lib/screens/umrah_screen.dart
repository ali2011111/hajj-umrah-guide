import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────
// FARGER
// ─────────────────────────────────────────────────
//
// Foreløpig ligger fargene her i filen.
// Senere kan vi flytte dem til et eget theme for hele appen.

const Color kDarkGreen = Color(0xFF062E22);
const Color kGold = Color(0xFFE9C46A);

const Color kBackground = Color(0xFFF8F6F1);
const Color kDarkBackground = Color(0xFF101815);
const Color kDarkCard = Color(0xFF18231F);


// ═════════════════════════════════════════════════
// UMRAH SCREEN
// ═════════════════════════════════════════════════

class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}


class _UmrahScreenState extends State<UmrahScreen> {

  // Set brukes fordi vi vil vite nøyaktig hvilke steg
  // som er fullført, ikke bare hvor mange.
  //
  // 0 = Ihram
  // 1 = Tawaf
  // 2 = Sa'i
  // 3 = Hair Cutting
  final Set<int> _completedSteps = {};

  // Første kort er åpent når siden åpnes.
  int? _expandedStep = 0;

  // Innstillinger for denne guiden.
  bool _isDarkMode = false;

  // 1.0 = 100 %
  double _textScale = 1.0;

  // Tawaf har 7 runder.
  int _tawafRounds = 0;

  // Sa'i har også 7 strekninger.
  int _saiLaps = 0;


  // ═══════════════════════════════════════════════
  // SETTINGS
  // ═══════════════════════════════════════════════

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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

                      // Lite håndtak på toppen.
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

                      Text(
                        'Guide settings',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ───────────────────────────
                      // APPEARANCE
                      // ───────────────────────────

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
                                setState(() {
                                  _isDarkMode = false;
                                });

                                // Bottom sheet må også bygges på nytt.
                                setModalState(() {});
                              },

                              icon: const Icon(
                                Icons.light_mode_outlined,
                              ),

                              label: const Text('Light'),

                              style: OutlinedButton.styleFrom(
                                foregroundColor: !_isDarkMode
                                    ? kDarkGreen
                                    : secondaryTextColor,

                                backgroundColor: !_isDarkMode
                                    ? kGold.withOpacity(0.15)
                                    : Colors.transparent,

                                side: BorderSide(
                                  color: !_isDarkMode
                                      ? kGold
                                      : Colors.white24,
                                ),

                                padding: const EdgeInsets.symmetric(
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
                                foregroundColor: _isDarkMode
                                    ? kGold
                                    : secondaryTextColor,

                                backgroundColor: _isDarkMode
                                    ? kGold.withOpacity(0.12)
                                    : Colors.transparent,

                                side: BorderSide(
                                  color: _isDarkMode
                                      ? kGold
                                      : Colors.black12,
                                ),

                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ───────────────────────────
                      // TEXT SIZE
                      // ───────────────────────────

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
                          color: _isDarkMode
                              ? Colors.white.withOpacity(0.06)
                              : const Color(0xFFF5F0EB),

                          borderRadius:
                          BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [

                            // Mindre tekst.
                            IconButton(
                              onPressed: _textScale > 0.8
                                  ? () {
                                setState(() {
                                  _textScale =
                                      (_textScale - 0.1)
                                          .clamp(0.8, 1.4)
                                          .toDouble();
                                });

                                setModalState(() {});
                              }
                                  : null,

                              icon: const Icon(
                                Icons.remove,
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Text(
                                  '${(_textScale * 100).round()}%',
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Større tekst.
                            IconButton(
                              onPressed: _textScale < 1.4
                                  ? () {
                                setState(() {
                                  _textScale =
                                      (_textScale + 0.1)
                                          .clamp(0.8, 1.4)
                                          .toDouble();
                                });

                                setModalState(() {});
                              }
                                  : null,

                              icon: const Icon(
                                Icons.add,
                              ),
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
  // STEP LOGIC
  // ═══════════════════════════════════════════════

  bool _canCompleteStep(int stepIndex) {

    // Ihram er det første steget.
    if (stepIndex == 0) {
      return true;
    }

    // Et steg kan bare fullføres hvis forrige steg er ferdig.
    return _completedSteps.contains(stepIndex - 1);
  }


  void _completeStep(int stepIndex) {

    if (!_canCompleteStep(stepIndex)) {
      return;
    }

    // Tawaf krever 7 / 7 før vi lar brukeren fullføre.
    if (stepIndex == 1 && _tawafRounds < 7) {
      return;
    }

    // Sa'i krever også 7 / 7.
    if (stepIndex == 2 && _saiLaps < 7) {
      return;
    }

    setState(() {
      _completedSteps.add(stepIndex);

      // Åpne neste kort automatisk.
      if (stepIndex < 3) {
        _expandedStep = stepIndex + 1;
      } else {
        _expandedStep = null;
      }
    });
  }


  // ═══════════════════════════════════════════════
  // TAWAF COUNTER
  // ═══════════════════════════════════════════════

  void _increaseTawafRound() {
    if (_tawafRounds >= 7) {
      return;
    }

    setState(() {
      _tawafRounds++;
    });
  }


  void _decreaseTawafRound() {
    if (_tawafRounds <= 0) {
      return;
    }

    setState(() {
      _tawafRounds--;
    });
  }


  Future<void> _resetTawafCounter() async {

    if (_tawafRounds == 0) {
      return;
    }

    final bool? shouldReset = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Reset Tawaf counter?',
          ),

          content: Text(
            'Your current progress is $_tawafRounds of 7 rounds.',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      setState(() {
        _tawafRounds = 0;
      });
    }
  }


  // ═══════════════════════════════════════════════
  // SA'I COUNTER
  // ═══════════════════════════════════════════════

  void _increaseSaiLap() {
    if (_saiLaps >= 7) {
      return;
    }

    setState(() {
      _saiLaps++;
    });
  }


  void _decreaseSaiLap() {
    if (_saiLaps <= 0) {
      return;
    }

    setState(() {
      _saiLaps--;
    });
  }


  Future<void> _resetSaiCounter() async {

    if (_saiLaps == 0) {
      return;
    }

    final bool? shouldReset = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Reset Sa'i counter?",
          ),

          content: Text(
            'Your current progress is $_saiLaps of 7 laps.',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      setState(() {
        _saiLaps = 0;
      });
    }
  }


  // Beregner hvilken retning brukeren skal gå i Sa'i.
  //
  // 0 → Safa til Marwah
  // 1 → Marwah til Safa
  // 2 → Safa til Marwah
  //
  // Ved 7 / 7 er brukeren ferdig ved Marwah.
  String get _saiDirection {

    if (_saiLaps == 7) {
      return 'Completed at Marwah';
    }

    if (_saiLaps.isEven) {
      return 'Safa → Marwah';
    }

    return 'Marwah → Safa';
  }


  // ═══════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {

    final double progress =
        _completedSteps.length / 4;

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

                    // Progresjonstekst.
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        Text(
                          '${_completedSteps.length} of 4 steps complete',

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
          // GUIDE CONTENT
          // ─────────────────────────────────────

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),

              children: [

                // ═══════════════════════════════
                // 1. IHRAM
                // ═══════════════════════════════

                _UmrahStepCard(
                  number: 1,
                  title: 'Ihram',
                  arabicTitle: 'الإحرام',
                  subtitle:
                  'Enter the sacred state for Umrah',

                  isExpanded:
                  _expandedStep == 0,

                  isCompleted:
                  _completedSteps.contains(0),

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

                  expandedContent:
                  _buildIhramContent(),
                ),

                const SizedBox(height: 14),


                // ═══════════════════════════════
                // 2. TAWAF
                // ═══════════════════════════════

                _UmrahStepCard(
                  number: 2,
                  title: 'Tawaf',
                  arabicTitle: 'الطواف',
                  subtitle:
                  'Circumambulate the Kaaba seven times',

                  isExpanded:
                  _expandedStep == 1,

                  isCompleted:
                  _completedSteps.contains(1),

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

                  expandedContent:
                  _buildTawafContent(),
                ),

                const SizedBox(height: 14),


                // ═══════════════════════════════
                // 3. SA'I
                // ═══════════════════════════════

                _UmrahStepCard(
                  number: 3,
                  title: "Sa'i",
                  arabicTitle: 'السعي',
                  subtitle:
                  'Walk between Safa and Marwah',

                  isExpanded:
                  _expandedStep == 2,

                  isCompleted:
                  _completedSteps.contains(2),

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

                  expandedContent:
                  _buildSaiContent(),
                ),

                const SizedBox(height: 14),


                // ═══════════════════════════════
                // 4. HAIR CUTTING
                // ═══════════════════════════════

                _UmrahStepCard(
                  number: 4,
                  title: 'Hair Cutting',
                  arabicTitle:
                  'الحلق أو التقصير',

                  subtitle:
                  'Trim or shave the hair to complete Umrah',

                  isExpanded:
                  _expandedStep == 3,

                  isCompleted:
                  _completedSteps.contains(3),

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

                  expandedContent:
                  _buildHairCuttingContent(),
                ),

                const SizedBox(height: 24),

                if (_completedSteps.length == 4)
                  _buildCompletionCard(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ═══════════════════════════════════════════════
  // 1. IHRAM CONTENT
  // ═══════════════════════════════════════════════

  Widget _buildIhramContent() {

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // Hva Ihram er.
        _sectionTitle(
          'What is Ihram?',
        ),

        const SizedBox(height: 10),

        _bodyText(
          'Ihram is the sacred state entered in order to perform Umrah.',
        ),

        const SizedBox(height: 22),


        // ───────────────────────────────────────
        // PREPARATION
        // ───────────────────────────────────────

        _sectionTitle(
          '1. Prepare before Ihram',
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,
          text: 'Clip the nails.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 2,
          text: 'Trim the moustache.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 3,
          text: 'Shave the pubic hair.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 4,
          text: 'Perform ghusl.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 5,
          text: 'Perform wudu.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 6,
          text:
          'Apply perfume to the body before putting on Ihram.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        const SizedBox(height: 10),

        _InfoBox(
          title: 'Note',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: _bodyText(
            'The guide says to pray two rak‘ahs after putting on Ihram and before making the Niyyah.',
          ),
        ),

        const SizedBox(height: 24),


        // ───────────────────────────────────────
        // CLOTHING
        // ───────────────────────────────────────

        _sectionTitle(
          '2. Ihram clothing',
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: 'Men',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                '• Ridaa’: upper towel',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '• Izaar: lower towel',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '• Ni’aal: slippers',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '• No hat or underwear',
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: 'Women',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                '• Khimar and jilbab in any colour',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '• No niqab or gloves',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '• Shoes and socks may be worn',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),


        // ───────────────────────────────────────
        // MIQAT
        // ───────────────────────────────────────

        _sectionTitle(
          '3. Miqat',
        ),

        const SizedBox(height: 12),

        _bodyText(
          'Miqat is the boundary from which Ihram must be entered for Umrah or Hajj.',
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: 'Five Mawaqeet listed in the guide',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                '1. Al-Juhfah – Syria / Jeddah',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '2. Dhul Hulayfah – Madinah',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '3. Dhatu Irq – Iraq',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '4. Qarn-al-Manazil – Najd',
              ),

              const SizedBox(height: 6),

              _bodyText(
                '5. Yalamlam – Yemen',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),


        // ───────────────────────────────────────
        // NIYYAH
        // ───────────────────────────────────────

        _sectionTitle(
          '4. Make the Niyyah',
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: 'Niyyah · Intention',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _arabicText(
                'لَبَّيْكَ اللَّهُمَّ بِعُمْرَةٍ',
              ),

              const SizedBox(height: 10),

              _centerText(
                'Labbayk Allahumma bi Umrah',
                bold: true,
              ),

              const SizedBox(height: 6),

              _centerText(
                'Here I am, O Allah, making Umrah.',
                italic: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),


        // ───────────────────────────────────────
        // TALBIYAH
        // ───────────────────────────────────────

        _sectionTitle(
          '5. Begin the Talbiyah',
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: 'Talbiyah',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _arabicText(
                'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، '
                    'لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، '
                    'إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ '
                    'وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
              ),

              const SizedBox(height: 12),

              _bodyText(
                'Labbayk Allahumma labbayk, '
                    'labbayka laa shareeka laka labbayk, '
                    'innal hamda wanne’ matah laka wal mulk, '
                    'laa shareeka lak.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),


        // ───────────────────────────────────────
        // PERMITTED
        // ───────────────────────────────────────

        _sectionTitle(
          '6. Permitted while in Ihram',
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: 'Permitted',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                '• Scent-free cleaning products',
              ),

              _bodyText(
                '• Bathing and changing Ihram',
              ),

              _bodyText(
                '• Women wearing shoes',
              ),

              _bodyText(
                '• Cupping, opening an abscess or pulling a tooth',
              ),

              _bodyText(
                '• Wearing a belt or ring',
              ),

              _bodyText(
                '• Wearing a watch',
              ),

              _bodyText(
                '• Non-perfumed kohl',
              ),

              _bodyText(
                '• Killing flies or harmful animals',
              ),

              _bodyText(
                '• Sitting under shade such as an umbrella, tree or tent',
              ),

              _bodyText(
                '• Using a blanket, while men do not cover the head',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),


        // ───────────────────────────────────────
        // PROHIBITED
        // ───────────────────────────────────────

        _sectionTitle(
          '7. Prohibited while in Ihram',
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: 'Prohibited',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                '• Sexual intercourse',
              ),

              _bodyText(
                '• Fighting or arguing',
              ),

              _bodyText(
                '• Wearing sewn clothes',
              ),

              _bodyText(
                '• Cutting the hair',
              ),

              _bodyText(
                '• Trimming the nails',
              ),

              _bodyText(
                '• Using perfumed soap',
              ),

              _bodyText(
                '• Wearing perfume',
              ),

              _bodyText(
                '• Men wearing hats',
              ),

              _bodyText(
                '• Getting engaged or married',
              ),

              _bodyText(
                '• Hunting',
              ),

              const SizedBox(height: 8),

              _bodyText(
                'The guide notes that some actions may require a penalty.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        _buildCompleteButton(
          stepIndex: 0,
          label: 'Mark Ihram as complete',
        ),
      ],
    );
  }


  // ═══════════════════════════════════════════════
  // 2. TAWAF CONTENT
  // ═══════════════════════════════════════════════

  Widget _buildTawafContent() {

    final bool tawafReady =
        _tawafRounds == 7;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // ───────────────────────────────────────
        // BEFORE TAWAF
        // ───────────────────────────────────────

        _sectionTitle(
          'Before Tawaf',
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,
          text:
          'Enter Masjid al-Haram and prepare for Tawaf.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 2,
          text:
          'Stop reciting the Talbiyah when beginning Tawaf.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 3,
          text:
          'For men, perform Idtibaa’ as described in the guide.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        const SizedBox(height: 22),


        // ───────────────────────────────────────
        // PERFORM TAWAF
        // ───────────────────────────────────────

        _sectionTitle(
          'Perform Tawaf',
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,
          text:
          'Begin at the Black Stone (Al-Hajr Al-Aswad).',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 2,
          text:
          'Raise the hand and say “Allahu Akbar”.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 3,
          text:
          'Move around the Kaaba in an anti-clockwise direction.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 4,
          text:
          'The guide says to hurry during the first three rounds (Raml).',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 5,
          text:
          'Walk normally during the final four rounds.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 6,
          text:
          'Make dua during Tawaf.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 7,
          text:
          'Break Tawaf for obligatory Salah if needed.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        const SizedBox(height: 16),


        // Dua mellom Yemeni corner og Black Stone.
        _InfoBox(
          title: 'Between the Yemeni Corner and Black Stone',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _centerText(
                'Rabbana aatina fidduniya hasanah wa fil aakhirati hasanah wa qina azaban nar',
                bold: true,
              ),

              const SizedBox(height: 8),

              _centerText(
                'O Allah, our Lord, give us good in this world, and good in the Hereafter, and save us from the punishment of fire.',
                italic: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),


        // ───────────────────────────────────────
        // TAWAF COUNTER
        // ───────────────────────────────────────

        _InfoBox(
          title: 'Tawaf counter',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            children: [

              const SizedBox(height: 4),

              Text(
                '$_tawafRounds / 7',

                style: TextStyle(
                  color: tawafReady
                      ? kGold
                      : _primaryTextColor,

                  fontSize:
                  38 * _textScale,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                tawafReady
                    ? 'All seven rounds completed'
                    : 'rounds completed',

                style: TextStyle(
                  color:
                  _secondaryTextColor,

                  fontSize:
                  13 * _textScale,
                ),
              ),

              const SizedBox(height: 18),

              _buildSevenDots(
                completed:
                _tawafRounds,
              ),

              const SizedBox(height: 22),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                      _tawafRounds > 0
                          ? _decreaseTawafRound
                          : null,

                      icon: const Icon(
                        Icons.remove,
                      ),

                      label:
                      const Text(
                        'Previous',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                      _tawafRounds < 7
                          ? _increaseTawafRound
                          : null,

                      icon: const Icon(
                        Icons.add,
                      ),

                      label: Text(
                        _tawafRounds == 6
                            ? 'Final round'
                            : 'Next round',
                      ),

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        kDarkGreen,

                        foregroundColor:
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextButton.icon(
                onPressed:
                _tawafRounds > 0
                    ? _resetTawafCounter
                    : null,

                icon: const Icon(
                  Icons.restart_alt,
                ),

                label: const Text(
                  'Reset counter',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 26),


        // ───────────────────────────────────────
        // MAQAM IBRAHIM
        // ───────────────────────────────────────

        _sectionTitle(
          'After Tawaf',
        ),

        const SizedBox(height: 12),

        _InfoBox(
          title: '1. Pray behind Maqam Ibrahim',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                '• Cover the shoulders.',
              ),

              _bodyText(
                '• Pray two rak‘ahs of nafl Salah.',
              ),

              _bodyText(
                '• The guide says the Prophet ﷺ prayed Surah Al-Kafirun in the first rak‘ah.',
              ),

              _bodyText(
                '• Surah Al-Ikhlas in the second rak‘ah.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),


        // ───────────────────────────────────────
        // ZAMZAM
        // ───────────────────────────────────────

        _InfoBox(
          title: '2. Drink Zamzam water',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                '• Face the Qibla.',
              ),

              _bodyText(
                '• The guide says it may be drunk standing or sitting.',
              ),

              const SizedBox(height: 14),

              _centerText(
                "Allah humma Innee as alooka 'ilman naafia wa rizqan waa se'a wa Shifa'a min kulli daa",
                bold: true,
              ),

              const SizedBox(height: 8),

              _centerText(
                'O Allah, I seek beneficial knowledge, wide sustenance and cure from all ailments from You.',
                italic: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _InfoBox(
          title: "3. Continue to Sa'i",
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: _bodyText(
            "After the acts following Tawaf, continue to Safa to begin Sa'i.",
          ),
        ),

        const SizedBox(height: 22),


        // Tawaf kan bare fullføres når 7 runder er ferdige.
        if (!_completedSteps.contains(1))
          SizedBox(
            width:
            double.infinity,

            child:
            ElevatedButton.icon(
              onPressed:
              _canCompleteStep(1) &&
                  _tawafRounds == 7
                  ? () {
                _completeStep(1);
              }
                  : null,

              icon:
              const Icon(
                Icons.check_circle_outline,
              ),

              label: Text(
                !_canCompleteStep(1)
                    ? 'Complete Ihram first'
                    : _tawafRounds < 7
                    ? 'Complete all 7 Tawaf rounds'
                    : "Complete Tawaf & continue to Sa'i",
              ),

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                kDarkGreen,

                foregroundColor:
                Colors.white,

                disabledBackgroundColor:
                Colors.grey.shade300,

                disabledForegroundColor:
                Colors.grey.shade600,

                padding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
          )

        else
          _completedLabel(
            'Tawaf completed',
          ),
      ],
    );
  }


  // ═══════════════════════════════════════════════
  // 3. SA'I CONTENT
  // ═══════════════════════════════════════════════

  Widget _buildSaiContent() {

    final bool saiReady =
        _saiLaps == 7;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _sectionTitle(
          "Begin Sa'i at Safa",
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,
          text:
          'Begin at Safa and face the Qibla.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 2,
          text:
          'From Safa, walk towards Marwah.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 3,
          text:
          'The guide says to hurry in the green zone.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 4,
          text:
          'Make dua during Sa’i.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 5,
          text:
          'Break for obligatory Salah if needed.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 6,
          text:
          'If wudu breaks, the guide says to continue.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 7,
          text:
          'Make dua at Marwah as at Safa.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        const SizedBox(height: 16),

        _InfoBox(
          title: 'At Safa',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                'The guide says to face the Qibla and say:',
              ),

              const SizedBox(height: 10),

              _centerText(
                'Verily! Safaa & Al Marwah are of the Symbols of Allah.',
                italic: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),


        // ───────────────────────────────────────
        // SA'I COUNTER
        // ───────────────────────────────────────

        _InfoBox(
          title: "Sa'i counter",
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            children: [

              Text(
                '$_saiLaps / 7',

                style: TextStyle(
                  color: saiReady
                      ? kGold
                      : _primaryTextColor,

                  fontSize:
                  38 * _textScale,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _saiDirection,

                style: TextStyle(
                  color:
                  saiReady
                      ? kGold
                      : _primaryTextColor,

                  fontSize:
                  17 * _textScale,

                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                saiReady
                    ? 'The seventh lap ends at Marwah.'
                    : 'Follow this direction for the next lap.',

                textAlign:
                TextAlign.center,

                style: TextStyle(
                  color:
                  _secondaryTextColor,

                  fontSize:
                  13 * _textScale,
                ),
              ),

              const SizedBox(height: 18),

              _buildSevenDots(
                completed:
                _saiLaps,
              ),

              const SizedBox(height: 22),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                      _saiLaps > 0
                          ? _decreaseSaiLap
                          : null,

                      icon: const Icon(
                        Icons.remove,
                      ),

                      label:
                      const Text(
                        'Previous',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                      _saiLaps < 7
                          ? _increaseSaiLap
                          : null,

                      icon: const Icon(
                        Icons.directions_walk,
                      ),

                      label: Text(
                        _saiLaps == 6
                            ? 'Final lap'
                            : 'Complete lap',
                      ),

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        kDarkGreen,

                        foregroundColor:
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextButton.icon(
                onPressed:
                _saiLaps > 0
                    ? _resetSaiCounter
                    : null,

                icon: const Icon(
                  Icons.restart_alt,
                ),

                label: const Text(
                  'Reset counter',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _InfoBox(
          title: 'How the laps work',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: _bodyText(
            'Safa → Marwah = 1\n'
                'Marwah → Safa = 2\n'
                'Continue until the seventh lap, which ends at Marwah.',
          ),
        ),

        const SizedBox(height: 22),


        // Sa'i må være 7 / 7 før knappen aktiveres.
        if (!_completedSteps.contains(2))
          SizedBox(
            width:
            double.infinity,

            child:
            ElevatedButton.icon(
              onPressed:
              _canCompleteStep(2) &&
                  _saiLaps == 7
                  ? () {
                _completeStep(2);
              }
                  : null,

              icon:
              const Icon(
                Icons.check_circle_outline,
              ),

              label: Text(
                !_canCompleteStep(2)
                    ? 'Complete Tawaf first'
                    : _saiLaps < 7
                    ? "Complete all 7 Sa'i laps"
                    : "Mark Sa'i as complete",
              ),

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                kDarkGreen,

                foregroundColor:
                Colors.white,

                disabledBackgroundColor:
                Colors.grey.shade300,

                disabledForegroundColor:
                Colors.grey.shade600,

                padding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
          )

        else
          _completedLabel(
            "Sa'i completed",
          ),
      ],
    );
  }


  // ═══════════════════════════════════════════════
  // 4. HAIR CUTTING
  // ═══════════════════════════════════════════════

  Widget _buildHairCuttingContent() {

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _sectionTitle(
          'Taqsir / Halaq',
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,
          text:
          "After completing Sa'i, go to get the hair cut.",
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 2,
          text:
          'Taqsir or Halaq means trimming or shaving the hair.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        _InstructionItem(
          number: 3,
          text:
          'The guide says women cut a small lock of hair.',
          textScale: _textScale,
          isDarkMode: _isDarkMode,
        ),

        const SizedBox(height: 16),

        _InfoBox(
          title: 'Leaving Ihram',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: _bodyText(
            'After completing the hair cutting, the guide states that Umrah is complete and the restrictions of Ihram end.',
          ),
        ),

        const SizedBox(height: 16),

        _InfoBox(
          title: 'Leaving the mosque',
          isDarkMode: _isDarkMode,
          textScale: _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                'The guide says to exit with the left foot and say:',
              ),

              const SizedBox(height: 10),

              _centerText(
                'Allahummu inni asaluka min fadlik',
                bold: true,
              ),

              const SizedBox(height: 6),

              _centerText(
                'O Allah, I ask You from Your favour.',
                italic: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        _buildCompleteButton(
          stepIndex: 3,
          label: 'Complete Umrah',
        ),
      ],
    );
  }


  // ═══════════════════════════════════════════════
  // COMPLETION CARD
  // ═══════════════════════════════════════════════

  Widget _buildCompletionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: _isDarkMode
            ? kGold.withOpacity(0.10)
            : const Color(0xFFFFF6DC),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: kGold.withOpacity(0.5),
        ),
      ),

      child: Column(
        children: [

          const Icon(
            Icons.check_circle,
            color: kGold,
            size: 48,
          ),

          const SizedBox(height: 14),

          // Hovedmelding når hele Umrah er fullført.
          Text(
            'Umrah Mubarak',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: _primaryTextColor,
              fontSize: 24 * _textScale,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Alhamdulillah',

            style: TextStyle(
              color: kGold,
              fontSize: 18 * _textScale,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'May Allah accept your Umrah and your worship.',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: 14 * _textScale,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '4 of 4 steps completed',

            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: 13 * _textScale,
            ),
          ),
        ],
      ),
    );
  }


  // ═══════════════════════════════════════════════
  // REUSABLE HELPERS
  // ═══════════════════════════════════════════════

  Color get _primaryTextColor =>
      _isDarkMode
          ? Colors.white
          : Colors.black87;


  Color get _secondaryTextColor =>
      _isDarkMode
          ? Colors.white70
          : Colors.black54;


  Widget _sectionTitle(
      String text,
      ) {

    return Text(
      text,

      style: TextStyle(
        color:
        _primaryTextColor,

        fontSize:
        17 * _textScale,

        fontWeight:
        FontWeight.bold,
      ),
    );
  }


  Widget _bodyText(
      String text,
      ) {

    return Text(
      text,

      style: TextStyle(
        color:
        _secondaryTextColor,

        fontSize:
        14 * _textScale,

        height: 1.5,
      ),
    );
  }


  Widget _arabicText(
      String text,
      ) {

    return Center(
      child: Text(
        text,

        textAlign:
        TextAlign.center,

        style: TextStyle(
          color: kGold,

          fontSize:
          21 * _textScale,

          height: 1.8,

          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }


  Widget _centerText(
      String text, {
        bool bold = false,
        bool italic = false,
      }) {

    return Center(
      child: Text(
        text,

        textAlign:
        TextAlign.center,

        style: TextStyle(
          color:
          _primaryTextColor,

          fontSize:
          14 * _textScale,

          fontWeight:
          bold
              ? FontWeight.w600
              : FontWeight.normal,

          fontStyle:
          italic
              ? FontStyle.italic
              : FontStyle.normal,

          height: 1.5,
        ),
      ),
    );
  }


  // Gjenbrukes både av Tawaf og Sa'i.
  Widget _buildSevenDots({
    required int completed,
  }) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,

      children:
      List.generate(
        7,
            (index) {

          final bool isCompleted =
              index < completed;

          return Container(
            width: 22,
            height: 22,

            margin:
            const EdgeInsets.symmetric(
              horizontal: 3,
            ),

            decoration:
            BoxDecoration(
              color:
              isCompleted
                  ? kGold
                  : Colors.transparent,

              shape:
              BoxShape.circle,

              border:
              Border.all(
                color:
                isCompleted
                    ? kGold
                    : _isDarkMode
                    ? Colors.white30
                    : Colors.black26,

                width:
                1.5,
              ),
            ),

            child:
            isCompleted
                ? const Icon(
              Icons.check,
              size: 14,
              color:
              kDarkGreen,
            )
                : null,
          );
        },
      ),
    );
  }


  Widget _completedLabel(
      String text,
      ) {

    return Row(
      children: [

        const Icon(
          Icons.check_circle,
          color: kDarkGreen,
        ),

        const SizedBox(width: 8),

        Text(
          text,

          style: TextStyle(
            color:
            _isDarkMode
                ? Colors.white
                : kDarkGreen,

            fontSize:
            15 * _textScale,

            fontWeight:
            FontWeight.w600,
          ),
        ),
      ],
    );
  }


  Widget _buildCompleteButton({
    required int stepIndex,
    required String label,
  }) {

    final bool completed =
    _completedSteps.contains(
      stepIndex,
    );

    final bool canComplete =
    _canCompleteStep(
      stepIndex,
    );

    if (completed) {
      return _completedLabel(
        'Step completed',
      );
    }

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        onPressed:
        canComplete
            ? () {
          _completeStep(
            stepIndex,
          );
        }
            : null,

        icon:
        const Icon(
          Icons.check_circle_outline,
        ),

        label: Text(
          canComplete
              ? label
              : 'Complete previous step first',
        ),

        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          kDarkGreen,

          foregroundColor:
          Colors.white,

          disabledBackgroundColor:
          Colors.grey.shade300,

          disabledForegroundColor:
          Colors.grey.shade600,

          padding:
          const EdgeInsets.symmetric(
            vertical: 16,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// UMRAH STEP CARD
// ═════════════════════════════════════════════════

class _UmrahStepCard extends StatelessWidget {

  final int number;

  final String title;
  final String arabicTitle;
  final String subtitle;

  final bool isExpanded;
  final bool isCompleted;
  final bool isDarkMode;

  final double textScale;

  final VoidCallback onTap;

  final Widget expandedContent;


  const _UmrahStepCard({
    required this.number,
    required this.title,
    required this.arabicTitle,
    required this.subtitle,
    required this.isExpanded,
    required this.isCompleted,
    required this.isDarkMode,
    required this.textScale,
    required this.onTap,
    required this.expandedContent,
  });


  @override
  Widget build(
      BuildContext context,
      ) {

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
    isCompleted
        ? kDarkGreen
        : isDarkMode
        ? Colors.white12
        : const Color(
      0xFFE5E0D8,
    );


    return Material(
      color:
      Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        child: Container(
          padding:
          const EdgeInsets.all(
            18,
          ),

          decoration:
          BoxDecoration(
            color: cardColor,

            borderRadius:
            BorderRadius.circular(
              18,
            ),

            border:
            Border.all(
              color:
              borderColor,

              width:
              isCompleted
                  ? 1.5
                  : 1,
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // Nummer eller checkmark.
                  Container(
                    width: 42,
                    height: 42,

                    decoration:
                    const BoxDecoration(
                      color: kDarkGreen,
                      shape:
                      BoxShape.circle,
                    ),

                    alignment:
                    Alignment.center,

                    child:
                    isCompleted
                        ? const Icon(
                      Icons.check,
                      color:
                      Colors.white,
                    )
                        : Text(
                      '$number',

                      style:
                      TextStyle(
                        color:
                        Colors.white,

                        fontSize:
                        16 * textScale,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 16,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          title,

                          style:
                          TextStyle(
                            color:
                            titleColor,

                            fontSize:
                            20 * textScale,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          arabicTitle,

                          style:
                          TextStyle(
                            color:
                            kGold,

                            fontSize:
                            16 * textScale,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          subtitle,

                          style:
                          TextStyle(
                            color:
                            secondaryColor,

                            fontSize:
                            14 * textScale,

                            height:
                            1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Icon(
                    isExpanded
                        ? Icons
                        .keyboard_arrow_up
                        : Icons
                        .keyboard_arrow_down,

                    color:
                    isDarkMode
                        ? Colors.white54
                        : Colors.black45,
                  ),
                ],
              ),

              if (isExpanded) ...[
                const SizedBox(
                  height: 18,
                ),

                Divider(
                  color:
                  isDarkMode
                      ? Colors.white12
                      : Colors.black12,
                ),

                const SizedBox(
                  height: 12,
                ),

                expandedContent,
              ],
            ],
          ),
        ),
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// INSTRUCTION ITEM
// ═════════════════════════════════════════════════

class _InstructionItem extends StatelessWidget {

  final int number;
  final String text;

  final double textScale;
  final bool isDarkMode;


  const _InstructionItem({
    required this.number,
    required this.text,
    required this.textScale,
    required this.isDarkMode,
  });


  @override
  Widget build(
      BuildContext context,
      ) {

    final Color textColor =
    isDarkMode
        ? Colors.white70
        : Colors.black54;

    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(
            width: 26,
            height: 26,

            alignment:
            Alignment.center,

            decoration:
            BoxDecoration(
              color:
              kGold.withOpacity(
                0.18,
              ),

              shape:
              BoxShape.circle,
            ),

            child: Text(
              '$number',

              style:
              const TextStyle(
                color:
                kDarkGreen,

                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Text(
              text,

              style:
              TextStyle(
                color:
                textColor,

                fontSize:
                14 * textScale,

                height:
                1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// INFO BOX
// ═════════════════════════════════════════════════

class _InfoBox extends StatelessWidget {

  final String title;
  final Widget child;

  final bool isDarkMode;
  final double textScale;


  const _InfoBox({
    required this.title,
    required this.child,
    required this.isDarkMode,
    required this.textScale,
  });


  @override
  Widget build(
      BuildContext context,
      ) {

    return Container(
      width:
      double.infinity,

      padding:
      const EdgeInsets.all(
        16,
      ),

      decoration:
      BoxDecoration(
        color:
        isDarkMode
            ? Colors.white
            .withOpacity(
          0.05,
        )
            : kGold
            .withOpacity(
          0.10,
        ),

        borderRadius:
        BorderRadius.circular(
          16,
        ),

        border:
        Border.all(
          color:
          kGold.withOpacity(
            0.35,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style:
            TextStyle(
              color:
              isDarkMode
                  ? Colors.white
                  : kDarkGreen,

              fontSize:
              15 * textScale,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          child,
        ],
      ),
    );
  }
}