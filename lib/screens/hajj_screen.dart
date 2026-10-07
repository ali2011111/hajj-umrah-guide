import 'package:flutter/material.dart';
import '../data/hajj_data.dart';

class HajjScreen extends StatefulWidget {
  const HajjScreen({super.key});

  @override
  State<HajjScreen> createState() => _HajjScreenState();
}

class _HajjScreenState extends State<HajjScreen> {
  @override
  Widget build (BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hajj Guide"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hajjDays.length,
        itemBuilder: (context, index) {
          final day = hajjDays[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            child: ExpansionTile(
              leading: Container(
                width: 45,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E7C5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  day.date,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062E22),
                  ),
                ),
              ),
              title: Text(
                day.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(day.location),

              // Viser aktivitetene når kortet åpnes
              children: day.activities.map((activity) {
                return ListTile(
                  leading: const Icon(
                    Icons.circle,
                    size: 8,
                  ),
                  title: Text(activity),
                );
              }).toList(),
            ),
          );
        }
      )
    );
  }
}