import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/holy_sites.dart';
import '../models/holy_site.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Stedet som brukeren har valgt.
  HolySite selectedSite = holySites[0];
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Sites'),
      ),

    body: Column(
      children: [
        SizedBox(
        height: 300,

          // Kartet tar bare øverste del av skjermen.
          child: Stack(
            children: [
          FlutterMap(
          mapController: mapController,
            options: const MapOptions(
            initialCenter: LatLng(22.9, 39.7,), initialZoom: 6.5,),

          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.hajj_umrah_guide',
            ),

          MarkerLayer( //Kommentar: Markerlayer er laget for å vise markører på kartet. En markør representerer et spesifikt punkt på kartet, som kan være en plassering av interesse, et landemerke eller en annen viktig posisjon. I dette tilfellet brukes det til å vise en markør for et hellig sted.
            markers: holySites.map((site) {
              return Marker(
                point: LatLng(
                  site.latitude,
                  site.longitude,
                ),
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSite = site;
                    });
                  },
                  child: const Icon(
                    Icons.location_on,
                    // Fargen på markøren.
                    color: Color(0xFF062E22),
                    size: 32,
                  ),
                )
              );
            }).toList(),
          ),
          ],
          ), // FlutterMap

          // Knapp for å vise hele kartet igjen.
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton.small(
              heroTag: 'resetMap',
              onPressed: () {
                mapController.move(
                  const LatLng(22.9, 39.7),
                  6.5,
                );
              },
              child: const Icon(Icons.public),
            ),
          ),
            ], // Stack
          ), // Stack

        ), // SizedBox

        // Liste med knapper for de hellige stedene.
        SizedBox(
          height: 55,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            itemCount: holySites.length,
            itemBuilder: (context, index) {
              final site = holySites[index];

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedSite == site ? const Color(0xFF062E22) : Colors.white,
                    foregroundColor: selectedSite == site ? Colors.white : const Color(0xFF062E22),
                  ),

                  onPressed: () {
                    setState(() {
                      selectedSite = site;
                    });

                    mapController.move(
                      LatLng(site.latitude, site.longitude),
                      13, // Zoomnivået når et sted er valgt.
                    );
                  },
                  child: Text(site.name),
                ),
              );
            },
          ),
        ),

        // Viser informasjon om stedet som er valgt.
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedSite.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  selectedSite.arabicName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF062E22),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  selectedSite.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ], // Column
    ), // body
    ); // Scaffold
  }
}