import 'package:ChemStudio/DB/database_helper.dart';
import 'package:flutter/material.dart';
import '../../welcome_screen.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class DryTestBScreen extends StatefulWidget {
  const DryTestBScreen({super.key});

  @override
  State<DryTestBScreen> createState() => _DryTestBScreenState();
}

class _DryTestBScreenState extends State<DryTestBScreen>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  final Map<int, String> _answers = {};
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;
  late final List<TestItem> _tests = _generateTests();

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fadeSlide =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _loadSavedAnswers();
    _animController.forward();
  }

  // ✅ Load saved answers from DB on startup
  Future<void> _loadSavedAnswers() async {
    final rows = await DatabaseHelper.instance.getAnswers('SaltB_DryTest');
    for (var row in rows) {
      _answers[row['question_id']] = row['answer'];
    }
    setState(() {});
  }

  static List<TestItem> _generateTests() {
    return [
      TestItem(
        id: 1,
        title: '1. Heating in a Dry Test Tube',
        procedure:
            'Take a small quantity of the mixture in a clean and dry test-tube and heat it strongly in an oxidising (blue) flame. Observe the change taking place.',
        observation: 'Coloured residue observed.\nCold: Yellow Hot: Brown',
        options: ['Co2+', 'Cu2+', 'Fe3+', 'Pb2+'],
        correct: 'Fe3+',
      ),
      TestItem(
        id: 2,
        title: '2. NaOH Test',
        procedure:
            'Mix the salt with NaOH solution and heat gently. Hold moist turmeric paper near the mouth of the tube.',
        observation: 'Moist turmeric paper turns brown/red.',
        options: ['NH4+ Present', 'NH4+ Absent'],
        correct: 'NH4+ Present',
      ),
      TestItem(
        id: 3,
        title: '3. Flame Test',
        procedure:
            'Prepare a paste of the salt with conc. HCl. Dip a platinum wire or glass rod in it and place it in an oxidising flame. Observe the colour.',
        observation: 'Bluish white flame observed.',
        options: [
          'Ca2+ may be present',
          'Ba2+ may be present',
          'Sr2+ may be present',
          'Pb2+ may be present',
          'Cu2+ may be present'
        ],
        correct: 'Cu2+ may be present',
      ),
    ];
  }

  void _next() {
    if (_index < _tests.length - 1) {
      setState(() {
        _index++;
        _animController.forward(from: 0);
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SaltBResultScreen(
            userAnswers: _answers,
            tests: _tests,
          ),
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
            'Salt B : Dry Tests',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeSlide,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.1, 0.03), end: Offset.zero)
                  .animate(_fadeSlide),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(test.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTestCard(test),
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
                              fontWeight: FontWeight.bold),
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
                              await DatabaseHelper.instance
                                  .saveAnswer('SaltB_DryTest', test.id, opt);
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
        Text('Coloured Residue', style: TextStyle(color: primaryBlue)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(children: [
                Image.asset('assets/images/pic_a.png',
                    height: 160,
                    errorBuilder: (_, __, ___) =>
                        const PlaceholderImage(label: 'Pic A (Hot : Brown)')),
                const SizedBox(height: 4),
                const Text('🔥 Hot : Brown',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.brown)),
              ]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(children: [
                Image.asset('assets/images/pic_b.png',
                    height: 160,
                    errorBuilder: (_, __, ___) =>
                        const PlaceholderImage(label: 'Pic B (Cold : Yellow)')),
                const SizedBox(height: 4),
                const Text('❄️ Cold : Yellow',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 183, 0))),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _naohObservation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Icon(Icons.science_rounded, size: 60, color: accentTeal),
            const SizedBox(height: 8),
            Text(
              'Test Tube + NaOH',
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 40),
        Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.amber.shade200,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.shade700, width: 2),
              ),
              child: const Center(
                child: Text(
                  'Turns red/brown',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text('Moist Turmeric Paper'),
          ],
        ),
      ],
    );
  }

  Widget _flameObservation() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            Container(
              width: 60,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.elliptical(60, 100)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 2)
                ],
              ),
            ),
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(8)),
              child: const Center(
                  child: Icon(Icons.fireplace, size: 20, color: Colors.white)),
            )
          ]),
          const SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 60),
            Text('Bluish White',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 84, 79, 137))),
            const Text('Characteristic Flame Colour'),
          ])
        ]),
      ],
    );
  }
}

class SaltBResultScreen extends StatelessWidget {
  final Map<int, String> userAnswers;
  final List<TestItem> tests;

  const SaltBResultScreen({
    super.key,
    required this.userAnswers,
    required this.tests,
  });

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
            'Salt B : Test Summary',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
      ),
      body: Padding(
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
                children: tests.map((test) {
                  final ans = userAnswers[test.id] ?? 'No answer selected';
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
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: const Icon(Icons.assignment_turned_in_rounded,
                            color: accentTeal, size: 28),
                        title: Text(test.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(ans,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: primaryBlue)),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()));
              },
              icon: const Icon(Icons.home_rounded, color: Colors.white),
              label: const Text('Back to Home',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: primaryBlue,
                shadowColor: accentTeal.withOpacity(0.4),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- MODEL + PLACEHOLDER ---------- */
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
