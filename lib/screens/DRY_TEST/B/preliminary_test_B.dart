import 'package:ChemStudio/screens/DRY_TEST/B/dry_test_B.dart';
import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class PreliminaryTestBScreen extends StatefulWidget {
  const PreliminaryTestBScreen({super.key});

  @override
  State<PreliminaryTestBScreen> createState() => _PreliminaryTestBScreenState();
}

class _PreliminaryTestBScreenState extends State<PreliminaryTestBScreen> {
  int _index = 0;
  final Map<int, String> _answers = {};

  final List<TestItem> _tests = [
    TestItem(
      id: 1,
      title: "1. Preliminary Test – Colour",
      observation: "White",
      options: ["Fe3+", "Cu2+", "Mn2+", "Pb2+"],
      correct: "Pb2+",
    ),
    TestItem(
      id: 2,
      title: "2. Nature Test – Solubility",
      observation: "Water Soluble",
      options: ["Crystalline", "Amorphous"],
      correct: "Crystalline",
    ),
  ];

  void _next() {
    if (_index < _tests.length - 1) {
      setState(() => _index++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DryTestBScreen()),
      );
    }
  }

  void _prev() {
    if (_index > 0) setState(() => _index--);
  }

  @override
  Widget build(BuildContext context) {
    final test = _tests[_index];
    final selected = _answers[test.id];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [accentTeal, primaryBlue],
          ).createShader(bounds),
          child: const Text(
            "Salt B: Preliminary Test",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              test.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildObservationCard(test),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [accentTeal, primaryBlue],
                    ).createShader(bounds),
                    child: const Text(
                      'Based on the observation, select the correct inference:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...test.options.map((opt) {
                    final selectedHere = selected == opt;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: InkWell(
                        onTap: () => setState(() => _answers[test.id] = opt),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectedHere
                                ? accentTeal.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: selectedHere
                                  ? accentTeal
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontWeight: selectedHere
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  selectedHere ? accentTeal : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _prev,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Previous"),
                ),
                ElevatedButton.icon(
                  onPressed: selected != null ? _next : null,
                  icon: Icon(
                    _index == _tests.length - 1
                        ? Icons.check_circle_outline
                        : Icons.arrow_forward,
                  ),
                  label: Text(
                    _index == _tests.length - 1 ? "Proceed to Dry Test" : "Next",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservationCard(TestItem test) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [accentTeal, primaryBlue],
              ).createShader(bounds),
              child: const Text(
                "Observation:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (test.id == 1)
              _buildDarkBrownRectangle()
            else
              Row(
                children: [
                  const Icon(Icons.water_drop, color: accentTeal, size: 50),
                  const SizedBox(width: 10),
                  Text(
                    test.observation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkBrownRectangle() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 254, 255, 255), Color.fromARGB(255, 254, 255, 255)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 183, 183, 183).withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: const Center(
        child: Text(
          "White",
          style: TextStyle(
            color: Color.fromARGB(255, 48, 47, 47),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class TestItem {
  final int id;
  final String title;
  final String observation;
  final List<String> options;
  final String correct;

  TestItem({
    required this.id,
    required this.title,
    required this.observation,
    required this.options,
    required this.correct,
  });
}
