// E:\flutter chemistry\wet\wet\lib\C\group3\group3ct_al3plus.dart
import 'package:ChemStudio/DB/database_helper.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/group_4/group4detection_analysis.dart.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/final_result.dart';
import 'package:flutter/material.dart';
// FIX: Import the collection package for the 'firstWhereOrNull' method.
import 'package:collection/collection.dart';
// Assuming the import path for DatabaseHelper and WetTestItem is correct
import '../group0/group0analysis.dart';
// Import the next screen's definition (or its placeholder)
// Note: If WetTestCGroupFourDetectionScreen is defined elsewhere, adjust this import.
import '../c_intro.dart';


// --- Theme Constants (Copied for local consistency) ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);
// --------------------------------------------------------

// --- Placeholder for next screen (Group 4) ---
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


class WetTestCGroupThreeCTAlScreen extends StatefulWidget {
  const WetTestCGroupThreeCTAlScreen({super.key});

  @override
  State<WetTestCGroupThreeCTAlScreen> createState() =>
      _WetTestCGroupThreeCTAlScreenState();
}

class _WetTestCGroupThreeCTAlScreenState extends State<WetTestCGroupThreeCTAlScreen>
    with SingleTickerProviderStateMixin {

  String? _selectedOption;

  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltC_WetTest';

  // Content provided by the user for the solution preparation
  static const String SOLUTION_PREPARATION = 
    'Dissolve the group 3 ppt in dil. HCl and use this solution for C.T.';

  // *** Al3+ Confirmation Test Content ***
  late final WetTestItem _test = WetTestItem(
      id: 12, // Unique ID for Al3+ Confirmation Test
      title: 'C.T for Al³⁺',
      procedure: 'Above Solution + few drops of NaOH and warm',
      observation: 'White gelatinous ppt (Soluble in excess of NaOH)',
      // Only one option provided as confirmation tests usually yield a single definitive result
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
    await _dbHelper.saveStudentAnswer(_tableName, id, answer);
    await _dbHelper.saveCorrectAnswer(_tableName, id, _test.correct);
    await _dbHelper.markGroupPresent(3); // Group III marked as present
  }

  void _next() async {
    // Get all present groups to decide next screen
    final presentGroups = await _dbHelper.getPresentGroups();
    if (presentGroups.contains(4)) {
      // If Group IV is done, go to final result
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FinalResultScreen()),
      );
    } else {
      // Otherwise, go to Group IV Detection
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WetTestCPage1()),
      );
    }
  }

  void _prev() {
    // Go back to the Group III initial separation/detection screen.
    if (Navigator.canPop(context)) {
        Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Helper methods for UI consistency (Copied from Fe3+ template)
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
  // End of Helper methods

  @override
  Widget build(BuildContext context) {
    final test = _test;

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
        MaterialPageRoute(builder: (context) => const WetTestIntroCScreen()), // Replace with your actual class name in c_intro.dart
        (route) => false, // This clears the navigation stack
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
                                        // Solution/Preparation Box
                                        _buildSolutionBox(SOLUTION_PREPARATION),
                                        
                                        // Test and Observation Card.
                                        _buildTestCard(test.procedure, test.observation), 

                                        const SizedBox(height: 24),
                                        _buildGradientHeader('Select the correct inference:'),
                                        const SizedBox(height: 10),
                                        
                                        // Options
                                        ...test.options.map((opt) {
                                            final selectedHere = _selectedOption == opt;
                                            return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4),
                                                child: InkWell(
                                                    onTap: () async {
                                                        setState(() => _selectedOption = opt);
                                                        await _saveAnswer(test.id, opt);
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
                            // Navigation Buttons
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
                            )
                        ],
                    ),
                ),
            ),
        ),
    );
  }
}