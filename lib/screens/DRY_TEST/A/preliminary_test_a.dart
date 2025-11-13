import 'package:ChemStudio/DB/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:ChemStudio/screens/DRY_TEST/A/dry_test_a.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class PreliminaryTestAScreen extends StatefulWidget {
  // ✅ 1. Add required field for initial index
  final int initialIndex; 

  // ✅ 2. Update constructor to accept initialIndex, defaulting to 0
  const PreliminaryTestAScreen({super.key, this.initialIndex = 0}); 

  @override
  State<PreliminaryTestAScreen> createState() => _PreliminaryTestAScreenState();
}

class _PreliminaryTestAScreenState extends State<PreliminaryTestAScreen> {
  // ✅ 3. Change initialization to use widget.initialIndex
  late int _index;
  final Map<int, String> _answers = {};
  final _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex; // ✅ Initialize _index with the provided value
   // _clearPreviousAnswers();
  }

/*Future<void> _clearPreviousAnswers() async {
  await _dbHelper.clearTest('SaltA_PreliminaryTest');
}*/

  final List<TestItem> _tests = [
    TestItem(
      id: 1,
      title: "1. Preliminary Test – Colour",
      observation: "Blue",
      options: ["Fe3+", "Cu2+", "Mn2+", "Co2+"],
      correct: "Cu2+",
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
        MaterialPageRoute(builder: (_) => const DryTestAScreen()),
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
            "Salt A: Preliminary Test",
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
                        onTap: () async {
                          setState(() => _answers[test.id] = opt);
                          // ✅ save to correct table
                          await _dbHelper.saveAnswer(
                            'SaltA_PreliminaryTest',
                            test.id,
                            opt,
                          );
                        },
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
              // Pushes the "Next" button to the end when on the first page (_index == 0) 
              // and spaces them out otherwise.
              mainAxisAlignment: (_index == 0)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                // CONDITIONALLY HIDES "Previous" BUTTON ON FIRST PAGE (_index == 0)
                if (_index > 0)
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
                    _index == _tests.length - 1
                        ? "Proceed to Dry Test"
                        : "Next",
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
          colors: [
            Color.fromARGB(255, 37, 45, 100),
            Color.fromARGB(255, 24, 30, 101)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 45, 38, 124).withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: const Center(
        child: Text(
          "Blue",
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