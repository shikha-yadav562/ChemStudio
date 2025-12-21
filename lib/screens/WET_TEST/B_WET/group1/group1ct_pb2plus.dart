import 'package:flutter/material.dart';
import '../group0/group0analysis.dart'; 
import '../group2/group2detection.dart'; 
import '../b_intro.dart'; // Standard import for Salt A Intro

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class WetTestBGroupOneCTPbScreen extends StatefulWidget {
    const WetTestBGroupOneCTPbScreen({super.key});

    @override
    State<WetTestBGroupOneCTPbScreen> createState() => 
        _WetTestBGroupOneCTPbScreenState();
}

class _WetTestBGroupOneCTPbScreenState extends State<WetTestBGroupOneCTPbScreen>
    with SingleTickerProviderStateMixin {
    
    final int _index = 0; 
    String? _selectedOption; 
    
    late final AnimationController _animController;
    late final Animation<double> _fadeSlide;

    final _dbHelper = DatabaseHelper.instance;
    final String _tableName = 'SaltC_WetTest';

    // Content for the Pb2+ Confirmation Test
    late final List<WetTestItem> _tests = [
        WetTestItem(
            id: 5, // Sequential ID
            title: 'C.T for Pb²⁺',
            procedure: 'Group I ppt + Diluted HCl (hot), filter, add K₂CrO₄ to filtrate',
            observation: 'Yellow Precipitate',
            options: ['Pb²⁺ confirmed'],
            correct: 'Pb²⁺ confirmed',
        ),
    ];

    @override
    void initState() {
        super.initState();
        _animController = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 450),
        );
        _fadeSlide =
            CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
        _loadSavedAnswers();
        _animController.forward();
    }

    Future<void> _loadSavedAnswers() async {
        final data = await _dbHelper.getAnswers(_tableName);
        setState(() {
            final testId = _tests[_index].id;
            final savedAnswer = data.firstWhereOrNull(
                (row) => row['question_id'] == testId)?['answer'];
            _selectedOption = savedAnswer;
        });
    }

    Future<void> _saveAnswer(int id, String answer) async {
        await _dbHelper.saveAnswer(_tableName, id, answer);
    }

    void _next() async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const WetTestCGroupTwoDetectionScreen(), 
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

    @override
    Widget build(BuildContext context) {
        final test = _tests[_index];
        
        return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 2,
                centerTitle: true,
                // ADDED: Navigation back to Intro A
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: primaryBlue),
                    onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const WetTestIntroBScreen()),
                            (route) => false,
                        );
                    },
                ),
                title: ShaderMask(
                    shaderCallback: (bounds) =>
                        const LinearGradient(colors: [accentTeal, primaryBlue])
                            .createShader(bounds),
                    child:  Text(
                        'Salt B: Wet Test',
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
                                            _buildInferenceHeader(),
                                            const SizedBox(height: 10),
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