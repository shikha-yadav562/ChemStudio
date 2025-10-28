import 'package:flutter/material.dart';
import 'package:ChemStudio/screens/DRY_TEST/D/dry_test_d.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class PreliminaryTestDScreen extends StatefulWidget {
  const PreliminaryTestDScreen({super.key});

  @override
  State<PreliminaryTestDScreen> createState() => _PreliminaryTestDScreenState();
}

class _PreliminaryTestDScreenState extends State<PreliminaryTestDScreen> {
  int _index = 0;
  final Map<int, String> _answers = {};


  final List<TestItem> _tests = [
    TestItem(
      id: 1,
      title: "1. Preliminary Test – Colour",
      observation: "Bluish Green",
      options: ["Ni2+", "Cu2+", "Mn2+", "Co2+"],
      correct: "Ni2+",
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
        MaterialPageRoute(builder: (_) => const DryTestDScreen()),
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
            "Salt D: Preliminary Test",
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
              _buildBluishGreenRectangle()
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

  Widget _buildBluishGreenRectangle() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient:  LinearGradient(
          colors: [Colors.blue.shade200, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade400.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: const Center(
        child: Text(
          "Bluish Green",
          style: TextStyle(
            color: Colors.white,
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
