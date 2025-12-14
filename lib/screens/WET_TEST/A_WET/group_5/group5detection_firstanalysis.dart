import 'package:flutter/material.dart';
import '../group_4/group4_Ni_ct.dart';
import '../group_4/group4_Co_ct.dart';
import '../group_4/group4_Mn_ct.dart';
import '../group_4/group4_Zn_ct.dart';
import 'group5analysis_BA_SR_CA.dart';
import '../group_6/group6detection_analysis.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class GroupVPage extends StatefulWidget {
  const GroupVPage({super.key});

  @override
  State<GroupVPage> createState() => _GroupVPageState();
}

class _GroupVPageState extends State<GroupVPage> {
  int pageIndex = 0;
  String? selectedOption;

  // Previous C.T pages list (not used for Previous button now)
  final List<Widget> previousPages = const [
    Ni2ConfirmedPage(),
    Co2ConfirmedPage(),
    Mn2ConfirmedPage(),
    Zn2ConfirmedPage(),
  ];

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
            'Salt C : Wet Test',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: pageIndex == 0 ? _firstPageContent() : _secondPageContent(),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _buildNavigationBar(),
      ),
    );
  }

  // ------------------ PAGE 1 ------------------
  Widget _firstPageContent() {
    return _buildPageContent(
      title: "Group V Detection",
      test:
          "O.S/Filtrate (Remove H₂S) + NH₄Cl(equal) NH₄OH(till alkaline to litmus) + (NH₄)₂CO₃",
      observation: "No ppt",
      options: ["Group-V present", "Group-V absent"],
    );
  }

  // ------------------ PAGE 2 ------------------
  Widget _secondPageContent() {
    return _buildPageContent(
      title: "Analysis Group V",
      test: "O.S / Filtrate + NH₄Cl + NH₄OH (till alkaline) + (NH₄)₂CO₃",
      observation: "white ppt",
      options: ["Ca²⁺, Ba²⁺, Sr²⁺ maybe present"],
    );
  }

  // ------------------ NAV BAR ------------------
  Widget _buildNavigationBar() {
    VoidCallback? onNextPressed;

    // NEXT button logic
    if (selectedOption != null) {
      if (pageIndex == 0) {
        if (selectedOption == "Group-V absent") {
          onNextPressed = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const New1_1Page()),
            );
          };
        } else {
          onNextPressed = () {
            setState(() {
              pageIndex = 1;
              selectedOption = null;
            });
          };
        }
      } else if (pageIndex == 1) {
        onNextPressed = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const WetTestCGroupVPage2(),
            ),
          );
        };
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // PREVIOUS BUTTON
        TextButton.icon(
          onPressed: () {
            if (pageIndex == 1) {
              // Go back to first internal page
              setState(() {
                pageIndex = 0;
                selectedOption = null;
              });
            } else {
              // Go back to external page dynamically
              Navigator.pop(context);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('Previous', style: TextStyle(fontSize: 16)),
        ),

        // NEXT BUTTON
        ElevatedButton.icon(
          onPressed: onNextPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedOption != null ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            shape: const StadiumBorder(),
          ),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  // ------------------ COMMON PAGE CONTENT ------------------
  Widget _buildPageContent({
    required String title,
    required String test,
    required String observation,
    required List<String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _testCard(test, observation),
        const SizedBox(height: 16),
        _gradientTitle("Select the correct inference:"),
        const SizedBox(height: 10),
        for (var option in options) _buildOption(option),
      ],
    );
  }

  // ------------------ OPTION TILE ------------------
  Widget _buildOption(String text) {
    final bool selected = selectedOption == text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => setState(() => selectedOption = text),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? accentTeal.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? accentTeal : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? accentTeal : Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ TEST + OBSERVATION CARD ------------------
  Widget _testCard(String test, String observation) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader("Test"),
            const SizedBox(height: 6),
            Text(
              test,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            const Divider(height: 22),
            _gradientHeader("Observation"),
            const SizedBox(height: 6),
            Text(
              observation,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ GRADIENT TEXT ------------------
  Widget _gradientTitle(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [accentTeal, primaryBlue],
      ).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _gradientHeader(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [accentTeal, primaryBlue],
      ).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
