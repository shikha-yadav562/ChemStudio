import 'package:flutter/material.dart';
import '../../welcome_screen.dart'; // Import for Home button

// TEAM MEMBER (DATABASE/LOGIC) TASK: 
import 'package:ChemStudio/screens/WET_TEST/C_WET/group0/group0analysis.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group1/group1detection.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group2/group2detection.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group3/group3detection.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_4/group4_detection.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_5/group5_detection.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_6/group6_detection.dart';
//  1. Import all 14 analysis/detection screen files here.
//  2. Example: import 'group1/lead_analysis.dart';


// Theme Colors
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class ResultCScreen extends StatelessWidget {
  /* DATABASE INTEGRATION:
    Currently, these have default values (Hardcoded).
    Your team member will eventually pass the values fetched from the 
    database into these variables when navigating to this page.
  */
  final String cation1;
  final String cation2;

  const ResultCScreen({
    super.key,
    this.cation1 = "NH₄⁺", // Default for UI testing
    this.cation2 = "Cu²⁺",      // Default for UI testing
  });

  /// REGISTRY: This is the core navigation logic.
  /// It maps the "String" name of the ion to the "Widget" (Screen) it belongs to.
  Map<String, Widget> _getNavigationRegistry(BuildContext context) {
    return {
      /* TEAM MEMBER TASK: 
        Add all 14 ions here. Ensure the String key exactly matches 
        the text displayed in the cards.
      */
      "NH₄⁺": const WetTestCGroupOneScreen(), 
      "Pb²⁺": const WetTestCGroupOneDetectionScreen(),
      "Cu²⁺": const WetTestCGroupTwoDetectionScreen(),
      "As³⁺": const WetTestCGroupTwoDetectionScreen(),
      "Al³⁺": const WetTestCGroupThreeDetectionScreen(),
      "Fe³⁺": const WetTestCGroupThreeDetectionScreen(),
      "Co²⁺": const Group4DetectionScreen(),
      "Mn²⁺": const Group4DetectionScreen(),
      "Ni²⁺": const Group4DetectionScreen(),
      "Zn²⁺": const Group4DetectionScreen(),
      "Ba²⁺": const Group5DetectionScreen(),
      "Ca²⁺": const Group5DetectionScreen(),
      "Sr²⁺": const Group5DetectionScreen(),
      "Mg²⁺": const Group6Detection(),

      // "Copper (Cu²⁺)": const Group2AnalysisPage(),
      // "Aluminum (Al³⁺)": const Group3AnalysisPage(),
      // ... and so on for all 14
    };
  }

  /// HELPER FUNCTION: Handles the click on an Ion card
  void _handleIonTap(BuildContext context, String ionName) {
    final registry = _getNavigationRegistry(context);
    final destination = registry[ionName];

    if (destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    } else {
      // Show an error if the ion isn't mapped yet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Analysis page for $ionName is not yet linked.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevents going back to the test
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
            'Results',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Icon(Icons.verified_rounded, size: 70, color: accentTeal),
            const SizedBox(height: 20),
            const Text(
              "The given inorganic mixture contains the following two cations (basic radicals):",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF0A4A78),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),

            // ION CARD 1
            _resultCard(context, "1.", cation1),
            const SizedBox(height: 15),

            // ION CARD 2
            _resultCard(context, "2.", cation2),

            const Spacer(),

            // Footer info
            const Text(
              "Tap an ion to review its group analysis",
              style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),

            // BACK TO HOME BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_filled, color: Colors.white),
                label: const Text(
                  "BACK TO HOME",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REUSABLE CLICKABLE CARD COMPONENT
  Widget _resultCard(BuildContext context, String index, String ionName) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleIonTap(context, ionName), // Navigation trigger
        borderRadius: BorderRadius.circular(15),
        splashColor: accentTeal.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                index,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accentTeal),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  ionName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryBlue),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}