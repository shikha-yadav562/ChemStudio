// group2ct_cu2plus.dart

import 'package:flutter/material.dart';
import '../group0/group0analysis.dart'; // DatabaseHelper, WetTestItem, etc.
import '../group3/group3detection.dart';
import 'package:ChemStudio/screens/WET_TEST/D_WET/d_intro.dart';

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

// FIX: Keeping the extension here to support _loadSavedAnswer() unless it's defined in group0analysis.dart
extension IterableExtension<T> on Iterable<T> {
 T? firstWhereOrNull(bool Function(T element) test) {
 for (var element in this) {
if (test(element)) return element;
 }
 return null;
}
}

class WetTestDGroupTwoCTCuScreen extends StatefulWidget {
  const WetTestDGroupTwoCTCuScreen({super.key});

  @override
  State<WetTestDGroupTwoCTCuScreen> createState() => 
      _WetTestDGroupTwoCTCuScreenState();
}

class _WetTestDGroupTwoCTCuScreenState extends State<WetTestDGroupTwoCTCuScreen>
    with SingleTickerProviderStateMixin {
  
  String? _selectedOption; 
  
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltD_WetTest';

  static const String SOLUTION_PREPARATION = 
    'Dissolve the black ppt of group II in aquaregia (conc. HCl + conc. HNO₃ in 3:1 proportion), dilute with water. Use this solution for C.T of Cu²⁺';

  // Content for the Cu2+ Confirmation Test
  late final WetTestItem _test = WetTestItem(
      id: 7, 
      title: 'C.T for Cu²⁺',
      procedure: 'Above Solution + KI', 
      observation: 'White ppt in brown coloured solution',
      options: ['Cu²⁺ confirmed'],
      correct: 'Cu²⁺ confirmed', 
  );

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeSlide =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _loadSavedAnswer();
    _animController.forward();
  }

  Future<void> _loadSavedAnswer() async {
  final data = await _dbHelper.getAnswers(_tableName);
 setState(() {
   // Using the Extension Override to explicitly choose the local IterableExtension
   final savedAnswer = IterableExtension(data).firstWhereOrNull(
     (row) => row['question_id'] == _test.id)?['answer'];
   _selectedOption = savedAnswer;
  });
 }
  Future<void> _saveAnswer(int id, String answer) async {
    await _dbHelper.saveAnswer(_tableName, id, answer);
  }

void _next() async {
  // FIX 2: Navigate to the imported Group 3 Detection screen.
  Navigator.push(
   context,
   MaterialPageRoute(
    builder: (_) => const WetTestDGroupThreeDetectionScreen(), 
   ),
  );
 }
  void _prev() {
    // Navigate back to the Group II Analysis screen
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Helper method to build the preparation/solution box
  Widget _buildSolutionBox(String content) {
    // FIX: Use a standard Card with no custom color or side border to match _buildTestCard
    return Card(
      elevation: 4, // Same shadow as Test/Observation card
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Same border radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Uses the same gradient header as 'Test' and 'Observation'
            _buildGradientHeader('Solution'), 
            const SizedBox(height: 8),
            Text(
              content,
              // Uses the same bold, primary blue color styling as the Observation text
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

  Widget _buildGradientHeader(String text) {
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

  // Uses the WetTestItem's procedure field for the Test step
  Widget _buildTestCard(String testProcedure, String observation) {
    // This Card is the one being copied
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
        MaterialPageRoute(builder: (context) => const WetTestIntroDScreen()), // Replace with your actual class name in c_intro.dart
        (route) => false, // This clears the navigation stack
      );
    },
  ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
            'Salt D : Wet Test',
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
                Text(_test.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: primaryBlue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      // Solution/Preparation Box (Now visually consistent with the card below)
                      _buildSolutionBox(SOLUTION_PREPARATION),
                      
                      // Test and Observation Card.
                      _buildTestCard(_test.procedure, _test.observation), 

                      const SizedBox(height: 24),
                      _buildGradientHeader('Select the correct inference:'),
                      const SizedBox(height: 10),
                      
                      // Options (Only one for confirmation)
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
                // Navigation Buttons (Prev/Next)
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
}