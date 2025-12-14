import 'package:flutter/material.dart';
import '../group_5/new_1.dart';
import '../c_intro.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class Mn2ConfirmedPage extends StatefulWidget {
  const Mn2ConfirmedPage({super.key});

  @override
  State<Mn2ConfirmedPage> createState() => _Mn2ConfirmedPageState();
}

class _Mn2ConfirmedPageState extends State<Mn2ConfirmedPage> {
  String? selectedOption;

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
        MaterialPageRoute(builder: (context) => const WetTestIntroCScreen()), // Replace with your actual class name in c_intro.dart
        (route) => false, // This clears the navigation stack
      );
    },
  ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: const Text(
            'Salt C: Wet Test',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
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
          "C.T For Mn²⁺",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _solutionCard(),
        const SizedBox(height: 12),
        _testCard(),
        const SizedBox(height: 16),
        _gradientTitle("Select the correct inference:"),
        const SizedBox(height: 10),
        _buildOption("Mn²⁺ confirmed"),
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
          onPressed: selectedOption != null
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
            backgroundColor: selectedOption != null ? primaryBlue : Colors.grey.shade400,
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
              "Dissolve the Buff/flesh/pink ppt of group IV in dil. H₂S gas by boiling. "
              "Use this solution for C.T.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryBlue),
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
            _gradientHeader("Test"),
            const SizedBox(height: 6),
            const Text(
              "Above solution + PbO₂+ conc. HNO3 boil, cool, allow to settle",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
            ),
            const Divider(height: 22),
            _gradientHeader("Observation"),
            const SizedBox(height: 6),
            const Text(
              "Pink or violet colour",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryBlue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientTitle(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _gradientHeader(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
            color: selected ? accentTeal.withOpacity(0.12) : Colors.white,
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
