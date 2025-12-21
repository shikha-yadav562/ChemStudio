import 'package:flutter/material.dart';
import 'group4_analysis.dart';
import '../group_5/group5_detection.dart';
import '../d_intro.dart';

import 'package:ChemStudio/screens/WET_TEST/C_WET/group0/group0analysis.dart';

// --- Theme Constants ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class saltDGroup4DetectionScreen extends StatefulWidget {
  const saltDGroup4DetectionScreen({super.key});

  @override
  State<saltDGroup4DetectionScreen> createState() => _saltDGroup4DetectionScreenState();
}

class _saltDGroup4DetectionScreenState extends State<saltDGroup4DetectionScreen>
    with SingleTickerProviderStateMixin {
  String? selectedOption;

  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;

  // Group IV Content
  late final WetTestItem _test = WetTestItem(
    id: 10,
    title: 'Group IV Detection',
    procedure:
        'O.S / Filtrate + NH₄Cl (equal) + NH₄OH (till alkaline to litmus) + passing H₂S gas or water.',
    observation: 'No Ppt',
    options: ['Group-IV Present', 'Group-IV Absent'],
    correct: 'Group-IV Present',
  );

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

  // Navigation logic for Next button
  void _next() {
    if (selectedOption == "Group-IV Present") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const saltDgroup4_analysis()),
      );
    } else if (selectedOption == "Group-IV Absent") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const saltD_Group5DetectionScreen()),
      );
    }
  }

  // Navigation logic for Bottom Back button
  void _prev() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ---------------- UI Helpers ----------------
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

  Widget _buildTestCard(WetTestItem test) {
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
            Text(
              test.procedure,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Divider(height: 22),
            _gradientHeader("Observation"),
            const SizedBox(height: 6),
            Text(
              test.observation,
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
              fontSize: 15,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? accentTeal : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Build ----------------
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
            // Updated to go back to Intro Page and clear the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WetTestIntroDScreen()), 
              (route) => false,
            );
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue]).createShader(bounds),
          child: Text(
            'Salt D : Wet Test',
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _test.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: primaryBlue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTestCard(_test),
                const SizedBox(height: 16),
                _gradientHeader('Select the correct inference:'),
                const SizedBox(height: 10),
                ..._test.options.map(_buildOption).toList(),
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
            TextButton.icon(
              onPressed: _prev, // Standard back button to previous step
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            ),
            ElevatedButton.icon(
              onPressed: selectedOption != null ? _next : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption != null ? primaryBlue : Colors.grey.shade400,
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