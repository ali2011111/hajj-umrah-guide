import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'umrah_screen.dart';
import 'hajj_screen.dart';
import 'map_screen.dart';
import 'duas_screen.dart';
import 'checklist_screen.dart';
import 'emergency_screen.dart';


// ─────────────────────────────────────────────────
// GLOBALE KONSTANTER
//
// const betyr at verdien aldri endrer seg.
// Ved å definere farger her én gang slipper vi
// å gjenta hex-koder overalt i koden.
// ─────────────────────────────────────────────────
const Color kDarkGreen = Color(0xFF062E22);
const Color kGold      = Color(0xFFE9C46A);


// ═════════════════════════════════════════════════
// HOMESCREEN
//
// Dette er skallet som holder hele appen sammen.
// Den gjør to ting:
//   1. Viser riktig skjerm basert på hvilken fane som er aktiv
//   2. Viser menylinjen nederst
//
// Vi bruker StatefulWidget fordi vi må huske
// hvilken fane som er aktiv (_currentIndex).
// Når _currentIndex endrer seg → tegn skjermen på nytt.
// ═════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Holder styr på hvilken fane som er aktiv.
  // 0 = Home, 1 = Map, 2 = Duas, 3 = Checklist, 4 = Help
  int _currentIndex = 0;

  // Liste over alle faneskjermene.
  // _screens[0] = hjemskjermen, _screens[1] = kartet, osv.
  // Når brukeren trykker på en fane, bytter vi bare indeks.
  final List<Widget> _screens = const [
    _HomeTab(),
    MapScreen(),
    DuasScreen(),
    ChecklistScreen(),
    EmergencyScreen(),
  ];

  // build() tegner skjermen.
  // Flutter kaller denne automatisk når _currentIndex endres.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkGreen,

      // Vis skjermen som tilsvarer aktiv fane
      body: _screens[_currentIndex],

      // Menylinjen nederst på skjermen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        // Når brukeren trykker en fane:
        // setState() oppdaterer _currentIndex og
        // ber Flutter tegne skjermen på nytt
        onTap: (index) => setState(() => _currentIndex = index),

        backgroundColor: Colors.white,
        selectedItemColor: kDarkGreen,   // aktiv fane = mørk grønn
        unselectedItemColor: Colors.black38, // inaktiv fane = grå
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map),               label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border),   label: 'Duas'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined),label: 'Checklist'),
          BottomNavigationBarItem(icon: Icon(Icons.phone),             label: 'Help'),
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// _HOMETAB
//
// Selve innholdet på hjemfanen.
// Skjermen er delt i to deler:
//   🟢 Grønn del øverst  → islamsk dato, hilsen og bønnetider
//   ⬜ Hvit del nederst  → snarveier til alle seksjoner
//
// Vi bruker StatefulWidget fordi:
//   - Vi henter bønnetider fra internett (API-kall)
//   - Skjermen må oppdatere seg når dataen kommer tilbake
// ═════════════════════════════════════════════════
class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {

  // Islamsk (Hijri) dato vises øverst på skjermen.
  // Starter som tom tekst, fylles inn når API-et svarer.
  String _hijriDate = '';

  // Holder på selve API-kallet slik at det bare kjøres én gang.
  // "late" = variabelen får verdi i initState(), ikke her.
  // "Future" = dette er noe som kommer i fremtiden (asynkront).
  late Future<Map<String, dynamic>> _prayerTimesFuture;


  // initState() kjører KUN én gang når siden lastes.
  // Tenk på det som en "våkn opp"-funksjon.
  // Vi starter API-kallet her så dataen er klar så fort som mulig.
  @override
  void initState() {
    super.initState(); // alltid kall super først – Flutter krever dette
    _prayerTimesFuture = _fetchPrayerTimes();
  }


