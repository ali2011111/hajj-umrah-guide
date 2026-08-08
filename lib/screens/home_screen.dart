import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'umrah_screen.dart';
import 'hajj_screen.dart';
import 'map_screen.dart';
import 'duas_screen.dart';
import 'checklist_screen.dart';
import 'emergency_screen.dart';

// ─────────────────────────────────────────
// GLOBALE FARGER
// Definert én gang her, brukt overalt i filen.
// Slipper å gjenta hex-koder og enkelt å endre.
// ─────────────────────────────────────────
const Color kDarkGreen = Color(0xFF062E22);
const Color kGold = Color(0xFFE9C46A);


// ═══════════════════════════════════════════════════
// HOMESCREEN – SKALLET
//
// StatefulWidget fordi den må huske hvilken
// fane som er aktiv (tall som endrer seg = state).
//
// Struktur:
//   HomeScreen         → selve widgeten (hva er jeg?)
//   _HomeScreenState   → tilstanden (hva husker jeg?)
// ═══════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // createState forteller Flutter hvilken State-klasse
  // som hører til denne widgeten
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // _currentIndex husker hvilken fane som er aktiv.
  // 0 = Home, 1 = Map, 2 = Duas, osv.
  int _currentIndex = 0;

  // Alle faneskjermene samlet i én liste.
  // Når _currentIndex endres, bytter vi bare til
  // den skjermen som ligger på den indeksen.
  final List<Widget> _screens = const [
    _HomeTab(),
    MapScreen(),
    DuasScreen(),
    ChecklistScreen(),
    EmergencyScreen(),
  ];

  // ─────────────────────────────────────────
  // build() – TEGNER SKJERMEN
  //
  // Flutter kaller denne automatisk hver gang
  // noe endrer seg (f.eks. når fane byttes).
  // Returnerer alltid en Widget.
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkGreen,

      // Vis skjermen som tilsvarer aktiv fane
      body: _screens[_currentIndex],

      // BottomNavigationBar er menylinjen nederst
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        // onTap kjøres når brukeren trykker på en fane.
        // setState() sier til Flutter: "tegn om skjermen!"
        onTap: (index) => setState(() => _currentIndex = index),

        backgroundColor: kDarkGreen,
        selectedItemColor: kGold,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Duas'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined), label: 'Checklist'),
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Help'),
        ],
      ),
    );
  }
}


// ═══════════════════════════════════════════════════
// _HOMETAB – INNHOLDET PÅ HJEMFANEN
//
// StatefulWidget fordi vi henter data fra internett
// og trenger å oppdatere skjermen når dataen kommer.
// ═══════════════════════════════════════════════════
class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {

  // Hijri-datoen vises øverst.
  // Starter tom, fylles inn når API-et svarer.
  String _hijriDate = '';

  // "late" betyr: denne variabelen får verdi senere (i initState).
  // Future<...> betyr: dette er noe som kommer i fremtiden.
  late Future<Map<String, dynamic>> _prayerTimesFuture;


  // ─────────────────────────────────────────
  // initState() – KJØRER ÉN GANG VED OPPSTART
  //
  // Som en "våkn opp"-funksjon.
  // Perfekt for å starte API-kall slik at
  // dataen er klar så fort mulig.
  // ─────────────────────────────────────────
  @override
  void initState() {
    super.initState(); // alltid kall super først
    _prayerTimesFuture = _fetchPrayerTimes(); // start API-kallet
  }


  // ─────────────────────────────────────────
  // _fetchPrayerTimes() – HENTER DATA FRA INTERNETT
  //
  // async = denne funksjonen kan vente på svar
  // await = vent her til internett svarer
  // Future = lover å returnere data "en gang"
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> _fetchPrayerTimes() async {
    final response = await http.get(
      Uri.parse(
        'https://api.aladhan.com/v1/timingsByCity/08-08-2026?city=Oslo&country=Norway&method=2',
      ),
    );

    if (response.statusCode == 200) {
      // jsonDecode gjør om rå tekst fra internett
      // til et Dart-objekt vi kan jobbe med
      final json = jsonDecode(response.body);
      final data = json['data'];

      // setState() oppdaterer _hijriDate og
      // forteller Flutter å tegne skjermen på nytt
      setState(() {
        _hijriDate =
            '${data['date']['hijri']['month']['en']} ${data['date']['hijri']['year']} AH';
      });

      return data;
    } else {
      throw Exception('Klarte ikke hente bønnetider');
    }
  }


