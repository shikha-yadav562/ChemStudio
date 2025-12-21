import 'package:flutter/material.dart';
import '../b_intro.dart'; // Import for the intro page
import '../group0/group0analysis.dart';
import 'group3ct_fe3plus.dart';
import 'group3ct_al3plus.dart';

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class WetTestCGroupThreeAnalysisScreen extends StatefulWidget {
  const WetTestCGroupThreeAnalysisScreen({super.key});

  @override
  State<WetTestCGroupThreeAnalysisScreen> createState() =>
      _WetTestCGroupThreeAnalysisScreenState();
}

class _WetTestCGroupThreeAnalysisScreenState extends State<WetTestCGroupThreeAnalysisScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedOption;
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltC_WetTest';

  late final WetTestItem _test = WetTestItem(
    id: 10,
    title: 'Analysis of Group III',
    procedure: 'O.S/Filtrate + NH₄Cl + NH₄OH',
    observation: 'No ppt',
    options: ['Fe³⁺ may be present', 'Al³⁺ may be present'],
    correct: 'Fe³⁺ may be present', 
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

  void _next() async {
    if (_selectedOption == 'Fe³⁺ may be present') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WetTestBGroupThreeCTFeScreen()),
      );
    } else if (_selectedOption == 'Al³⁺ may be present') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WetTestBGroupThreeCTAlScreen()),
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
              textAlign: TextAlign.start,
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
        // --- Updated Leading Navigation ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WetTestIntroBScreen()),
              (route) => false,
            );
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: Text(
            'Salt B : Wet Test',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}