  // _fetchPrayerTimes() henter bønnetider fra AlAdhan sitt gratis API.
  //
  // Nøkkelord:
  //   async  = denne funksjonen kan vente på svar fra internett
  //   await  = vent her til svaret kommer før vi går videre
  //   Future = lover å returnere en Map "en gang i fremtiden"
  Future<Map<String, dynamic>> _fetchPrayerTimes() async {
    final response = await http.get(
      Uri.parse(
        'https://api.aladhan.com/v1/timingsByCity/08-08-2026?city=Oslo&country=Norway&method=2',
      ),
    );

    if (response.statusCode == 200) {
      // jsonDecode() gjør om rå tekst fra internett
      // til et Dart Map-objekt vi kan jobbe med
      final json = jsonDecode(response.body);
      final data = json['data'];

      // setState() gjør to ting:
      //   1. Oppdaterer _hijriDate med riktig islamsk dato
      //   2. Forteller Flutter: "tegn skjermen på nytt!"
      setState(() {
        final hijri = data['date']['hijri'];
        _hijriDate = '${hijri['month']['en']} ${hijri['year']} AH';
      });

      // Returner hele data-objektet som inneholder
      // både timings og datoinformasjon
      return data;
    } else {
      throw Exception('Klarte ikke hente bønnetider fra API');
    }
  }


  // build() tegner hjemfanen.
  // Kalles automatisk av Flutter når siden lastes
  // og på nytt hver gang setState() kjøres.
  @override
  Widget build(BuildContext context) {
    // CustomScrollView lar hele skjermen scrolle som én enhet
    return CustomScrollView(
      slivers: [

        // ══ GRØNN DEL ══
        // SliverToBoxAdapter gjør en vanlig widget
        // om til en del av scroll-systemet
        SliverToBoxAdapter(
          child: Container(
            color: kDarkGreen,
            child: SafeArea(
              bottom: false, // bare beskytt toppen
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                // mindre padding = lavere høyde
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Islamsk dato
                    Text(
                      _hijriDate,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13),
                    ),

                    const SizedBox(height: 6), // mindre enn før

                    // Arabisk hilsen
                    const Text(
                      'السلام عليكم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26, // litt mindre enn før
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Peace be upon you, Pilgrim',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),

                    const SizedBox(height: 16),

                    // Bønnetid-boks
                    FutureBuilder<Map<String, dynamic>>(
                      future: _prayerTimesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: kGold),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Kunne ikke laste bønnetider',
                            style: TextStyle(color: Colors.red),
                          );
                        }
                        final timings = snapshot.data!['timings'];
                        return _PrayerCard(timings: timings);
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ══ HVIT DEL ══
        // SliverToBoxAdapter for Quick Access-seksjonen
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFF5F0EB),
            padding: const EdgeInsets.all(20),
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
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  // ClampingScrollPhysics gjør at GridView
                  // ikke prøver å scrolle selv
                  physics: const ClampingScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _QuickCard(
                      title: 'Umrah Guide',
                      arabic: 'دليل العمرة',
                      icon: Icons.menu_book,
                      color: const Color(0xFFE8F5E9),
                      iconColor: kDarkGreen,
                      onTap: () =>
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const UmrahScreen())),
                    ),
                    _QuickCard(
                      title: 'Hajj Guide',
                      arabic: 'دليل الحج',
                      icon: Icons.star_border,
                      color: const Color(0xFFFFF8E1),
                      iconColor: const Color(0xFF8B6914),
                      onTap: () =>
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const HajjScreen())),
                    ),
                    _QuickCard(
                      title: 'Holy Sites',
                      arabic: 'خريطة المشاعر',
                      icon: Icons.map_outlined,
                      color: const Color(0xFFE3F2FD),
                      iconColor: const Color(0xFF1565C0),
                      onTap: () =>
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const MapScreen())),
                    ),
                    _QuickCard(
                      title: 'Duas & Dhikr',
                      arabic: 'الأدعية والأذكار',
                      icon: Icons.favorite_border,
                      color: const Color(0xFFFCE4EC),
                      iconColor: const Color(0xFFC62828),
                      onTap: () =>
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const DuasScreen())),
                    ),
                    _QuickCard(
                      title: 'Checklist',
                      arabic: 'قائمة التحقق',
                      icon: Icons.check_box_outlined,
                      color: const Color(0xFFEDE7F6),
                      iconColor: const Color(0xFF6A1B9A),
                      onTap: () =>
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const ChecklistScreen())),
                    ),
                    _QuickCard(
                      title: 'Emergency',
                      arabic: 'الطوارئ',
                      icon: Icons.shield_outlined,
                      color: const Color(0xFFFBE9E7),
                      iconColor: const Color(0xFFBF360C),
                      onTap: () =>
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const EmergencyScreen())),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Fyller resten av skjermen med hvit farge
        // slik at det ikke er grønt bak kortene
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(color: const Color(0xFFF5F0EB)),
        ),
      ],
    );
  }
}


