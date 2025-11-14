import 'package:ChemStudio/DB/database_helper.dart';
import 'package:flutter/material.dart';
import '../../welcome_screen.dart';
import 'package:ChemStudio/screens/DRY_TEST/A/preliminary_test_a.dart'; // ✅ Import Preliminary Test screen

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class DryTestAScreen extends StatefulWidget {
  const DryTestAScreen({super.key});

  @override
  State<DryTestAScreen> createState() => _DryTestAScreenState();
}

class _DryTestAScreenState extends State<DryTestAScreen>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  final Map<int, String> _answers = {};
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;
  late final List<TestItem> _tests = _generateTests();

  final dbHelper = DatabaseHelper.instance;
  final String tableName = 'SaltA_DryTest';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeSlide =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();

    _loadSavedAnswers(); // ✅ only load, don’t clear
  }

  Future<void> _loadSavedAnswers() async {
    final data = await dbHelper.getAnswers(tableName);
    if (data.isNotEmpty) {
      setState(() {
        for (var row in data) {
          _answers[row['question_id']] = row['answer'];
        }
      });
    }
  }

  static List<TestItem> _generateTests() {
    return [
      TestItem(
        id: 1,
        title: '1. Heating in a Dry Test Tube',
        procedure:
            'Take a small quantity of the mixture in a clean and dry test-tube and heat it strongly in an oxidising (blue) flame. Observe the change taking place.',
        observation: 'Coloured residue observed.\nCold: Blue Hot: White',
        options: ['Co2+', 'Fe3+', 'Cu2+', 'Pb2+'],
        correct: 'Cu2+', // ✅ Added
      ),
      TestItem(
        id: 2,
        title: '2. NaOH Test',
        procedure:
            'Mix the salt with NaOH solution and heat gently. Hold moist turmeric paper near the mouth of the tube.',
        observation: 'Moist turmeric paper turns brown/red',
        options: ['NH4+ Present', 'NH4+ Absent'],
        correct: 'NH4+ Present', // ✅ Added
      ),
      TestItem(
        id: 3,
        title: '3. Flame Test',
        procedure:
            'Prepare a paste of the salt with conc. HCl. Dip a platinum wire or glass rod in it and place it in an oxidising flame. Observe the colour.',
        observation: 'Bluish Green flame observed.',
        options: [
          'Ca2+ may be present',
          'Ba2+ may be present',
          'Sr2+ may be present',
          'Pb2+ may be present',
          'Cu2+ may be present'
        ],
        correct: 'Cu2+ may be present', // ✅ Added
      ),
    ];
  }

  Future<void> _saveAnswer(int questionId, String answer) async {
    await dbHelper.saveAnswer(tableName, questionId, answer);
  }

  void _next() async {
    if (_index < _tests.length - 1) {
      setState(() {
        _index++;
        _animController.forward(from: 0);
      });
    } else {
      // ✅ Make sure DB writes are done
      await Future.delayed(const Duration(milliseconds: 200));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SaltAResultScreen(userAnswers: _answers, tests: _tests),
        ),
      );
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _animController.forward(from: 0);
      });
    } else {
      // ✅ FIX: Navigate back to the PreliminaryTestAScreen at index 1 (Nature Test)
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Pass initialIndex: 1 to load the second page (Nature Test)
          builder: (_) => const PreliminaryTestAScreen(initialIndex: 1), 
        ),
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
            'Salt A : Dry Tests',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeSlide,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.1, 0.03),
            end: Offset.zero,
          ).animate(_fadeSlide),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  test.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTestCard(test),
                      const SizedBox(height: 24),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            const LinearGradient(colors: [accentTeal, primaryBlue])
                                .createShader(bounds),
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
                            onTap: () {
                              setState(() {
                                _answers[test.id] = opt;
                              });
                              _saveAnswer(test.id, opt);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selectedHere
                                    ? accentTeal.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedHere
                                      ? accentTeal
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontWeight: selectedHere
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selectedHere
                                      ? accentTeal
                                      : Colors.black87,
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
                      label: const Text('Previous'),
                    ),
                    ElevatedButton.icon(
                      onPressed: selected != null ? _next : null,
                      icon: Icon(_index == _tests.length - 1
                          ? Icons.check_circle_outline
                          : Icons.arrow_forward),
                      label: Text(
                          _index == _tests.length - 1 ? 'Finish' : 'Next'),
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
        ),
      ),
    );
  }

  Widget _buildTestCard(TestItem test) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader('Procedure'),
            const SizedBox(height: 4),
            Text(test.procedure, style: const TextStyle(fontSize: 14)),
            const Divider(height: 24),
            _gradientHeader('Observation'),
            const SizedBox(height: 8),
            if (test.id == 1) _heatingObservation(),
            if (test.id == 2) _naohObservation(),
            if (test.id == 3) _flameObservation(),
          ],
        ),
      ),
    );
  }

  Widget _gradientHeader(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
Widget _heatingObservation() {
  return Column(
    children: [
      Text(
        'Coloured Residue',
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 12),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 🔥 HOT IMAGE + LABEL
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/pic_a.png',
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                    const PlaceholderImage(label: 'Pic A (Hot : White)'),
                ),
                const SizedBox(height: 6),

                // 🔥 HOT TEXT with background
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE8D8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '🔥 HOT : WHITE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ❄️ COLD IMAGE + LABEL
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/pic_b.png',
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                    const PlaceholderImage(label: 'Pic B (Cold : Blue)'),
                ),
                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3EEFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '❄️ COLD : BLUE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 3, 66, 255),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
Widget _naohObservation() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Ensures image is always visible and properly scaled
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,  // Prevents extra shrinking on big screens
            minWidth: 250,
            maxHeight: 250,  
          ),
          child: Image.asset(
            'assets/images/turmeric_red.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const PlaceholderImage(label: 'turmeric_red.png'),
          ),
        ),
      ),

      const SizedBox(height: 15),

      // Clean and readable text
      const Text(
        'Moist turmeric paper remains as it is on exposure to gas.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ],
  );
}


