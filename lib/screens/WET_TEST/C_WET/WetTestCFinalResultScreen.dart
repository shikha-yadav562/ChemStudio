import 'package:flutter/material.dart';
import 'package:ChemStudio/DB/database_helper.dart';
import 'package:ChemStudio/models/group_status.dart';
import 'package:ChemStudio/screens/WET_TEST/C_WET/wet_test_answers.dart';

class WetTestCFinalResultScreen extends StatefulWidget {
  final String salt; // 'C'

  const WetTestCFinalResultScreen({super.key, required this.salt});

  @override
  State<WetTestCFinalResultScreen> createState() => _WetTestCFinalResultScreenState();
}

class _WetTestCFinalResultScreenState extends State<WetTestCFinalResultScreen> {
  bool isLoading = true;
  Map<int, GroupStatus> studentGroups = {};

  // ✅ UPDATED: Ion mapping with Groups 0-6
  final List<Map<String, dynamic>> ctTests = [
    // Group 0
    {'ion': 'NH4+', 'group': 0, 'questionId': 2, 'title': 'NH₄⁺ Confirmatory Test'},
    
    // Group 1
    {'ion': 'Pb2+', 'group': 1, 'questionId': 5, 'title': 'Pb²⁺ Confirmatory Test'},
    
    // Group 2
    {'ion': 'Cu2+', 'group': 2, 'questionId': 7, 'title': 'Cu²⁺ Confirmatory Test'},
    {'ion': 'As3+', 'group': 2, 'questionId': 8, 'title': 'As³⁺ Confirmatory Test'},
    
    // Group 3
    {'ion': 'Fe3+', 'group': 3, 'questionId': 11, 'title': 'Fe³⁺ Confirmatory Test'},
    {'ion': 'Al3+', 'group': 3, 'questionId': 12, 'title': 'Al³⁺ Confirmatory Test'},
    
    // Group 4
    {'ion': 'Ni2+', 'group': 4, 'questionId': 15, 'title': 'Ni²⁺ Confirmatory Test'},
    {'ion': 'Co2+', 'group': 4, 'questionId': 16, 'title': 'Co²⁺ Confirmatory Test'},
    {'ion': 'Mn2+', 'group': 4, 'questionId': 17, 'title': 'Mn²⁺ Confirmatory Test'},
    {'ion': 'Zn2+', 'group': 4, 'questionId': 18, 'title': 'Zn²⁺ Confirmatory Test'},
    
    // Group 5
    {'ion': 'Ba2+', 'group': 5, 'questionId': 20, 'title': 'Ba²⁺ Confirmatory Test'},
    {'ion': 'Ca2+', 'group': 5, 'questionId': 21, 'title': 'Ca²⁺ Confirmatory Test'},
    {'ion': 'Sr2+', 'group': 5, 'questionId': 22, 'title': 'Sr²⁺ Confirmatory Test'},
    
    // Group 6
    {'ion': 'Mg2+', 'group': 6, 'questionId': 24, 'title': 'Mg²⁺ Confirmatory Test'},
  ];

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    studentGroups = await DatabaseHelper.instance.getStudentGroupDecisions(widget.salt);
    setState(() => isLoading = false);
  }

  // ✅ Group comparison with detailed logging
  Future<bool> isGroupFullyCorrect(int groupNumber) async {
    final studentStatus = studentGroups[groupNumber];
    final correctStatus = wetTestGroups[groupNumber];
    
    print('=== GROUP $groupNumber CHECK ===');
    print('Student status: $studentStatus');
    print('Correct status: $correctStatus');
    
    // If student didn't attempt, it's wrong
    if (studentStatus == null) {
      print('Result: FAIL - Not attempted');
      return false;
    }
    
    // Check if group status matches
    if (studentStatus != correctStatus) {
      print('Result: FAIL - Status mismatch');
      return false;
    }
    
    // ✅ If group is PRESENT, also check CT answer
    if (correctStatus == GroupStatus.present) {
      print('Group is PRESENT - checking CT...');
      // Find the CT for this group
      final groupCTs = ctTests.where((ct) => ct['group'] == groupNumber).toList();
      print('Found ${groupCTs.length} CTs for this group');
      
      // Check if at least one CT for this group is correct
      bool anyCTCorrect = false;
      for (final ct in groupCTs) {
        print('Checking CT: ${ct['ion']} (questionId: ${ct['questionId']})');
        final ctCorrect = await isCTCorrect(
          group: ct['group'] as int,
          ion: ct['ion'] as String,
          questionId: ct['questionId'] as int,
        );
        print('CT ${ct['ion']} result: $ctCorrect');
        if (ctCorrect) {
          anyCTCorrect = true;
          break;
        }
      }
      
      print('Result: ${anyCTCorrect ? "PASS" : "FAIL"} - CT check');
      return anyCTCorrect;
    }
    
    // If group is ABSENT, just matching status is enough
    print('Result: PASS - Group absent and matched');
    return true;
  }

  // ✅ UPDATED: Group names for Groups 0-6
  String getGroupName(int groupNumber) {
    const groupNames = {
      0: 'Group 0 (NH₄⁺)',
      1: 'Group I (Pb²⁺)',
      2: 'Group II (Cu²⁺/As³⁺)',
      3: 'Group III (Fe³⁺/Al³⁺)',
      4: 'Group IV (Ni²⁺/Co²⁺/Mn²⁺/Zn²⁺)',
      5: 'Group V (Ba²⁺/Ca²⁺/Sr²⁺)',
      6: 'Group VI (Mg²⁺)',
    };
    return groupNames[groupNumber] ?? 'Group $groupNumber';
  }

  // CT COMPARISON
  Future<bool> isCTCorrect({
    required int group,
    required String ion,
    required int questionId,
  }) async {
    // 1️⃣ Check if this group is actually present in correct answer
    if (wetTestGroups[group] != GroupStatus.present) {
      return false; // Group shouldn't be tested
    }

    // 2️⃣ Get student's CT answer
    final studentAnswer = await DatabaseHelper.instance.getStudentAnswer(
      'SaltC_WetTest',
      questionId,
    );

    // 3️⃣ Get correct CT answer
    final correctCT = wetTestCTAnswers[ion];

    if (studentAnswer == null || correctCT == null) {
      print('DEBUG: studentAnswer=$studentAnswer, correctCT=$correctCT for ion=$ion');
      return false;
    }

    // 4️⃣ Compare (case-insensitive and trim whitespace)
    final studentClean = studentAnswer.trim().toLowerCase();
    final correctClean = correctCT.correctOption.trim().toLowerCase();
    
    print('DEBUG Group $group ($ion): Student="$studentClean" vs Correct="$correctClean"');
    
    return studentClean == correctClean;
  }

  // ✅ Calculate score based on BOTH group status AND CT
  Future<int> _calculateScore() async {
    int score = 0;
    
    // Score for correct group identification + CT (10 points each)
   for (final group in wetTestGroups.keys) {
  if (await isGroupFullyCorrect(group)) {
    score += 10;
  }
}

    
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Final Result – Salt ${widget.salt}'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SCORE CARD
          FutureBuilder<int>(
            future: _calculateScore(),
            builder: (context, snapshot) {
              final score = snapshot.data ?? 0;
              return Card(
                color: Colors.teal[50],
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Your Score',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$score / ${wetTestGroups.length * 10}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // GROUP RESULT SECTION
          const Text(
            'Group Analysis Result',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ...List.generate(
            wetTestGroups.length,
            (groupNum) {
              final studentStatus = studentGroups[groupNum];
              final correctStatus = wetTestGroups[groupNum];
              
              return FutureBuilder<bool>(
                future: isGroupFullyCorrect(groupNum),
                builder: (context, snapshot) {
                  final isCorrect = snapshot.data ?? false;
                  
                  String subtitle = 'Your Answer: ${studentStatus?.name ?? 'Not Attempted'}\n'
                                   'Correct Answer: ${correctStatus?.name ?? 'Unknown'}';
                  
                  // Add CT status for present groups
                  if (correctStatus == GroupStatus.present && studentStatus == GroupStatus.present) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      subtitle += '\nChecking CT...';
                    } else if (isCorrect) {
                      subtitle += '\n✓ CT Confirmed Correctly';
                    } else {
                      subtitle += '\n✗ CT Incorrect or Missing';
                    }
                  }
                  
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        getGroupName(groupNum),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(subtitle),
                      trailing: snapshot.connectionState == ConnectionState.waiting
                          ? const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 32,
                            ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),

          // CONFIRMATORY TEST DETAIL SECTION
          const Text(
            'Confirmatory Test Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...ctTests.map(
            (ct) => FutureBuilder<bool>(
              future: isCTCorrect(
                group: ct['group'] as int,
                ion: ct['ion'] as String,
                questionId: ct['questionId'] as int,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Card(
                    child: ListTile(
                      title: Text(ct['title'] as String),
                      subtitle: Text('Error: ${snapshot.error}'),
                      trailing: const Icon(Icons.error, color: Colors.orange),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Card(
                    child: ListTile(
                      title: Text(ct['title'] as String),
                      subtitle: const Text('Checking...'),
                      trailing: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                final isCorrect = snapshot.data!;
                final groupNum = ct['group'] as int;
                final shouldTest = wetTestGroups[groupNum] == GroupStatus.present;

                String subtitle;
                Color subtitleColor;
                
                if (!shouldTest) {
                  subtitle = 'Not required (Group is absent)';
                  subtitleColor = Colors.grey;
                } else if (isCorrect) {
                  subtitle = '✓ Correct confirmation';
                  subtitleColor = Colors.green;
                } else {
                  subtitle = '✗ Incorrect or not attempted';
                  subtitleColor = Colors.red;
                }

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      ct['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      subtitle,
                      style: TextStyle(color: subtitleColor),
                    ),
                    trailing: Icon(
                      shouldTest
                          ? (isCorrect ? Icons.check_circle : Icons.cancel)
                          : Icons.remove_circle_outline,
                      color: shouldTest
                          ? (isCorrect ? Colors.green : Colors.red)
                          : Colors.grey,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ACTION BUTTONS
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            label: const Text('Back to Home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}