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
  List<String> confirmedCations = [];

  final List<Map<String, dynamic>> ctTests = [
    // Group 0
    {'ion': 'NH4+', 'group': 0, 'questionId': 2, 'title': 'NH₄⁺ Confirmatory Test'},
    
    // Group 1
    {'ion': 'Pb2+', 'group': 1, 'questionId': 5, 'title': 'Pb²⁺ Confirmatory Test'},
    
    // Group 2
    {'ion': 'Cu2+', 'group': 2, 'questionId': 8, 'title': 'Cu²⁺ Confirmatory Test'},
    {'ion': 'As3+', 'group': 2, 'questionId': 9, 'title': 'As³⁺ Confirmatory Test'},
    
    // Group 3
    {'ion': 'Fe3+', 'group': 3, 'questionId': 12, 'title': 'Fe³⁺ Confirmatory Test'},
    {'ion': 'Al3+', 'group': 3, 'questionId': 13, 'title': 'Al³⁺ Confirmatory Test'},
    
    // Group 4
    {'ion': 'Ni2+', 'group': 4, 'questionId': 16, 'title': 'Ni²⁺ Confirmatory Test'},
    {'ion': 'Co2+', 'group': 4, 'questionId': 17, 'title': 'Co²⁺ Confirmatory Test'},
    {'ion': 'Mn2+', 'group': 4, 'questionId': 18, 'title': 'Mn²⁺ Confirmatory Test'},
    {'ion': 'Zn2+', 'group': 4, 'questionId': 19, 'title': 'Zn²⁺ Confirmatory Test'},
    
    // Group 5
    {'ion': 'Ba2+', 'group': 5, 'questionId': 22, 'title': 'Ba²⁺ Confirmatory Test'},
    {'ion': 'Ca2+', 'group': 5, 'questionId': 23, 'title': 'Ca²⁺ Confirmatory Test'},
    {'ion': 'Sr2+', 'group': 5, 'questionId': 24, 'title': 'Sr²⁺ Confirmatory Test'},
    
    // Group 6
    {'ion': 'Mg2+', 'group': 6, 'questionId': 27, 'title': 'Mg²⁺ Confirmatory Test'},
  ];

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    studentGroups = await DatabaseHelper.instance.getStudentGroupDecisions(widget.salt);
    await _identifyConfirmedCations();
    setState(() => isLoading = false);
  }

  // Identify ALL cations that were tested with CT (both correct and incorrect)
  Future<void> _identifyConfirmedCations() async {
    List<String> tested = [];
    
    for (final ct in ctTests) {
      final groupNum = ct['group'] as int;
      final ion = ct['ion'] as String;
      
      // Check if this group should be tested (if it's present in correct answer)
      if (wetTestGroups[groupNum] == GroupStatus.present) {
        tested.add(ion);
      }
    }
    
    confirmedCations = tested;
  }

  Future<bool> isGroupFullyCorrect(int groupNumber) async {
    final studentStatus = studentGroups[groupNumber];
    final correctStatus = wetTestGroups[groupNumber];
    
    if (studentStatus == null) return false;
    if (studentStatus != correctStatus) return false;
    
    if (correctStatus == GroupStatus.present) {
      final groupCTs = ctTests.where((ct) => ct['group'] == groupNumber).toList();
      
      bool anyCTCorrect = false;
      for (final ct in groupCTs) {
        final ctCorrect = await isCTCorrect(
          group: ct['group'] as int,
          ion: ct['ion'] as String,
          questionId: ct['questionId'] as int,
        );
        if (ctCorrect) {
          anyCTCorrect = true;
          break;
        }
      }
      return anyCTCorrect;
    }
    
    return true;
  }

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

  Future<bool> isCTCorrect({
    required int group,
    required String ion,
    required int questionId,
  }) async {
    if (wetTestGroups[group] != GroupStatus.present) {
      return false;
    }

    final studentAnswer = await DatabaseHelper.instance.getStudentAnswer(
      'SaltC_WetTest',
      questionId,
    );

    final correctCT = wetTestCTAnswers[ion];

    if (studentAnswer == null || correctCT == null) {
      return false;
    }

    final studentClean = studentAnswer.trim().toLowerCase();
    final correctClean = correctCT.correctOption.trim().toLowerCase();
    
    return studentClean == correctClean;
  }

  Future<int> _calculateScore() async {
    int score = 0;
    for (final group in wetTestGroups.keys) {
      if (await isGroupFullyCorrect(group)) {
        score += 10;
      }
    }
    return score;
  }

  // Check if a specific cation CT is correct
  Future<bool> isCationCorrect(String ion) async {
    // Find the CT test for this ion
    final ctData = ctTests.firstWhere(
      (ct) => ct['ion'] == ion,
      orElse: () => <String, dynamic>{},
    );
    
    if (ctData.isEmpty) return false;
    
    final groupNum = ctData['group'] as int;
    final questionId = ctData['questionId'] as int;
    
    return await isCTCorrect(
      group: groupNum,
      ion: ion,
      questionId: questionId,
    );
  }

  // Format ion display name
  String formatIonName(String ion) {
    return ion.replaceAll('2+', '²⁺')
              .replaceAll('3+', '³⁺')
              .replaceAll('4+', '⁴⁺');
  }

  // Navigate to detailed result page
  void _viewDetailedResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WetTestCDetailedResultScreen(
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
        body: Center(child: CircularProgressIndicator(color: Color(0xFF00897B))),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE8F5F3),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              color: Color(0xFFE8F5F3),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF00897B)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Results',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00897B),
                      ),
                    ),
                  ),
                  SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Success Icon with star badge design
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFF00897B),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            // Star points (simplified)
                            Center(
                              child: Icon(
                                Icons.star,
                                color: Color(0xFF00897B),
                                size: 140,
                              ),
                            ),
                            // Checkmark
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0xFF00897B),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Title Text
                      const Text(
                        'The given inorganic mixture contains the\nfollowing two cations (basic radicals):',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF37474F),
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Confirmed Cations List
                      if (confirmedCations.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFF80CBC4), width: 1.5),
                          ),
                          child: Text(
                            'No cations to test',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      else
                        ...List.generate(
                          confirmedCations.length,
                          (index) => FutureBuilder<bool>(
                            future: isCationCorrect(confirmedCations[index]),
                            builder: (context, snapshot) {
                              final isCorrect = snapshot.data ?? false;
                              final isLoading = snapshot.connectionState == ConnectionState.waiting;
                              
                              // Determine colors based on correctness
                              Color borderColor;
                              Color textColor;
                              Color backgroundColor;
                              IconData? statusIcon;
                              Color? iconColor;
                              
                              if (isLoading) {
                                borderColor = Color(0xFF80CBC4);
                                textColor = Color(0xFF00897B);
                                backgroundColor = Colors.white;
                                statusIcon = null;
                                iconColor = null;
                              } else if (isCorrect) {
                                borderColor = Color(0xFF66BB6A); // Green
                                textColor = Color(0xFF2E7D32); // Dark green
                                backgroundColor = Color(0xFFE8F5E9); // Light green
                                statusIcon = Icons.check_circle;
                                iconColor = Color(0xFF66BB6A);
                              } else {
                                borderColor = Color(0xFFEF5350); // Red
                                textColor = Color(0xFFC62828); // Dark red
                                backgroundColor = Color(0xFFFFEBEE); // Light red
                                statusIcon = Icons.cancel;
                                iconColor = Color(0xFFEF5350);
                              }
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: borderColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}.',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          formatIonName(confirmedCations[index]),
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                      if (isLoading)
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Color(0xFF00897B),
                                            ),
                                          ),
                                        )
                                      else if (statusIcon != null)
                                        Icon(
                                          statusIcon,
                                          color: iconColor,
                                          size: 32,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                      
                      // Hint Text
                      Text(
                        'Tap an ion to review its group analysis',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF90A4AE),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // View Detail Button (Outlined)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _viewDetailedResults,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Color(0xFF00897B), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'VIEW DETAIL',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Back to Home Button (Filled)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00526C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'BACK TO HOME',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DETAILED RESULT SCREEN ====================
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

  Future<bool> isGroupFullyCorrect(int groupNumber) async {
    final studentStatus = studentGroups[groupNumber];
    final correctStatus = wetTestGroups[groupNumber];
    
    if (studentStatus == null) return false;
    if (studentStatus != correctStatus) return false;
    
    if (correctStatus == GroupStatus.present) {
      final groupCTs = ctTests.where((ct) => ct['group'] == groupNumber).toList();
      
      bool anyCTCorrect = false;
      for (final ct in groupCTs) {
        final ctCorrect = await isCTCorrect(
          group: ct['group'] as int,
          ion: ct['ion'] as String,
          questionId: ct['questionId'] as int,
        );
        if (ctCorrect) {
          anyCTCorrect = true;
          break;
        }
      }
      return anyCTCorrect;
    }
    
    return true;
  }

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

  Future<bool> isCTCorrect({
    required int group,
    required String ion,
    required int questionId,
  }) async {
    if (wetTestGroups[group] != GroupStatus.present) {
      return false;
    }

    final studentAnswer = await DatabaseHelper.instance.getStudentAnswer(
      'SaltC_WetTest',
      questionId,
    );

    final correctCT = wetTestCTAnswers[ion];

    if (studentAnswer == null || correctCT == null) {
      return false;
    }

    final studentClean = studentAnswer.trim().toLowerCase();
    final correctClean = correctCT.correctOption.trim().toLowerCase();
    
    return studentClean == correctClean;
  }

  Future<int> _calculateScore() async {
    int score = 0;
    for (final group in wetTestGroups.keys) {
      if (await isGroupFullyCorrect(group)) {
        score += 10;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Results — Salt $salt'),
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
        ],
      ),
    );
  }
}