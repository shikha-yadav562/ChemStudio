import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeLogo;
  late Animation<double> _fadeText;

  final Color primaryBlue = const Color(0xFF004C91);
  final Color accentTeal = const Color(0xFF00A6A6);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeLogo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    );

    _fadeText = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Background image
          Image.asset('assets/images/chem_bg.png', fit: BoxFit.cover),

          // ✅ Slight dark overlay
          Container(color: Colors.black.withOpacity(0.25)),

          // ✅ Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo fade animation
              FadeTransition(
                opacity: _fadeLogo,
                child: Image.asset(
                  'assets/images/chemstudio_logo.png',
                  width: size.width * 0.7, // Bigger logo
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10), // 👈 10px space between logo and name

              // Gradient "ChemStudio" text inside logo zone
              FadeTransition(
                opacity: _fadeText,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryBlue, accentTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "ChemStudio",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Needed for gradient mask
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // "Get Started" button
              FadeTransition(
                opacity: _fadeText,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: accentTeal.withOpacity(0.6),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
