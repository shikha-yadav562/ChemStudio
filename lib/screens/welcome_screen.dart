import 'dart:ui';
import 'package:flutter/material.dart';

// Preliminary test screens
import 'DRY_TEST/A/preliminary_test_A.dart';
import 'DRY_TEST/C/preliminary_test_C.dart';
import 'DRY_TEST/D/preliminary_test_D.dart';

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
          mainAxisSize: MainAxisSize.min, // keeps items tight
          children: [
            Image.asset('assets/images/chemstudio_logo.png', height: 55),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;

              
                  double cardWidth;
                  double cardHeight;

                  if (width >= 1000) {
                    // Desktop
                   
                    cardWidth = 280;
                    cardHeight = 260;
                  } else if (width >= 600) {
                    // Tablet
                  
                    cardWidth = 220;
                    cardHeight = 220;
                  } else {
                    // Mobile
               
                    cardWidth = 150;
                    cardHeight = 150;
                  }

                  return Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildSaltCard("A", "Salt A", cardWidth, cardHeight),
                        _buildSaltCard("B", "Salt B", cardWidth, cardHeight),
                        _buildSaltCard("C", "Salt C", cardWidth, cardHeight),
                        _buildSaltCard("D", "Salt D", cardWidth, cardHeight),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaltCard(String letter, String title, double width, double height) {
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
              targetPage = const PreliminaryTestDScreen();
              break;
             
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
        width: width,
        height: height,
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
