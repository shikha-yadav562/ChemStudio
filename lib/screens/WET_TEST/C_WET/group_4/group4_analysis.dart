import 'package:flutter/material.dart';
import 'group4_Ni_ct.dart';
import 'group4_co_ct.dart';
import 'group4_Mn_ct.dart';
import 'group4_zn_ct.dart';
import '../c_intro.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class group4_analysis extends StatefulWidget {
  const group4_analysis({super.key});

  @override
  State<group4_analysis> createState() => _group4_analysisState();
}

class _group4_analysisState extends State<group4_analysis>
    with SingleTickerProviderStateMixin {
  String? selectedInference;

  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeSlide = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  void _next() {
    if (selectedInference == "Ni²⁺") {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const Ni2ConfirmedPage()));
    } else if (selectedInference == "Co²⁺") {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const Co2ConfirmedPage()));
    } else if (selectedInference == "Mn²⁺") {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const Mn2ConfirmedPage()));
    } else if (selectedInference == "Zn²⁺") {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const Zn2ConfirmedPage()));
    }
  }

  // Bottom Previous button behavior
  void _prev() {
    Navigator.pop(context);
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

  Widget _buildTestCard() {
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
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Divider(height: 22),
            _gradientHeader("Observation"),
            const SizedBox(height: 6),
            const Text(
              "No ppt",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryBlue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String text) {
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
            border: Border.all(color: selected ? accentTeal : Colors.grey.shade300, width: 1.5),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? accentTeal : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

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
            // AppBar back always goes to intro page
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WetTestIntroCScreen()),
              (route) => false,
            );
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: const Text(
            'Salt C : Wet Test',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeSlide,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.1, 0.03), end: Offset.zero)
              .animate(_fadeSlide),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Analysis of Group IV",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTestCard(),
                const SizedBox(height: 16),
                _gradientHeader("Select the correct inference:"),
                const SizedBox(height: 10),
                _buildOption("Ni²⁺"),
                _buildOption("Co²⁺"),
                _buildOption("Mn²⁺"),
                _buildOption("Zn²⁺"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bottom Previous keeps original behavior
            TextButton.icon(
              onPressed: _prev,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            ),
            ElevatedButton.icon(
              onPressed: selectedInference != null ? _next : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedInference != null ? primaryBlue : Colors.grey.shade400,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
