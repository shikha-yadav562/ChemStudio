import 'package:ChemStudio/DB/database_helper.dart';

import '../group_6/group6_detection.dart'; // Real Group 6 file
import 'package:flutter/material.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group0/group0analysis.dart';
import '../a_intro.dart';
import 'group5_analysis_part1.dart'; 

// --- FIX: Iterable Extension ---
extension IterableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class saltA_Group5DetectionScreen extends StatefulWidget {
  const saltA_Group5DetectionScreen({super.key});

  @override
  State<saltA_Group5DetectionScreen> createState() => _saltA_Group5DetectionScreenState();
}

class _saltA_Group5DetectionScreenState extends State<saltA_Group5DetectionScreen>
    with SingleTickerProviderStateMixin {
  
  String? _selectedOption; 
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltD_WetTest';

  // Group V Detection Content
  late final WetTestItem _test = WetTestItem(
    id: 9, 
    title: 'Group V Detection',
    procedure: 'O.S/Filtrate (Remove H₂S) + NH₄Cl(equal) + NH₄OH (till alkaline to litmus) + (NH₄)₂CO₃',
    observation: 'No ppt',
    options: ['Group-V is present', 'Group-V is Absent'],
    correct: 'Group-V is Absent',
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
    await _dbHelper.saveStudentAnswer(_tableName, id, answer);
  }

  // *** Corrected Navigation Logic ***
  void _next() async {
    if (_selectedOption == 'Group-V is present') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const saltA_Group5AnalysisPart1()),
      );
    } else if (_selectedOption == 'Group-V is Absent') {
      // Navigates to the REAL Group6Detection imported from '../group_6/group6_detection.dart'
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const saltA_Group6Detection()),
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

  // --- UI Components ---
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

  Widget _buildTestCard(WetTestItem test) {
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
            Text(test.procedure, style: const TextStyle(fontSize: 14)),
            const Divider(height: 24),
            _buildGradientHeader('Observation'),
            const SizedBox(height: 8),
            Text(
              test.observation,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WetTestIntroAScreen()),
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
                      _buildTestCard(_test),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}