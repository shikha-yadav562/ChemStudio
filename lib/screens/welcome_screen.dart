import 'dart:ui';
import 'package:flutter/material.dart';

// Preliminary test screens
import 'DRY TEST/A/preliminary_test_A.dart';
import 'DRY TEST/C/preliminary_test_C.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? selectedSalt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/chemstudio_logo.png', height: 55),
            const SizedBox(width: 3),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [accentTeal, primaryBlue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "ChemStudio",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCardWrapper("A", "Salt A"),
                      const SizedBox(width: 16),
                      _buildCardWrapper("B", "Salt B"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCardWrapper("C", "Salt C"),
                      const SizedBox(width: 16),
                      _buildCardWrapper("D", "Salt D"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper(String letter, String title) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth:  300,  // slightly bigger
        minWidth:  240,  // slightly bigger
        maxHeight: 260, // slightly bigger
      ),
      child: _buildSaltCard(letter, title),
    );
  }

  Widget _buildSaltCard(String letter, String title) {
    bool isSelected = selectedSalt == letter;

    return GestureDetector(
      onTap: () {
        setState(() => selectedSalt = letter);

        Future.delayed(const Duration(milliseconds: 200), () {
          Widget? targetPage;

          switch (letter) {
            case "A":
              targetPage = const PreliminaryTestAScreen();
              break;
            case "B":
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Salt B screen not added yet")),
              );
              return;
            case "C":
              targetPage = const PreliminaryTestCScreen();
              break;
            case "D":
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Salt D screen not added yet")),
              );
              return;
          }

          if (targetPage != null) {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => targetPage!,
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            );
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accentTeal, primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  letter,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : primaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : primaryBlue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

