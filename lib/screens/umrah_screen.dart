import 'package:flutter/material.dart';

class UmrahScreen extends StatelessWidget {
  const UmrahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Umrah Guide"),
      ),
      body: const Center(
        child: Text(
          "Step-by-step Umrah Guide",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}