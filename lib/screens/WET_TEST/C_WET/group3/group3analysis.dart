import 'package:flutter/material.dart';
// Assuming the import path for DatabaseHelper and WetTestItem is correct
import '../group0/group0analysis.dart';
// Import for Fe3+ Confirmation Test
import 'group3ct_fe3plus.dart';
// ⭐ ADDED: Import for Al3+ Confirmation Test (from the file we created previously)
import 'group3ct_al3plus.dart';


// --- Theme Constants (Moved here for consistent access) ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);
// ------------------------------------------------------------------------

// NOTE: The placeholder class for WetTestCGroupThreeCTAlScreen has been removed, 
// as it is now imported from 'group3ct_al3plus.dart'.


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

    // NOTE: Assuming DatabaseHelper and WetTestItem classes exist and are imported/accessible
    final _dbHelper = DatabaseHelper.instance;
    final String _tableName = 'SaltC_WetTest';

    // *** Group 3 Analysis Content ***
    late final WetTestItem _test = WetTestItem(
        id: 10, // Assuming a sequential ID
        title: 'Analysis of Group 3',
        // Using plain ASCII for procedure string (O.S/Filtrate + NH4Cl + NH4OH)
        procedure: 'O.S/Filtrate + NH4Cl + NH4OH',
        observation: 'reddish-brown ppt',
        // Using plain ASCII for options (Fe3+, Al3+)
        options: ['Fe3+ may be present', 'Al3+ may be present'],
        correct: 'Fe3+ may be present', // Assumed for initial data saving
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
            // Assumed firstWhereOrNull is now accessible (via collection import or group0analysis.dart)
            final savedAnswer = data.firstWhereOrNull(
                (row) => row['question_id'] == _test.id)?['answer'];
            _selectedOption = savedAnswer;
        });
    }

    Future<void> _saveAnswer(int id, String answer) async {
        await _dbHelper.saveAnswer(_tableName, id, answer);
    }

    // *** Navigation Logic ***
    void _next() async {
        if (_selectedOption == 'Fe3+ may be present') {
            // Navigate to Fe³⁺ Confirmation Test
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const WetTestCGroupThreeCTFeScreen(),
                ),
            );
        } else if (_selectedOption == 'Al3+ may be present') {
            // ⭐ LOGIC IS CORRECT: Navigate to Al³⁺ Confirmation Test
            await Navigator.push(
                context,
                MaterialPageRoute(
                    // WetTestCGroupThreeCTAlScreen is now imported from group3ct_al3plus.dart
                    builder: (_) => const WetTestCGroupThreeCTAlScreen(), 
                ),
            );
        }
    }

    void _prev() {
        // Go back to Group 3 Detection screen.
        if (Navigator.canPop(context)) {
            Navigator.pop(context);
        }
    }

    @override
    void dispose() {
        _animController.dispose();
        super.dispose();
    }

    // Helper methods for UI consistency
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
                                            _buildTestCard(test),
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
                                        OutlinedButton(
                                            onPressed: _prev,
                                            style: OutlinedButton.styleFrom(
                                                foregroundColor: primaryBlue,
                                                side: const BorderSide(color: primaryBlue),
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                                            child: const Text('Previous'),
                                        ),
                                        ElevatedButton(
                                            onPressed: _selectedOption != null ? _next : null,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: primaryBlue,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                                            child: const Text('Next'),
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