  // ─────────────────────────────────────────
  // build() – TEGNER HJEMFANEN
  //
  // Kalles automatisk av Flutter.
  // Kalles på nytt hver gang setState() kjøres.
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),

            // Hijri-dato (tom til API svarer)
            Text(
              _hijriDate,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),

            const SizedBox(height: 8),

            // Arabisk hilsen
            const Text(
              'السلام عليكم',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Peace be upon you, Pilgrim',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────
            // FutureBuilder – HÅNDTERER VENTETIDEN
            //
            // Har tre tilstander:
            //   1. Laster  → vis spinner
            //   2. Feil    → vis feilmelding
            //   3. Ferdig  → vis bønnetidene
            // ─────────────────────────────────────────
            FutureBuilder<Map<String, dynamic>>(
              future: _prayerTimesFuture,
              builder: (context, snapshot) {

                // Tilstand 1: venter på svar fra internett
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kGold),
                  );
                }

                // Tilstand 2: noe gikk galt
                if (snapshot.hasError) {
                  return const Text(
                    'Kunne ikke laste bønnetider',
                    style: TextStyle(color: Colors.red),
                  );
                }

                // Tilstand 3: data er klar – vis bønnetidene
                final timings = snapshot.data!['timings'];
                return _PrayerCard(timings: timings);
              },
            ),

            const SizedBox(height: 28),

            const Text(
              'QUICK ACCESS',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 12),

            // Rutenett med snarveier – 2 kort per rad
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _QuickCard(
                  title: 'Umrah Guide',
                  arabic: 'دليل العمرة',
                  icon: Icons.menu_book,
                  color: const Color(0xFF0A4A35),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const UmrahScreen())),
                ),
                _QuickCard(
                  title: 'Hajj Guide',
                  arabic: 'دليل الحج',
                  icon: Icons.star_border,
                  color: const Color(0xFF3D2E00),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HajjScreen())),
                ),
                _QuickCard(
                  title: 'Holy Sites',
                  arabic: 'خريطة المشاعر',
                  icon: Icons.map_outlined,
                  color: const Color(0xFF0A2A4A),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MapScreen())),
                ),
                _QuickCard(
                  title: 'Duas & Dhikr',
                  arabic: 'الأدعية والأذكار',
                  icon: Icons.favorite_border,
                  color: const Color(0xFF3D0A0A),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DuasScreen())),
                ),
                _QuickCard(
                  title: 'Checklist',
                  arabic: 'قائمة التحقق',
                  icon: Icons.check_box_outlined,
                  color: const Color(0xFF2A0A3D),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ChecklistScreen())),
                ),
                _QuickCard(
                  title: 'Emergency',
                  arabic: 'الطوارئ',
                  icon: Icons.shield_outlined,
                  color: const Color(0xFF3D1A0A),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const EmergencyScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════
// _PRAYERCARD – BØNNETID-BOKSEN
//
// StatelessWidget fordi den bare viser data
// den får inn – den endrer ingenting selv.
//
// Skilt ut som egen widget for å holde
// build() i _HomeTabState kortere og ryddigere.
// ═══════════════════════════════════════════════════
class _PrayerCard extends StatelessWidget {
  // timings er Map vi får fra API-et, f.eks:
  // { 'Fajr': '03:18', 'Dhuhr': '13:23', ... }
  final Map<String, dynamic> timings;

  const _PrayerCard({required this.timings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEXT PRAYER',
            style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fajr',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            timings['Fajr'],
            style: const TextStyle(color: kGold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Alle fem bønner på én rad
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PrayerChip(name: 'Fajr',    time: timings['Fajr']),
              _PrayerChip(name: 'Dhuhr',   time: timings['Dhuhr']),
              _PrayerChip(name: 'Asr',     time: timings['Asr']),
              _PrayerChip(name: 'Maghrib', time: timings['Maghrib']),
              _PrayerChip(name: 'Isha',    time: timings['Isha']),
            ],
          ),
        ],
      ),
    );
  }
}


// ═══════════════════════════════════════════════════
// _PRAYERCHIP – LITEN BØNNETIME-BRIKKE
//
// Viser navn og tid for én enkelt bønn.
// Brukes fem ganger i _PrayerCard (én per bønn).
// ═══════════════════════════════════════════════════
class _PrayerChip extends StatelessWidget {
  final String name; // f.eks. "Fajr"
  final String time; // f.eks. "03:18"

  const _PrayerChip({required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}


// ═══════════════════════════════════════════════════
// _QUICKCARD – SNARVEI-KORT
//
// Gjenbrukbart kort i Quick Access-rutenettet.
// VoidCallback er en funksjon uten parametere
// som kjøres når brukeren trykker på kortet.
// ═══════════════════════════════════════════════════
class _QuickCard extends StatelessWidget {
  final String title;       // norsk/engelsk navn
  final String arabic;      // arabisk navn
  final IconData icon;      // ikon fra Icons-biblioteket
  final Color color;        // bakgrunnsfarge
  final VoidCallback onTap; // hva skjer når man trykker?

  const _QuickCard({
    required this.title,
    required this.arabic,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector gjør widgeten klikkbar
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: kGold, size: 28),
            const Spacer(), // skyver teksten ned mot bunnen
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(arabic,
                style: const TextStyle(color: kGold, fontSize: 12)),
            const SizedBox(height: 4),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 12),
          ],
        ),
      ),
    );
  }
}