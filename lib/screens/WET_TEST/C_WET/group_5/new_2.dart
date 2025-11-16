import 'package:flutter/material.dart';
import 'new_3.dart';
import 'new_4.dart';
import 'new_5.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class WetTestCGroupVPage2 extends StatefulWidget {
  const WetTestCGroupVPage2({super.key});

  @override
  State<WetTestCGroupVPage2> createState() => _WetTestCGroupVPage2State();
}

class _WetTestCGroupVPage2State extends State<WetTestCGroupVPage2> {
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
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: const Text(
            'Salt C : Wet Test ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      // Use SingleChildScrollView for the body content
      body: SingleChildScrollView(
        // Added bottom padding to ensure content is visible above the fixed navigation bar
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), 
        child: _buildContent(),
      ),
      // Fixed bottom navigation bar with customized buttons
      bottomNavigationBar: Container(
        color: Colors.transparent, // Transparent background (to avoid the white patch)
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _buildNavigationBar(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Analysis Group V ",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        _solutionCard(),
        const SizedBox(height: 12),
        _testCard(),
        const SizedBox(height: 20),

        ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: const Text(
            'Select the correct inference:',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),

        _buildOption("Ba²⁺ present"),
        _buildOption("Ca²⁺ present"),
        _buildOption("Sr²⁺ present"),
      ],
    );
  }

  // New method for the fixed navigation bar
  Widget _buildNavigationBar() {
    // Logic for "Next" button navigation
    VoidCallback? onNextPressed;
    if (selectedOption != null) {
      if (selectedOption == "Ba²⁺ present") {
        onNextPressed = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const New3Page()),
          );
        };
      } else if (selectedOption == "Ca²⁺ present") {
        onNextPressed = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const New4Page()),
          );
        };
      } else if (selectedOption == "Sr²⁺ present") {
        onNextPressed = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const New5Page()),
          );
        };
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous Button (TextButton.icon, styled to match image)
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('Previous', style: TextStyle(fontSize: 16)),
        ),

        // Next Button (ElevatedButton.icon with StadiumBorder for circular/pill shape)
        ElevatedButton.icon(
          onPressed: onNextPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedOption != null ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: const StadiumBorder(), // Circular/Pill shape
          ),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _solutionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Solution",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
            SizedBox(height: 6),
            Text(
              "Dissolve the white ppt in hot acetic acid and use this (acetate) solution for further tests.",
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: primaryBlue),
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
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Test",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
            SizedBox(height: 6),
            Text(
              "Above solution + K₂CrO₄",
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: primaryBlue),
            ),
            Divider(height: 22),
            Text("Observation",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
            SizedBox(height: 6),
            Text(
              "Yellow ppt",
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: primaryBlue),
            ),
          ],
        ),
      ),
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
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15),
          ),
        ),
      ),
    );
  }
}