import 'package:flutter/material.dart';
import '../group_5/new_1.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class Co2ConfirmedPage extends StatefulWidget {
  const Co2ConfirmedPage({super.key});

  @override
  State<Co2ConfirmedPage> createState() => _Co2ConfirmedPageState();
}

class _Co2ConfirmedPageState extends State<Co2ConfirmedPage> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Salt A : Wet Test',
          style: TextStyle(
              color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: _buildContent(),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
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
          "C.T For Co²⁺",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // SOLUTION CARD
        _solutionCard(),

        const SizedBox(height: 12),

        // TEST CARD
        _testCard(),

        const SizedBox(height: 20),
        _gradientHeader("Select the correct inference:"),
        const SizedBox(height: 10),

        _buildOption("Co²⁺ Confirmed"),
      ],
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('Previous', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton.icon(
          onPressed: isSelected
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GroupVPage(),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: const StadiumBorder(),
          ),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  // SOLUTION CARD
  Widget _solutionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader("Solution"),
            const SizedBox(height: 6),
            const Text(
              "Dissolve the black ppt of group IV in aquaregia "
              "(conc. HCL + conc. HNO3 in 3:1 proportion) dilute with water. "
              "Use this solution for C.T.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold, // same as observation
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TEST CARD
  Widget _testCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader("Test"),
            const SizedBox(height: 4),
            const Text(
              "Above solution + NH4CNS + acetone, shake well",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black, // test content black
              ),
            ),
            const Divider(height: 22),

            _gradientHeader("Observation"),
            const SizedBox(height: 6),

            const Text(
              "Blue colour",
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

  // OPTION
  Widget _buildOption(String text) {
    return InkWell(
      onTap: () => setState(() => isSelected = true),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? accentTeal.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? accentTeal : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? accentTeal : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _gradientHeader(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [accentTeal, primaryBlue],
      ).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
