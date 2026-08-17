import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────
// FARGER
// ─────────────────────────────────────────────────

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

  // Holder styr på hvilke hovedsteg som er fullført.
  //
  // 0 = Ihram
  // 1 = Tawaf
  // 2 = Sa'i
  // 3 = Hair Cutting
  final Set<int> _completedSteps = {};

  // Første steg er åpent når guiden åpnes.
  int? _expandedStep = 0;

  // Innstillinger.
  bool _isDarkMode = false;
  double _textScale = 1.0;

  // Tawaf-teller.
  // Verdien skal alltid være mellom 0 og 7.
  int _tawafRounds = 0;


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

                      // Håndtak
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

                          // LIGHT
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isDarkMode = false;
                                });

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

                          // DARK
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

                            // Mindre tekst
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

                              icon: const Icon(Icons.remove),
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

                            // Større tekst
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

                              icon: const Icon(Icons.add),
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

    // Ihram kan fullføres først.
    if (stepIndex == 0) {
      return true;
    }

    // Alle andre steg krever at steget før
    // allerede er fullført.
    return _completedSteps.contains(stepIndex - 1);
  }


  void _completeStep(int stepIndex) {

    if (!_canCompleteStep(stepIndex)) {
      return;
    }

    // Tawaf kan ikke fullføres før telleren er 7/7.
    if (stepIndex == 1 && _tawafRounds < 7) {
      return;
    }

    setState(() {
      _completedSteps.add(stepIndex);

      // Åpne neste steg automatisk.
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

    // Ingen grunn til å spørre om reset hvis telleren
    // allerede står på null.
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

                    // Progress
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
          // GUIDE
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
                  'Walk between Safa and Marwa',

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
                  'Shave or trim the hair to complete Umrah',

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

                // Vises når hele Umrah er fullført.
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
  // IHRAM
  // ═══════════════════════════════════════════════

  Widget _buildIhramContent() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _sectionTitle(
          'Before entering Ihram',
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,

          text:
          'Prepare yourself before reaching the Miqat.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 2,

          text:
          'Put on the Ihram garments before entering the state of Ihram.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 3,

          text:
          'Make a sincere intention to perform Umrah.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        const SizedBox(height: 16),

        // NIYYAH
        _InfoBox(
          title: 'Niyyah · Intention',

          isDarkMode:
          _isDarkMode,

          textScale:
          _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                'Make the sincere intention to perform Umrah.',
              ),

              const SizedBox(height: 16),

              _arabicText(
                'لَبَّيْكَ اللَّهُمَّ عُمْرَةً',
              ),

              const SizedBox(height: 10),

              _centerText(
                "Labbayka Allahumma 'Umrah",
                bold: true,
              ),

              const SizedBox(height: 6),

              _centerText(
                'Here I am, O Allah, for Umrah.',
                italic: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // TALBIYAH
        _InfoBox(
          title: 'Talbiyah',

          isDarkMode:
          _isDarkMode,

          textScale:
          _textScale,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              _bodyText(
                'After entering Ihram, begin reciting the Talbiyah.',
              ),

              const SizedBox(height: 14),

              _arabicText(
                'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، '
                    'لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، '
                    'إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ '
                    'وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
              ),

              const SizedBox(height: 12),

              _bodyText(
                'Labbayka Allahumma labbayk, '
                    'labbayka la sharika laka labbayk. '
                    'Innal-hamda wan-ni‘mata laka wal-mulk, '
                    'la sharika lak.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        _buildCompleteButton(
          stepIndex: 0,
          label:
          'Mark Ihram as complete',
        ),
      ],
    );
  }


  // ═══════════════════════════════════════════════
  // TAWAF
  // ═══════════════════════════════════════════════

  Widget _buildTawafContent() {

    final bool tawafReady =
        _tawafRounds == 7;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _sectionTitle(
          'Perform Tawaf',
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,

          text:
          'Begin at the Black Stone (Hajar al-Aswad) and keep the Kaaba on your left.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 2,

          text:
          'Walk around the Kaaba in a counter-clockwise direction.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 3,

          text:
          'Complete seven full circuits. Each circuit counts as one round.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 4,

          text:
          'Make dua and dhikr while performing Tawaf.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        const SizedBox(height: 18),


        // ═══════════════════════════════════════
        // TAWAF COUNTER
        // ═══════════════════════════════════════

        _InfoBox(
          title: 'Tawaf counter',

          isDarkMode:
          _isDarkMode,

          textScale:
          _textScale,

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
                    ? 'All rounds completed'
                    : 'rounds completed',

                style: TextStyle(
                  color:
                  _secondaryTextColor,

                  fontSize:
                  13 * _textScale,
                ),
              ),

              const SizedBox(height: 18),

              // Sirkler som viser 7 runder.
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children:
                List.generate(
                  7,
                      (index) {

                    final bool completed =
                        index < _tawafRounds;

                    return Container(
                      width: 22,
                      height: 22,

                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),

                      decoration:
                      BoxDecoration(
                        color: completed
                            ? kGold
                            : Colors.transparent,

                        shape:
                        BoxShape.circle,

                        border:
                        Border.all(
                          color: completed
                              ? kGold
                              : _isDarkMode
                              ? Colors.white30
                              : Colors.black26,

                          width: 1.5,
                        ),
                      ),

                      child: completed
                          ? const Icon(
                        Icons.check,
                        size: 14,
                        color: kDarkGreen,
                      )
                          : null,
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [

                  // Minus
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

                  // Plus
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                      _tawafRounds < 7
                          ? _increaseTawafRound
                          : null,

                      icon: const Icon(
                        Icons.add,
                      ),

                      label:
                      Text(
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

                        disabledBackgroundColor:
                        kGold.withOpacity(0.35),

                        disabledForegroundColor:
                        kDarkGreen,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

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

        const SizedBox(height: 16),

        _InfoBox(
          title: 'After Tawaf',

          isDarkMode:
          _isDarkMode,

          textScale:
          _textScale,

          child: _bodyText(
            'After completing the seven rounds, continue with the remaining acts after Tawaf before moving on to Sa\'i.',
          ),
        ),

        const SizedBox(height: 22),

        // Tawaf-knappen får spesiallogikk:
        // den er deaktivert frem til 7/7.
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
                    ? 'Complete all 7 rounds'
                    : 'Mark Tawaf as complete',
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
                  BorderRadius.circular(14),
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
  // SA'I
  // ═══════════════════════════════════════════════

  Widget _buildSaiContent() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _sectionTitle(
          "Perform Sa'i",
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,

          text:
          'Begin at Safa and proceed towards Marwa.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 2,

          text:
          'Safa to Marwa counts as one lap.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 3,

          text:
          'Marwa back to Safa counts as the second lap.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 4,

          text:
          'Complete seven laps. The seventh lap finishes at Marwa.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        const SizedBox(height: 16),

        _InfoBox(
          title: "Sa'i",

          isDarkMode:
          _isDarkMode,

          textScale:
          _textScale,

          child: _bodyText(
            'Safa → Marwa = 1\n'
                'Marwa → Safa = 2\n'
                'Continue until the seventh lap, ending at Marwa.',
          ),
        ),

        const SizedBox(height: 22),

        _buildCompleteButton(
          stepIndex: 2,
          label:
          "Mark Sa'i as complete",
        ),
      ],
    );
  }


  // ═══════════════════════════════════════════════
  // HAIR CUTTING
  // ═══════════════════════════════════════════════

  Widget _buildHairCuttingContent() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _sectionTitle(
          'Complete your Umrah',
        ),

        const SizedBox(height: 12),

        _InstructionItem(
          number: 1,

          text:
          'After completing Sa\'i, complete the required hair cutting.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 2,

          text:
          'Men may shave the head or shorten the hair.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        _InstructionItem(
          number: 3,

          text:
          'Women shorten a small amount from the ends of their hair.',

          textScale:
          _textScale,

          isDarkMode:
          _isDarkMode,
        ),

        const SizedBox(height: 16),

        _InfoBox(
          title: 'Leaving Ihram',

          isDarkMode:
          _isDarkMode,

          textScale:
          _textScale,

          child: _bodyText(
            'After the hair cutting is completed, the Umrah is complete and the state of Ihram ends.',
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
  // COMPLETION
  // ═══════════════════════════════════════════════

  Widget _buildCompletionCard() {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: _isDarkMode
            ? kGold.withOpacity(0.10)
            : const Color(0xFFFFF6DC),

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color:
          kGold.withOpacity(0.5),
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

          Text(
            'Umrah Complete',

            style: TextStyle(
              color: _primaryTextColor,
              fontSize:
              22 * _textScale,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'May Allah accept your Umrah',

            textAlign:
            TextAlign.center,

            style: TextStyle(
              color: kGold,
              fontSize:
              17 * _textScale,

              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '4 of 4 steps completed',

            style: TextStyle(
              color:
              _secondaryTextColor,

              fontSize:
              13 * _textScale,
            ),
          ),
        ],
      ),
    );
  }


  // ═══════════════════════════════════════════════
  // HELPERS
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
        ),
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
            color: _isDarkMode
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
        onPressed: canComplete
            ? () {
          _completeStep(
            stepIndex,
          );
        }
            : null,

        icon: const Icon(
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

class _UmrahStepCard
    extends StatelessWidget {

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

                  // Nummer/checkmark
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

class _InstructionItem
    extends StatelessWidget {

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

class _InfoBox
    extends StatelessWidget {

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