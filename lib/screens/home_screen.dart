import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'umrah_screen.dart';
import 'hajj_screen.dart';
import 'map_screen.dart';
import 'duas_screen.dart';
import 'checklist_screen.dart';
import 'emergency_screen.dart';


// ─────────────────────────────────────────────────
// GLOBALE KONSTANTER
// ─────────────────────────────────────────────────

const Color kDarkGreen = Color(0xFF062E22);
const Color kGold = Color(0xFFE9C46A);
const Color kBackground = Color(0xFFF5F0EB);


// ═════════════════════════════════════════════════
// HOMESCREEN
//
// Holder styr på bottom navigation.
// ═════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 = Home
  // 1 = Map
  // 2 = Duas
  // 3 = Checklist
  // 4 = Help
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    MapScreen(),
    DuasScreen(),
    ChecklistScreen(),
    EmergencyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkGreen,

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        backgroundColor: Colors.white,
        selectedItemColor: kDarkGreen,
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Duas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Help',
          ),
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// HOME TAB
//
// Selve innholdet på hjemmeskjermen.
// Stateful fordi vi henter data fra API-er.
// ═════════════════════════════════════════════════

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String _hijriDate = '';

  late Future<Map<String, dynamic>> _prayerTimesFuture;
  late Future<Map<String, dynamic>> _hadithFuture;

  @override
  void initState() {
    super.initState();

    // API-kallene kjøres én gang når skjermen opprettes.
    _prayerTimesFuture = _fetchPrayerTimes();
    _hadithFuture = _fetchHadith();
  }


  // ───────────────────────────────────────────────
  // HENT BØNNETIDER
  // ───────────────────────────────────────────────

  Future<Map<String, dynamic>> _fetchPrayerTimes() async {
    final now = DateTime.now();

    // AlAdhan bruker DD-MM-YYYY.
    final date =
        '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';

    final response = await http.get(
      Uri.parse(
        'https://api.aladhan.com/v1/timingsByCity/$date'
            '?city=Oslo&country=Norway&method=2',
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];

      // mounted sjekker at widgeten fortsatt eksisterer
      // før vi kaller setState().
      if (mounted) {
        setState(() {
          final hijri = data['date']['hijri'];

          _hijriDate =
          '${hijri['month']['en']} ${hijri['year']} AH';
        });
      }

      return Map<String, dynamic>.from(data);
    }

    throw Exception('Klarte ikke hente bønnetider');
  }


  // ───────────────────────────────────────────────
  // HENT HADITH
  // ───────────────────────────────────────────────

  Future<Map<String, dynamic>> _fetchHadith() async {
    final response = await http.get(
      Uri.parse(
        'https://ummahapi.com/api/hadith/random',
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return Map<String, dynamic>.from(
        json['data'],
      );
    }

    throw Exception('Klarte ikke hente hadith');
  }


  // ───────────────────────────────────────────────
  // BYGG HOMESCREEN
  // ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Hele hjemskjermen kan scrolles.
    return CustomScrollView(
      slivers: [

        // ════════════════════════════════════════
        // GRØNN TOPP
        // ════════════════════════════════════════

        SliverToBoxAdapter(
          child: Container(
            color: kDarkGreen,

            child: SafeArea(
              bottom: false,

              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Hijri-dato
                    Text(
                      _hijriDate,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Arabisk hilsen
                    const Text(
                      'السلام عليكم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      'Peace be upon you, Pilgrim',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bønnetider
                    FutureBuilder<Map<String, dynamic>>(
                      future: _prayerTimesFuture,

                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: kGold,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text(
                            'Kunne ikke laste bønnetider',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          );
                        }

                        final timings =
                        Map<String, dynamic>.from(
                          snapshot.data!['timings'],
                        );

                        return _PrayerCard(
                          timings: timings,
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),


        // ════════════════════════════════════════
        // QUICK ACCESS
        // ════════════════════════════════════════

        SliverToBoxAdapter(
          child: Container(
            color: kBackground,
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              0,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'QUICK ACCESS',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 12),

                // Vi bruker GridView inni CustomScrollView.
                // Derfor skal GridView IKKE scrolle selv.
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,

                  children: [
                    _QuickCard(
                      title: 'Umrah Guide',
                      arabic: 'دليل العمرة',
                      icon: Icons.menu_book,
                      color: const Color(0xFFE8F5E9),
                      iconColor: kDarkGreen,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const UmrahScreen(),
                          ),
                        );
                      },
                    ),

                    _QuickCard(
                      title: 'Hajj Guide',
                      arabic: 'دليل الحج',
                      icon: Icons.star_border,
                      color: const Color(0xFFFFF8E1),
                      iconColor:
                      const Color(0xFF8B6914),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const HajjScreen(),
                          ),
                        );
                      },
                    ),

                    _QuickCard(
                      title: 'Holy Sites',
                      arabic: 'خريطة المشاعر',
                      icon: Icons.map_outlined,
                      color: const Color(0xFFE3F2FD),
                      iconColor:
                      const Color(0xFF1565C0),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const MapScreen(),
                          ),
                        );
                      },
                    ),

                    _QuickCard(
                      title: 'Duas & Dhikr',
                      arabic: 'الأدعية والأذكار',
                      icon: Icons.favorite_border,
                      color: const Color(0xFFFCE4EC),
                      iconColor:
                      const Color(0xFFC62828),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const DuasScreen(),
                          ),
                        );
                      },
                    ),

                    _QuickCard(
                      title: 'Checklist',
                      arabic: 'قائمة التحقق',
                      icon: Icons.check_box_outlined,
                      color: const Color(0xFFEDE7F6),
                      iconColor:
                      const Color(0xFF6A1B9A),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ChecklistScreen(),
                          ),
                        );
                      },
                    ),

                    _QuickCard(
                      title: 'Emergency',
                      arabic: 'الطوارئ',
                      icon: Icons.shield_outlined,
                      color: const Color(0xFFFBE9E7),
                      iconColor:
                      const Color(0xFFBF360C),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const EmergencyScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),


        // ════════════════════════════════════════
        // HADITH OF THE DAY
        // ════════════════════════════════════════

        SliverToBoxAdapter(
          child: Container(
            color: kBackground,
            padding: const EdgeInsets.fromLTRB(
              20,
              24,
              20,
              24,
            ),

            child: FutureBuilder<Map<String, dynamic>>(
              future: _hadithFuture,

              builder: (context, snapshot) {
                // Laster
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(
                        color: kGold,
                      ),
                    ),
                  );
                }

                // Feil
                if (snapshot.hasError) {
                  return const _HadithErrorCard();
                }

                // Data tilgjengelig
                final hadith = snapshot.data!;

                return _HadithCard(
                  text:
                  hadith['english'] ??
                      'Hadith unavailable',

                  collection:
                  hadith['collection_name'] ??
                      hadith['collection'] ??
                      '',

                  grade:
                  hadith['grade'] ?? '',

                  hadithNumber:
                  hadith['hadithnumber'],
                );
              },
            ),
          ),
        ),


        // ════════════════════════════════════════
        // FYLL RESTEN MED BEIGE
        // ════════════════════════════════════════

        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            color: kBackground,
          ),
        ),
      ],
    );
  }
}


