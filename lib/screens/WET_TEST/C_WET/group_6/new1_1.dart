import 'package:flutter/material.dart';
import 'new1_2.dart'; // Import the next page

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class New1_1Page extends StatefulWidget {
  const New1_1Page({super.key});

  @override
  State<New1_1Page> createState() => _New1_1PageState();
}

class _New1_1PageState extends State<New1_1Page> {
  String? selectedOptionPage1;
  String? selectedOptionPage2;
  bool showPage2 = false;

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
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: const Text(
            'Salt C: Wet Test',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: showPage2 ? _page2() : _page1(),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _buildNavigationBar(),
      ),
    );
  }

  // ================= PAGE 1 =================
  Widget _page1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Group VI Detection",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          // Test Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Test",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
                  SizedBox(height: 6),
                  Text(
                    "O.S / Filtrate + NH₄Cl (equal) + NH₄OH (till alkaline to litmus) + Na₂HPO₄",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600, color: primaryBlue),
                  ),
                  Divider(height: 22),
                  Text("Observation",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
                  SizedBox(height: 6),
                  Text("No ppt",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600, color: primaryBlue)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildOption("Group-VI present", isPage1: true),
          _buildOption("Group-VI absent", isPage1: true),
        ],
      ),
    );
  }

  // ================= PAGE 2 =================
  Widget _page2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Analysis of Group VI ",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Test",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
                  SizedBox(height: 6),
                  Text("Group VI white ppt + dil. HCl",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600, color: primaryBlue)),
                  Divider(height: 22),
                  Text("Observation",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: primaryBlue)),
                  SizedBox(height: 6),
                  Text("Clear solution is obtained",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600, color: primaryBlue)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildOption("Mg²⁺ present", isPage1: false),
        ],
      ),
    );
  }

  // ================= NAVIGATION BAR =================
  Widget _buildNavigationBar() {
    bool isPage1 = !showPage2;
    bool nextButtonEnabled = isPage1 ? selectedOptionPage1 != null : selectedOptionPage2 != null;

    void onPreviousPressed() {
      if (isPage1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showPage2 = false;
          selectedOptionPage2 = null;
        });
      }
    }

    void onNextPressed() {
      if (isPage1) {
        if (selectedOptionPage1 == "Group-VI present") {
          setState(() {
            showPage2 = true;
          });
        } else if (selectedOptionPage1 == "Group-VI absent") {
          // Navigate to your Group V page if needed
        }
      } else if (selectedOptionPage2 != null) {
        if (selectedOptionPage2 == "Mg²⁺ present") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const New1_2Page()),
          );
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onPreviousPressed,
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('Previous', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton.icon(
          onPressed: nextButtonEnabled ? onNextPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: nextButtonEnabled ? primaryBlue : Colors.grey.shade400,
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

  // ================= OPTION BUILDER =================
  Widget _buildOption(String text, {required bool isPage1}) {
    final selected = isPage1 ? selectedOptionPage1 == text : selectedOptionPage2 == text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => setState(() {
          if (isPage1) {
            selectedOptionPage1 = text;
          } else {
            selectedOptionPage2 = text;
          }
        }),
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
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
