import 'package:flutter/material.dart';
import 'group4_Ni_ct.dart';
import 'group4_co_ct.dart';
import 'group4_Mn_ct.dart';
import 'group4_zn_ct.dart';
import '../group_5/group5detection_firstanalysis.dart';
import '../c_intro.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class WetTestCPage1 extends StatefulWidget {
  const WetTestCPage1({super.key});

  @override
  State<WetTestCPage1> createState() => _WetTestCPage1State();
}

class _WetTestCPage1State extends State<WetTestCPage1> {
  String? selectedOption; // Group-IV Present / Absent
  String? selectedInference; // Ni²⁺ / Co²⁺ / Mn²⁺ / Zn²⁺
  bool showPage2 = false;

  // Store answers to evaluate later
  Map<String, String> studentAnswers = {};

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
              MaterialPageRoute(builder: (context) => const WetTestIntroCScreen()),
              (route) => false,
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: showPage2 ? _page2Content() : _page1Content(),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: showPage2 ? _page2NavigationBar() : _page1NavigationBar(),
      ),
    );
  }

  Widget _page1Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Group IV Detection",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _testCard(),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
            'Select the correct inference:',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        _buildOption("Group-IV Present"),
        _buildOption("Group-IV Absent"),
      ],
    );
  }

  Widget _page1NavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('Previous', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton.icon(
          onPressed: selectedOption != null
              ? () {
                  // Save student choice for Page1
                  studentAnswers['GroupIV'] = selectedOption!;

                  if (selectedOption == "Group-IV Present") {
                    setState(() {
                      showPage2 = true;
                      selectedInference = null;
                    });
                  } else {
                    // Absent → go to Group V
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const GroupVPage()));
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedOption != null ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: const StadiumBorder(),
          ),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

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
            color: selected ? accentTeal.withOpacity(0.1) : Colors.white,
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

  Widget _testCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader("Test"),
            const SizedBox(height: 4),
            const Text(
              "O.S / Filtrate + NH₄Cl (equal) + NH₄OH (till alkaline to litmus) + passing H₂S gas or water.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
            ),
            const Divider(height: 22),
            _gradientHeader("Observation"),
            const SizedBox(height: 6),
            // Page1 generic observation
            const Text(
              "No ppt",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryBlue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientHeader(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _page2Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Analysis of Group IV",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _testCardPage2(),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: const Text(
            'Select the correct inference:',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        _buildInferenceOption("Ni²⁺"),
        _buildInferenceOption("Co²⁺"),
        _buildInferenceOption("Mn²⁺"),
        _buildInferenceOption("Zn²⁺"),
      ],
    );
  }

  Widget _testCardPage2() {
    String observation = "No ppt"; // default
    if (selectedInference != null) {
      switch (selectedInference) {
        case "Ni²⁺":
          observation = "Green ppt";
          break;
        case "Co²⁺":
          observation = "Pink ppt";
          break;
        case "Mn²⁺":
          observation = "White ppt, turns brown on standing";
          break;
        case "Zn²⁺":
          observation = "White ppt, soluble in excess NH₄OH";
          break;
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _gradientHeader("Test"),
          const SizedBox(height: 4),
          const Text(
            "O.S / Filtrate + NH₄Cl (equal) + NH₄OH (till alkaline to litmus) + passing H₂S gas or water.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
          ),
          const Divider(height: 22),
          _gradientHeader("Observation"),
          const SizedBox(height: 6),
          Text(
            observation,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryBlue),
          ),
        ]),
      ),
    );
  }

  Widget _page2NavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              showPage2 = false;
              selectedInference = null;
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('Previous', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton.icon(
          onPressed: selectedInference != null
              ? () {
                  // Save student answer
                  studentAnswers['GroupIV_Cation'] = selectedInference!;
                  // Redirect to corresponding CT page even if wrong
                  if (selectedInference == "Ni²⁺") {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const Ni2ConfirmedPage()));
                  } else if (selectedInference == "Co²⁺") {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const Co2ConfirmedPage()));
                  } else if (selectedInference == "Mn²⁺") {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const Mn2ConfirmedPage()));
                  } else if (selectedInference == "Zn²⁺") {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const Zn2ConfirmedPage()));
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedInference != null ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: const StadiumBorder(),
          ),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildInferenceOption(String text) {
    final bool selected = selectedInference == text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => setState(() => selectedInference = text),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? accentTeal.withOpacity(0.1) : Colors.white,
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
}