// ═════════════════════════════════════════════════
// PRAYER CARD
// ═════════════════════════════════════════════════

class _PrayerCard extends StatelessWidget {
  final Map<String, dynamic> timings;

  static const List<String> prayerOrder = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  const _PrayerCard({
    required this.timings,
  });


  // Finn neste bønn.
  String getNextPrayer() {
    final now = TimeOfDay.now();

    for (final prayer in prayerOrder) {
      final time = timings[prayer].toString();

      final parts = time.split(':');

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (now.hour < hour ||
          (now.hour == hour &&
              now.minute < minute)) {
        return prayer;
      }
    }

    // Etter Isha → neste bønn er Fajr.
    return 'Fajr';
  }


  // Hvor lenge er det til neste bønn?
  String getTimeUntilNextPrayer(
      String nextPrayer,
      ) {
    final now = DateTime.now();

    final time =
    timings[nextPrayer].toString();

    final parts = time.split(':');

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    var prayerTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Hvis tidspunktet allerede er passert,
    // betyr Fajr at vi mener Fajr i morgen.
    if (prayerTime.isBefore(now)) {
      prayerTime =
          prayerTime.add(
            const Duration(days: 1),
          );
    }

    final difference =
    prayerTime.difference(now);

    final hours =
        difference.inHours;

    final minutes =
        difference.inMinutes % 60;

    if (hours > 0) {
      return 'in ${hours}h ${minutes}m';
    }

    return 'in ${minutes}m';
  }


