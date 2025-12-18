// group5_analysis.dart
import 'package:ChemStudio/DB/database_helper.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_5/group5_BA_ct.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_5/group5_CA_ct.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_5/group5_SR_ct.dart';
import 'package:flutter/material.dart';
import '../group0/group0analysis.dart';
import '../c_intro.dart';

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class Group5AnalysisScreen extends StatefulWidget {
  const Group5AnalysisScreen({super.key});

  @override
  State<Group5AnalysisScreen> createState() => _Group5AnalysisScreenState();
}

class _Group5AnalysisScreenState extends State<Group5AnalysisScreen>
    with SingleTickerProviderStateMixin {
  final int _index = 0;
  String? _selectedOption;

  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltC_WetTest';

  late final List<WetTestItem> _tests = [
    WetTestItem(
      id: 9, // Same ID as detection
      title: 'Analysis of Group V',
      procedure: 'Above solution + K₂CrO₄',
      observation: 'Yellow ppt',
      options: ['Ba²⁺ may be present', 'Ca²⁺ may be present', 'Sr²⁺ may be present'],
      correct: 'Ba²⁺ may be present',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeSlide = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _loadSavedAnswers();
    _animController.forward();
  }

  Future<void> _loadSavedAnswers() async {
    final data = await _dbHelper.getAnswers(_tableName);

    final testId = _tests[_index].id;
    String? savedAnswer;

    for (final row in data) {
      if (row['question_id'] == testId) {
        savedAnswer = row['student_answer'] as String?;
        break;
      }
    }

    setState(() {
      _selectedOption = savedAnswer;
    });
  }

  Future<void> _onOptionSelected(WetTestItem test, String selected) async {
    setState(() => _selectedOption = selected);

    // ✅ ONLY save student answer - nothing else!
    await _dbHelper.saveStudentAnswer(_tableName, test.id, selected);
  }

  void _next() {
    if (_selectedOption == null) return;

    if (_selectedOption == 'Ba²⁺ may be present') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Group5CTBaScreen (),
        ),
      );
    } else if (_selectedOption == 'Ca²⁺ may be present') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const  Group5CTCaScreen (),
        ),
      );
    } else if (_selectedOption == 'Sr²⁺ may be present') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Group5CTSrScreen (),
        ),
      );
    }
  }

  void _prev() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
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
              MaterialPageRoute(builder: (context) => const WetTestIntroCScreen()),
              (route) => false,
            );
          },
        ),
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
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: primaryBlue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSolutionCard(),
                      const SizedBox(height: 12),
                      _buildTestCard(test),
                      const SizedBox(height: 24),
                      _buildInferenceHeader(),
                      const SizedBox(height: 10),
                      ...test.options.map((opt) {
                        final selectedHere = _selectedOption == opt;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: InkWell(
                            onTap: () async {
                              setState(() => _selectedOption = opt);
                              await _onOptionSelected(test, opt);
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
                      }).toList(),
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
                      onPressed: _selectedOption != null ? _next : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
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

  Widget _buildInferenceHeader() {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: const Text(
        'Select the correct inference:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSolutionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader('Solution'),
            const SizedBox(height: 8),
            Text(
              'Dissolve the white ppt in hot acetic acid and use this (acetate) solution for further tests.',
              style: TextStyle(
                fontSize: 14,
                color: primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(WetTestItem test) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader('Test'),
            const SizedBox(height: 4),
            Text(test.procedure, style: const TextStyle(fontSize: 14)),
            const Divider(height: 24),
            _gradientHeader('Observation'),
            const SizedBox(height: 8),
            Text(
              test.observation,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}