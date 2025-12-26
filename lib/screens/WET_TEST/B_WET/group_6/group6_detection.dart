import 'package:flutter/material.dart';
import '../group_6/group6_analysis.dart';
import '../b_intro.dart';
import '../group0/group0analysis.dart';

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class saltB_Group6Detection extends StatefulWidget {
  final String? restoredSelection;
  const saltB_Group6Detection({super.key, this.restoredSelection});

  @override
  State<saltB_Group6Detection> createState() => _saltB_Group6DetectionState();
}

class _saltB_Group6DetectionState extends State<saltB_Group6Detection>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  String? _selectedOption;

  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  final _dbHelper = DatabaseHelper.instance;
  final String _tableName = 'SaltD_WetTest';

  late final List<WetTestItem> _tests = [
    WetTestItem(
      id: 10,
      title: 'Group VI Detection',
      procedure:
          'O.S / Filtrate + NH₄Cl (equal) + NH₄OH (till alkaline to litmus) + Na₂HPO₄',
      observation: 'No ppt',
      options: ['Group-VI present', 'Group-VI absent'],
      correct: 'Group-VI absent',
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.restoredSelection != null) {
        setState(() {
          _selectedOption = widget.restoredSelection;
        });
      }
    });

    _animController.forward();
  }

  Future<void> _loadSavedAnswers() async {
    final data = await _dbHelper.getAnswers(_tableName);
    setState(() {
      final testId = _tests[_index].id;
      final savedAnswer =
          data.firstWhereOrNull((row) => row['question_id'] == testId)?['answer'];
      if (widget.restoredSelection == null) {
        _selectedOption = savedAnswer;
      }
    });
  }

  Future<void> _saveAnswer(int id, String answer) async {
    await _dbHelper.saveAnswer(_tableName, id, answer);
  }

  void _next() async {
    if (_selectedOption == 'Group-VI present') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const saltB_Group6Analysis()),
      );
    }
    // ❌ ABSENT → DO NOTHING (BUTTON IS DISABLED ANYWAY)
  }

  void _prev() {
    Navigator.pop(context, _selectedOption);
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, _selectedOption);
    return false;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final test = _tests[_index];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                MaterialPageRoute(
                    builder: (context) => const WetTestIntroBScreen()),
                (route) => false,
              );
            },
          ),
          title: ShaderMask(
            shaderCallback: (bounds) =>
                const LinearGradient(colors: [accentTeal, primaryBlue])
                    .createShader(bounds),
            child: Text(
              'Salt B: Wet Test',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
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
                  Text(
                    test.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold),
                  ),
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
                            padding:
                                const EdgeInsets.symmetric(vertical: 4),
                            child: InkWell(
                              onTap: () async {
                                setState(() => _selectedOption = opt);
                                await _saveAnswer(test.id, opt);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 200),
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
                        // 🔒 FREEZE BUTTON WHEN ABSENT
                        onPressed: (_selectedOption == 'Group-VI present')
                            ? _next
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              (_selectedOption == 'Group-VI present')
                                  ? primaryBlue
                                  : Colors.grey.shade400,
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
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTestCard(WetTestItem test) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader('Test'),
            const SizedBox(height: 4),
            Text(test.procedure,
                style: const TextStyle(fontSize: 14)),
            const Divider(height: 24),
            _gradientHeader('Observation'),
            const SizedBox(height: 8),
            Text(
              test.observation,
              style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
    );
  }
}