  @override
  Widget build(BuildContext context) {
    final nextPrayer =
    getNextPrayer();

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
        Colors.white.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const Text(
            'NEXT PRAYER',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            nextPrayer,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            '${timings[nextPrayer]}  ·  '
                '${getTimeUntilNextPrayer(nextPrayer)}',

            style: const TextStyle(
              color: kGold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              _PrayerChip(
                name: 'Fajr',
                time: timings['Fajr'].toString(),
                isActive:
                nextPrayer == 'Fajr',
              ),

              _PrayerChip(
                name: 'Dhuhr',
                time: timings['Dhuhr'].toString(),
                isActive:
                nextPrayer == 'Dhuhr',
              ),

              _PrayerChip(
                name: 'Asr',
                time: timings['Asr'].toString(),
                isActive:
                nextPrayer == 'Asr',
              ),

              _PrayerChip(
                name: 'Maghrib',
                time:
                timings['Maghrib'].toString(),
                isActive:
                nextPrayer == 'Maghrib',
              ),

              _PrayerChip(
                name: 'Isha',
                time: timings['Isha'].toString(),
                isActive:
                nextPrayer == 'Isha',
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// PRAYER CHIP
// ═════════════════════════════════════════════════

class _PrayerChip extends StatelessWidget {
  final String name;
  final String time;
  final bool isActive;

  const _PrayerChip({
    required this.name,
    required this.time,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: isActive
            ? kGold
            : Colors.white.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              color: isActive
                  ? kDarkGreen
                  : Colors.white54,

              fontSize: 11,

              fontWeight: isActive
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            time,
            style: TextStyle(
              color: isActive
                  ? kDarkGreen
                  : Colors.white,

              fontSize: 12,

              fontWeight: isActive
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// QUICK ACCESS CARD
// ═════════════════════════════════════════════════

class _QuickCard extends StatelessWidget {
  final String title;
  final String arabic;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickCard({
    required this.title,
    required this.arabic,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding:
        const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: color,
          borderRadius:
          BorderRadius.circular(16),
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color:
                iconColor.withOpacity(0.15),

                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              arabic,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            Icon(
              Icons.arrow_forward_ios,
              color:
              iconColor.withOpacity(0.5),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// HADITH CARD
// ═════════════════════════════════════════════════

class _HadithCard extends StatelessWidget {
  final String text;
  final String collection;
  final String grade;
  final dynamic hadithNumber;

  const _HadithCard({
    required this.text,
    required this.collection,
    required this.grade,
    this.hadithNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
        const Color(0xFFFFF7E2),

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color:
          kGold.withOpacity(0.6),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Color(0xFFC89B32),
                size: 16,
              ),

              SizedBox(width: 8),

              Text(
                'HADITH OF THE DAY',
                style: TextStyle(
                  color:
                  Color(0xFFC89B32),
                  fontSize: 12,
                  fontWeight:
                  FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            '"$text"',
            style: const TextStyle(
              color: Color(0xFF1C1C2B),
              fontSize: 17,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          if (collection.isNotEmpty)
            Text(
              hadithNumber != null
                  ? '— $collection · Hadith $hadithNumber'
                  : '— $collection',

              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight:
                FontWeight.w600,
              ),
            ),

          if (grade.isNotEmpty) ...[
            const SizedBox(height: 5),

            Text(
              'Grade: $grade',
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// HADITH ERROR CARD
// ═════════════════════════════════════════════════

class _HadithErrorCard extends StatelessWidget {
  const _HadithErrorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
        const Color(0xFFFFF7E2),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(
            'HADITH OF THE DAY',
            style: TextStyle(
              color:
              Color(0xFFC89B32),
              fontSize: 12,
              fontWeight:
              FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          SizedBox(height: 12),

          Text(
            'Could not load today\'s hadith.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}