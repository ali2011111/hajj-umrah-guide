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
          child: ListTile(
            title: Text('${day.date} · ${day.title}'),
            subtitle: Text(day.location),
          )
          ) ;
        }
      )
    );
  }
}