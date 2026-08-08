import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DaleelApp());
}

class DaleelApp extends StatelessWidget {
  const DaleelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daleel',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}