import 'package:flutter/material.dart';
import '../group_6/group6_detection.dart';
// 1. ADDED IMPORT for Intro Screen
import '../a_intro.dart'; 

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class saltAgroup5_CA_ct extends StatefulWidget {
  const saltAgroup5_CA_ct({super.key});

  @override
  State<saltAgroup5_CA_ct> createState() => _saltAgroup5_CA_ctState();
}

class _saltAgroup5_CA_ctState extends State<saltAgroup5_CA_ct> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,  
        elevation: 2,
        centerTitle: true,
        // 2. CUSTOM BACK ARROW LOGIC
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WetTestIntroAScreen(),
              ),
            );
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: Text(
            'Salt A : Wet Test',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "C.T For Sr²⁺",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _solutionCard(),
            const SizedBox(height: 12),
            _testCard(),
            const SizedBox(height: 12),
            _buildOption("Sr²⁺ confirmed"),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _buildNavigationBar(),
      ),
    );
  }

  // ✅ GRADIENT HEADING
  Widget _gradientHeaderText(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _solutionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeaderText("Solution"),
            const SizedBox(height: 6),

            // ✅ BLUE + BOLD (NO GRADIENT)
            const Text(
              "Dissolve the white ppt in hot acetic acid and use this (acetate) solution for further tests",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeaderText("Test"),
            const SizedBox(height: 6),

            // ✅ BLACK + NORMAL
            const Text(
              "Above acetate solution + dil. H₂SO₄",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),

            const Divider(height: 22),

            _gradientHeaderText("Observation"),
            const SizedBox(height: 6),

            // ✅ BLUE + BOLD
            const Text(
              "White ppt on warming",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('Previous', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton.icon(
          onPressed: selectedOption != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const saltA_Group6Detection()),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedOption != null ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: const StadiumBorder(),
          ),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildOption(String text) {
    final bool selected = selectedOption == text;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => setState(() => selectedOption = text),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? accentTeal.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? accentTeal : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? accentTeal : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}