// ═════════════════════════════════════════════════
// _PRAYERCARD
//
// Boksen som viser bønnetider.
// Bruker StatelessWidget fordi den bare VISER data
// den får inn utenfra – den endrer ingenting selv.
//
// Inneholder:
//   - Neste bønn (beregnet dynamisk fra klokken)
//   - Alle fem daglige bønner på én rad
// ═════════════════════════════════════════════════
class _PrayerCard extends StatelessWidget {

  // timings er et Map fra API-et, f.eks:
  // { 'Fajr': '03:18', 'Dhuhr': '13:23', 'Asr': '17:37', ... }
  final Map<String, dynamic> timings;

  // Rekkefølgen bønnene kommer i løpet av dagen
  static const List<String> prayerOrder = [
    'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
  ];

  const _PrayerCard({required this.timings});


  // getNextPrayer() finner hvilken bønn som kommer nå.
  //
  // Logikk:
  //   1. Hent nåværende tid fra telefonen
  //   2. Gå gjennom bønnene i rekkefølge
  //   3. Den første bønnen som IKKE er passert = neste bønn
  //   4. Hvis alle er passert → neste er Fajr i morgen
  String getNextPrayer(Map<String, dynamic> timings) {
    final now = TimeOfDay.now();

    for (final prayer in prayerOrder) {
      final time  = timings[prayer];     // f.eks. "17:37"
      final parts = time.split(':');     // ["17", "37"]
      final hour  = int.parse(parts[0]); // 17
      final minute = int.parse(parts[1]); // 37

      // Har denne bønnen IKKE passert ennå?
      if (now.hour < hour || (now.hour == hour && now.minute < minute)) {
        return prayer; // dette er neste bønn!
      }
    }

    // Alle bønner for i dag er passert
    // → neste er Fajr tidlig i morgen
    return 'Fajr';
  }

  // getTimeUntilNextPrayer() beregner hvor lenge det er til neste bønn.
  //
  // Logikk:
  //   1. Hent nåværende tid
  //   2. Hent tidspunkt for neste bønn
  //   3. Regn ut differansen i minutter
  //   4. Gjør om til "1h 23m" format
  String getTimeUntilNextPrayer(String nextPrayer) {
    final now = DateTime.now();

    // Hent time og minutt for neste bønn
    final parts  = timings[nextPrayer].split(':');
    final hour   = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Lag et DateTime-objekt for neste bønn i dag
    var prayerTime = DateTime(now.year, now.month, now.day, hour, minute);

    // Hvis bønnen er Fajr og den er passert → den er i morgen
    if (prayerTime.isBefore(now)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }

    // Regn ut differansen
    final diff = prayerTime.difference(now);
    final hours   = diff.inHours;
    final minutes = diff.inMinutes % 60; // resten etter hele timer

    // Returner lesbart format
    if (hours > 0) {
      return 'in ${hours}h ${minutes}m';
    } else {
      return 'in ${minutes}m';
    }
  }


