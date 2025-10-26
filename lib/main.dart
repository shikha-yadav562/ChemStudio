import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ChemStudioApp());
}

class ChemStudioApp extends StatelessWidget {
  const ChemStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChemStudio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004C91)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
