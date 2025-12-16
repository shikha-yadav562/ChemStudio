import 'package:flutter/material.dart';
import 'group6_ct_MG.dart';
import '../d_intro.dart';


const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class saltDdetectiongroup6Page extends StatefulWidget {
  const saltDdetectiongroup6Page({super.key});

  @override
  State<saltDdetectiongroup6Page> createState() => _detectiongroup6PageState();
}

class _detectiongroup6PageState extends State<saltDdetectiongroup6Page> {
  String? selectedOptionPage1;
  String? selectedOptionPage2;
  bool showPage2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: primaryBlue),
    onPressed: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WetTestIntroDScreen()), // Replace with your actual class name in c_intro.dart
        (route) => false, // This clears the navigation stack
      );
    },
  ),
    
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: Text(
            'Salt D : Wet Test',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
      ),
      body: showPage2 ? _page2() : _page1(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _buildNavigationBar(),
      ),
    );
  }

  // ===== Gradient Header =====
  Widget _gradientHeader(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white),
      ),
    );
  }

  // ===== Bold teal text for inference (no gradient) =====
  Widget _inferenceTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: accentTeal,
        fontSize: 18,
      ),
    );
  }

  // ===== PAGE 1 =====
  Widget _page1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Group VI Detection",
            style: TextStyle(
                fontSize: 22,
                color: primaryBlue,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _gradientHeader("Test"),
                    const SizedBox(height: 6),
                    const Text(
                      "O.S / Filtrate + NH₄Cl (equal) + NH₄OH (till alkaline to litmus) + Na₂HPO₄",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    const Divider(height: 22),
                    _gradientHeader("Observation"),
                    const SizedBox(height: 6),
                    const Text(
                      "No ppt",
                      style: TextStyle(
                          fontSize: 15,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),

          const SizedBox(height: 14),

          // ===== Bold teal text above options =====
          _inferenceTitle("Select the correct inference"),
          const SizedBox(height: 10),

          _buildOption("Group-VI present", true),
          _buildOption("Group-VI absent", true),
        ],
      ),
    );
  }

  // ===== PAGE 2 =====
  Widget _page2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Analysis of Group VI",
            style: TextStyle(
                fontSize: 22,
                color: primaryBlue,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _gradientHeader("Test"),
                    const SizedBox(height: 6),
                    const Text(
                      "Group VI white ppt + dil. HCl",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    const Divider(height: 22),
                    _gradientHeader("Observation"),
                    const SizedBox(height: 6),
                    const Text(
                      "Clear solution is obtained",
                      style: TextStyle(
                          fontSize: 15,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),

          const SizedBox(height: 14),

          _inferenceTitle("Select the correct inference"),
          const SizedBox(height: 10),

          _buildOption("Mg²⁺ present", false),
        ],
      ),
    );
  }

  // ===== Option Buttons like reference =====
  Widget _buildOption(String text, bool isPage1) {
    final bool selected =
        isPage1 ? selectedOptionPage1 == text : selectedOptionPage2 == text;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isPage1) {
              selectedOptionPage1 = text;
            } else {
              selectedOptionPage2 = text;
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: selected ? accentTeal.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? accentTeal : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: selected ? accentTeal : Colors.black,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ===== Navigation Bar =====
  Widget _buildNavigationBar() {
    bool nextEnabled = showPage2
        ? selectedOptionPage2 != null
        : selectedOptionPage1 != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            if (showPage2) {
              setState(() {
                showPage2 = false;
                selectedOptionPage2 = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text("Previous"),
        ),
        ElevatedButton.icon(
          onPressed: nextEnabled
              ? () {
                  if (!showPage2 &&
                      selectedOptionPage1 == "Group-VI present") {
                    setState(() {
                      showPage2 = true;
                    });
                  } else if (showPage2 &&
                      selectedOptionPage2 == "Mg²⁺ present") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const group6ctMGPage()),
                    );
                  }
                }
              : null,
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text(
            "Next",
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                nextEnabled ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white, // ✅ keep text white even disabled
            shape: const StadiumBorder(),
          ),
        ),
      ],
    );
  }
}

