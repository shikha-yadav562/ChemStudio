import 'package:flutter/material.dart';
import '../group_6/group6detection_analysis.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class New3Page extends StatefulWidget {
  const New3Page({super.key});

  @override
  State<New3Page> createState() => _New3PageState();
}

class _New3PageState extends State<New3Page> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
            'Salt C : Wet Test',
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
              "C.T For Ba²⁺ ",
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
            _buildOption("Ba²⁺ confirmed"),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _buildNavigationBar(),
      ),
    );
  }

  // ---------------- SOLUTION CARD ----------------
  Widget _solutionCard() {
    return Card(
      elevation: 4,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              "Solution",
              gradient: LinearGradient(colors: [accentTeal, primaryBlue]),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),

            // ✅ Blue + Bold
            Text(
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

  // ---------------- TEST CARD ----------------
  Widget _testCard() {
    return Card(
      elevation: 4,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              "Test",
              gradient: LinearGradient(colors: [accentTeal, primaryBlue]),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),

            // ✅ BLACK normal text
            Text(
              "Above acetate solution + dil. H₂SO₄",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            Divider(height: 22),

            GradientText(
              "Observation",
              gradient: LinearGradient(colors: [accentTeal, primaryBlue]),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),

            // ✅ Blue + Bold
            Text(
              "White ppt",
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

  // ---------------- NAVIGATION ----------------
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
                          builder: (_) => const New1_1Page()));
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedOption != null
                ? primaryBlue
                : Colors.grey.shade400,
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

  // ---------------- OPTION ----------------
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
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? accentTeal : Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- GRADIENT TEXT ----------------
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(this.text,
      {required this.style, required this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