// MODIFIED WIDGET: _flameObservation()
  Widget _flameObservation() {
    return Center( 
      child: Column(
        children: [
          Image.asset(
            'assets/images/flame_bluishgreen.png',
            height: 160, // Match sizing convention of other observations
            errorBuilder: (_, __, ___) =>
                const PlaceholderImage(label: 'flame_bluishgreen.png'),
          ),
          
          // 2. Remove all old flame-related text/widgets.
          const SizedBox(height: 12), // Match padding convention of other observations
          
          // 3. Display this exact text below the image
          Text(
            'Bluish Green flame', // EXACT text requested
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryBlue, // Match text style convention
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// ✅ Corrected Result Screen name (SaltAResultScreen)
class SaltAResultScreen extends StatefulWidget {
  final Map<int, String> userAnswers;
  final List<TestItem> tests;

  const SaltAResultScreen({
    super.key,
    required this.userAnswers,
    required this.tests,
  });

  @override
  State<SaltAResultScreen> createState() => _SaltAResultScreenState();
}

class _SaltAResultScreenState extends State<SaltAResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
            'Salt A: Test Summary',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeCtrl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Selected Answers:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: widget.tests.map((test) {
                    final ans =
                        widget.userAnswers[test.id] ?? 'No answer selected';
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [accentTeal, primaryBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          leading: const Icon(
                            Icons.assignment_turned_in_rounded,
                            color: accentTeal,
                            size: 28,
                          ),
                          title: Text(
                            test.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              ans,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  );
                },
                icon: const Icon(Icons.home_rounded, color: Colors.white),
                label: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: primaryBlue,
                  shadowColor: accentTeal.withOpacity(0.4),
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Model ----------
class TestItem {
  final int id;
  final String title;
  final String procedure;
  final String observation;
  final List<String> options;
  final String correct;

  TestItem({
    required this.id,
    required this.title,
    required this.procedure,
    required this.observation,
    required this.options,
    required this.correct,
  });
}

class PlaceholderImage extends StatelessWidget {
  final String label;
  const PlaceholderImage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600)),
      ),
    );
  }
}