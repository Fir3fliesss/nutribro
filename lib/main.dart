// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/scan_screen.dart';

void main() {
  runApp(const NutriBroApp());
}

class NutriBroApp extends StatelessWidget {
  const NutriBroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriBro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScanScreen(),
    );
  }
}