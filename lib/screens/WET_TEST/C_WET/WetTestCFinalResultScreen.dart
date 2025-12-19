import 'package:flutter/material.dart';
import 'package:ChemStudio/DB/database_helper.dart';
import 'package:ChemStudio/models/group_status.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/wet_test_answers.dart';

/// ===============================================================
/// FINAL RESULT SCREEN
/// ===============================================================
class WetTestCFinalResultScreen extends StatefulWidget {
  final String salt;

  const WetTestCFinalResultScreen({super.key, required this.salt});

  @override
  State<WetTestCFinalResultScreen> createState() =>
      _WetTestCFinalResultScreenState();
}

class _WetTestCFinalResultScreenState
    extends State<WetTestCFinalResultScreen> {
  bool isLoading = true;

  Map<int, GroupStatus> studentGroups = {};
  List<String> selectedIons = [];

  final List<Map<String, dynamic>> ctTests = [
    {'ion': 'NH4+', 'group': 0, 'questionId': 2},
    {'ion': 'Pb2+', 'group': 1, 'questionId': 5},
    {'ion': 'Cu2+', 'group': 2, 'questionId': 8},
    {'ion': 'As3+', 'group': 2, 'questionId': 9},
    {'ion': 'Fe3+', 'group': 3, 'questionId': 12},
    {'ion': 'Al3+', 'group': 3, 'questionId': 13},
    {'ion': 'Ni2+', 'group': 4, 'questionId': 16},
    {'ion': 'Co2+', 'group': 4, 'questionId': 17},
    {'ion': 'Mn2+', 'group': 4, 'questionId': 18},
    {'ion': 'Zn2+', 'group': 4, 'questionId': 19},
    {'ion': 'Ba2+', 'group': 5, 'questionId': 22},
    {'ion': 'Ca2+', 'group': 5, 'questionId': 23},
    {'ion': 'Sr2+', 'group': 5, 'questionId': 24},
    {'ion': 'Mg2+', 'group': 6, 'questionId': 27},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    studentGroups =
        await DatabaseHelper.instance.getStudentGroupDecisions(widget.salt);

    await _identifySelectedIons();

    setState(() => isLoading = false);
  }

  /// 🔥 CORE LOGIC:
  /// Take ions that STUDENT actually attempted (CT)
  /// Show EXACTLY TWO (even if wrong)
  Future<void> _identifySelectedIons() async {
    final List<String> ions = [];

    for (final ct in ctTests) {
      final questionId = ct['questionId'] as int;
      final ion = ct['ion'] as String;

      final studentAnswer = await DatabaseHelper.instance.getStudentAnswer(
        'SaltC_WetTest',
        questionId,
      );

      if (studentAnswer != null && studentAnswer.trim().isNotEmpty) {
        ions.add(ion);
      }
    }

    selectedIons = ions.take(2).toList();
  }

  Future<bool> isCTCorrect({
    required int group,
    required String ion,
    required int questionId,
  }) async {
    if (wetTestGroups[group] != GroupStatus.present) return false;

    final studentAnswer = await DatabaseHelper.instance.getStudentAnswer(
      'SaltC_WetTest',
      questionId,
    );

    final correct = wetTestCTAnswers[ion]?.correctOption;

    if (studentAnswer == null || correct == null) return false;

    return studentAnswer.trim().toLowerCase() ==
        correct.trim().toLowerCase();
  }

  String formatIon(String ion) {
    return ion
        .replaceAll('2+', '²⁺')
        .replaceAll('3+', '³⁺')
        .replaceAll('4+', '⁴⁺');
  }

  void _openDetailedResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WetTestCDetailedResultScreen(
          salt: widget.salt,
          studentGroups: studentGroups,
          ctTests: ctTests,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFE8F5F3),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00897B)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F5F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00897B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Results',
          style: TextStyle(
            color: Color(0xFF00897B),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle,
                size: 100, color: Color(0xFF00897B)),
            const SizedBox(height: 24),
            const Text(
              'The given inorganic mixture contains the\nfollowing cations:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 32),

            /// ================= ION CARDS =================
            ...selectedIons.map((ion) {
              final ct =
                  ctTests.firstWhere((element) => element['ion'] == ion);

              return FutureBuilder<bool>(
                future: isCTCorrect(
                  group: ct['group'],
                  ion: ion,
                  questionId: ct['questionId'],
                ),
                builder: (context, snapshot) {
                  final isCorrect = snapshot.data ?? false;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCorrect ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          formatIon(ion),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isCorrect
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          isCorrect
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                              isCorrect ? Colors.green : Colors.red,
                          size: 32,
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            const Spacer(),

            /// VIEW DETAIL BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _openDetailedResult,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFF00897B), width: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  'VIEW DETAIL',
                  style: TextStyle(
                    color: Color(0xFF00897B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// DETAILED RESULT SCREEN (NO SCORE)
/// ===============================================================
class WetTestCDetailedResultScreen extends StatelessWidget {
  final String salt;
  final Map<int, GroupStatus> studentGroups;
  final List<Map<String, dynamic>> ctTests;

  const WetTestCDetailedResultScreen({
    super.key,
    required this.salt,
    required this.studentGroups,
    required this.ctTests,
  });

  Future<bool> isCTCorrect({
    required int group,
    required String ion,
    required int questionId,
  }) async {
    if (wetTestGroups[group] != GroupStatus.present) return false;

    final studentAnswer = await DatabaseHelper.instance.getStudentAnswer(
      'SaltC_WetTest',
      questionId,
    );

    final correct = wetTestCTAnswers[ion]?.correctOption;

    if (studentAnswer == null || correct == null) return false;

    return studentAnswer.trim().toLowerCase() ==
        correct.trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detailed Results — Salt $salt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: ctTests.map((ct) {
          return FutureBuilder<bool>(
            future: isCTCorrect(
              group: ct['group'],
              ion: ct['ion'],
              questionId: ct['questionId'],
            ),
            builder: (context, snapshot) {
              final isCorrect = snapshot.data ?? false;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    ct['ion'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    isCorrect
                        ? '✓ Confirmatory test correct'
                        : '✗ Confirmatory test incorrect',
                    style: TextStyle(
                        color:
                            isCorrect ? Colors.green : Colors.red),
                  ),
                  trailing: Icon(
                    isCorrect
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