  @override
  Widget build(BuildContext context) {

    // Beregn neste bønn FØR vi bygger UI-et
    final nextPrayer = getNextPrayer(timings);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Litt gjennomsiktig hvit på grønn bakgrunn
        // gir en fin "frosted glass"-effekt
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etikett øverst
          const Text(
            'NEXT PRAYER',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 8),

          // Navn på neste bønn (dynamisk basert på klokken)
          Text(
            nextPrayer,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Tidspunkt + nedtelling på samme linje
          Text(
            '${timings[nextPrayer]}  ·  ${getTimeUntilNextPrayer(nextPrayer)}',
            style: const TextStyle(color: kGold, fontSize: 16),
          ),

          const SizedBox(height: 16),

          // Alle fem bønner på én rad
          // isActive sjekker om denne bønnen er den neste
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PrayerChip(name: 'Fajr',    time: timings['Fajr'],    isActive: nextPrayer == 'Fajr'),
              _PrayerChip(name: 'Dhuhr',   time: timings['Dhuhr'],   isActive: nextPrayer == 'Dhuhr'),
              _PrayerChip(name: 'Asr',     time: timings['Asr'],     isActive: nextPrayer == 'Asr'),
              _PrayerChip(name: 'Maghrib', time: timings['Maghrib'], isActive: nextPrayer == 'Maghrib'),
              _PrayerChip(name: 'Isha',    time: timings['Isha'],    isActive: nextPrayer == 'Isha'),
            ],
          ),
        ],
      ),
    );
  }
}


// ═════════════════════════════════════════════════
// _PRAYERCHIP
//
// Liten widget som viser navn og tid for én bønn.
// Brukes 5 ganger i _PrayerCard – én per bønn.
//
// Eksempel på output:
//   Asr
//   17:37
// ═════════════════════════════════════════════════
class _PrayerChip extends StatelessWidget {
  final String name; // f.eks. "Asr"
  final String time; // f.eks. "17:37"
  final bool isActive;     // er dette neste bønn?

  const _PrayerChip({
    required this.name,
    required this.time,
    required this.isActive, // ← ny parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        // Gull-bakgrunn hvis aktiv, transparent hvis ikke
        color: isActive ? kGold : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Navn – mørk tekst hvis aktiv, grå hvis ikke
          Text(
            name,
            style: TextStyle(
              color: isActive ? kDarkGreen : Colors.white54,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          // Tid – mørk tekst hvis aktiv, hvit hvis ikke
          Text(
            time,
            style: TextStyle(
              color: isActive ? kDarkGreen : Colors.white,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════
// _QUICKCARD
//
// Gjenbrukbart snarvei-kort i Quick Access-rutenettet.
//
// Hvert kort har:
//   - Farget sirkel med ikon øverst
//   - Tittel og arabisk navn
//   - Pil som indikerer at det er klikkbart
//
// Ved å sende inn ulike farger og ikoner
// ser hvert kort unikt ut men koden er den samme.
// ═════════════════════════════════════════════════
class _QuickCard extends StatelessWidget {
  final String title;       // engelsk navn,  f.eks. "Umrah Guide"
  final String arabic;      // arabisk navn,  f.eks. "دليل العمرة"
  final IconData icon;      // ikon fra Flutter sitt ikonbibliotek
  final Color color;        // lys bakgrunnsfarge på selve kortet
  final Color iconColor;    // farge på sirkelen, ikonet og arabisk tekst
  final VoidCallback onTap; // funksjonen som kjøres når man trykker

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
      // GestureDetector lytter etter trykk og kaller onTap()
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

            // Sirkel med ikon øverst
            // withOpacity(0.15) = 15% av ikonfargen som bakgrunn
            // gir en subtil sirkel som matcher ikonets farge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),

            // Spacer() tar all ledig plass og skyver
            // teksten ned mot bunnen av kortet
            const Spacer(),

            // Engelsk tittel
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Arabisk tittel i samme farge som ikonet
            Text(
              arabic,
              style: TextStyle(color: iconColor, fontSize: 12),
            ),

            const SizedBox(height: 8),

            // Liten pil som viser at kortet er klikkbart
            Icon(
              Icons.arrow_forward_ios,
              color: iconColor.withOpacity(0.5),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}