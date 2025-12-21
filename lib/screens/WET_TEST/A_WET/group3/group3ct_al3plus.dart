// E:\flutter chemistry\wet\wet\lib\C\group3\group3ct_al3plus.dart
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_4/group4_detection.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../a_intro.dart'; // Import for the intro page
import '../group0/group0analysis.dart';

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class WetTestAGroupThreeCTAlScreen extends StatefulWidget {
  const WetTestAGroupThreeCTAlScreen({super.key});

  @override
  State<WetTestAGroupThreeCTAlScreen> createState() =>
      _WetTestAGroupThreeCTAlScreenState();
}

class _WetTestAGroupThreeCTAlScreenState extends State<WetTestAGroupThreeCTAlScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedOption;
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltC_WetTest';

  static const String SOLUTION_PREPARATION = 
    'Dissolve the group 3 ppt in dil. HCl and use this solution for C.T.';

  late final WetTestItem _test = WetTestItem(
      id: 12, 
      title: 'C.T for Al³⁺',
      procedure: 'Above Solution + few drops of NaOH and warm',
      observation: 'White gelatinous ppt (Soluble in excess of NaOH)',
      options: ['Al³⁺ confirmed'],
      correct: 'Al³⁺ confirmed',
  );

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 450),
    );
    _fadeSlide = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _loadSavedAnswer();
    _animController.forward();
  }

  Future<void> _loadSavedAnswer() async {
    final data = await _dbHelper.getAnswers(_tableName);
    setState(() {
        final savedAnswer = data.firstWhereOrNull(
            (row) => row['question_id'] == _test.id)?['answer'];
        _selectedOption = savedAnswer;
    });
  }

  Future<void> _saveAnswer(int id, String answer) async {
    await _dbHelper.saveAnswer(_tableName, id, answer);
  }

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Group4DetectionScreen(), 
      ),
    );
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

  Widget _buildGradientHeader(String text) {
    return ShaderMask(
        shaderCallback: (bounds) =>
            const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
        child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
    );
  }

  Widget _buildSolutionBox(String content) {
    return Card(
      elevation: 4, 
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradientHeader('Solution Preparation'), 
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
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

  Widget _buildTestCard(String testProcedure, String observation) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradientHeader('Test'),
            const SizedBox(height: 4),
            Text(testProcedure, style: const TextStyle(fontSize: 14)),
            const Divider(height: 24),
            _buildGradientHeader('Observation'),
            const SizedBox(height: 8),
            Text(
              observation,
              style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
            // --- Added navigation back to Intro ---
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryBlue),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WetTestIntroAScreen()),
                  (route) => false,
                );
              },
            ),
            title: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
                child: Text( 
                    'Salt A : Wet Test',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                ),
            ),
        ),
        body: FadeTransition(
            opacity: _fadeSlide,
            child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.1, 0.03), end: Offset.zero).animate(_fadeSlide),
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            Text(_test.title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: primaryBlue, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Expanded(
                                child: ListView(
                                    children: [
                                        _buildSolutionBox(SOLUTION_PREPARATION),
                                        _buildTestCard(_test.procedure, _test.observation),
                                        const SizedBox(height: 16),
                                        
                                        const SizedBox(height: 24),
                                        _buildGradientHeader('Select the correct inference:'),
                                        const SizedBox(height: 10),
                                        ..._test.options.map((opt) {
                                            final selectedHere = _selectedOption == opt;
                                            return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4),
                                                child: InkWell(
                                                    onTap: () async {
                                                        setState(() => _selectedOption = opt);
                                                        await _saveAnswer(_test.id, opt);
                                                    },
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: AnimatedContainer(
                                                        duration: const Duration(milliseconds: 200),
                                                        padding: const EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                            color: selectedHere ? accentTeal.withOpacity(0.1) : Colors.white,
                                                            borderRadius: BorderRadius.circular(8),
                                                            border: Border.all(
                                                                color: selectedHere ? accentTeal : Colors.grey.shade300,
                                                                width: 1.5,
                                                            ),
                                                        ),
                                                        child: Text(
                                                            opt,
                                                            style: TextStyle(
                                                                fontWeight: selectedHere ? FontWeight.bold : FontWeight.normal,
                                                                color: selectedHere ? accentTeal : Colors.black87,
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
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        ),
                                    ),
                                ],
                            )
                        ],
                    ),
                ),
            ),
        ),
    );
  }
}