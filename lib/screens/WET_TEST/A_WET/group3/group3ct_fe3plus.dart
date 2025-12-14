// E:\flutter chemistry\wet\wet\lib\C\group3\group3ct_fe3plus.dart
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_4/group4detection_analysis.dart.dart';
import 'package:flutter/material.dart';
import '../group0/group0analysis.dart'; // DatabaseHelper, WetTestItem, etc.
//import '../group4/group4detection.dart'; // Next screen for navigation

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

// --- Placeholder for next screen (Group 4) ---
// Note: Assuming WetTestCGroupFourDetectionScreen is defined in group4detection.dart
// If not, you may need a placeholder or the actual import.
class WetTestCGroupFourDetectionScreen extends StatelessWidget {
  const WetTestCGroupFourDetectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Group 4 Detection")),
      body: const Center(child: Text("Proceeding to Group 4 Detection...")),
    );
  }
}

// Extension to safely get the first element or null, required for consistency.
// Since you are using it here, we will include it, or if it's already in 
// a globally imported file, you can remove this block.
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}


class WetTestCGroupThreeCTFeScreen extends StatefulWidget {
  const WetTestCGroupThreeCTFeScreen({super.key});

  @override
  State<WetTestCGroupThreeCTFeScreen> createState() => 
      _WetTestCGroupThreeCTFeScreenState();
}

class _WetTestCGroupThreeCTFeScreenState extends State<WetTestCGroupThreeCTFeScreen>
    with SingleTickerProviderStateMixin {
  
  String? _selectedOption; 
  
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltC_WetTest';

  // Content provided by the user for the solution preparation
  static const String SOLUTION_PREPARATION = 
    'Dissolve the group 3 ppt in dil. HCl and use this solution for C.T.';


  // Content for the Fe3+ Confirmation Test
  late final WetTestItem _test = WetTestItem(
      id: 11, // Unique ID after Group III Analysis (ID 10)
      title: 'C.T For Fe³⁺',
      procedure: 'Above Solution+ K4[ Fe (CN)6] (Potassium ferrocyanide)', 
      observation: 'Prussian blue ppt or colour',
      options: ['Fe³⁺ confirmed'],
      correct: 'Fe³⁺ confirmed', 
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
      final savedAnswer = data.firstWhereOrNull(
          (row) => row['question_id'] == _test.id)?['answer'];
      _selectedOption = savedAnswer;
    });
  }

  Future<void> _saveAnswer(int id, String answer) async {
    await _dbHelper.saveAnswer(_tableName, id, answer);
  }

  void _next() async {
    // Navigate to the Group 4 Detection screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const  WetTestCPage1(), 
      ),
    );
  }

  void _prev() {
    // Navigate back to the Group III Analysis screen
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Helper method for the gradient header (consistent with previous files)
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
  
  // Solution Box (Consistent white card style with shadow)
  Widget _buildSolutionBox(String content) {
    return Card(
      elevation: 4, 
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradientHeader('Solution'), 
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

  // Test and Observation Card (Consistent style)
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
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
            'Salt A : Wet Test',
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
                      // Solution/Preparation Box
                      _buildSolutionBox(SOLUTION_PREPARATION),
                      
                      // Test and Observation Card.
                      _buildTestCard(_test.procedure, _test.observation), 

                      const SizedBox(height: 24),
                      _buildGradientHeader('Select the correct inference:'),
                      const SizedBox(height: 10),
                      
                      // Options
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
                      // Since there is only one option, it should be selected immediately after the test
                      // However, we maintain the check for consistency with other screens.
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